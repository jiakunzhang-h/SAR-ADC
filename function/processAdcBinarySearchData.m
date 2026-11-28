function adcStaticPerformanceMetrics = processAdcBinarySearchData( p, capArray, conversionFunction )

  %% calculate number of codes and iterations

  numIterations = ceil( log2( ( p.vRef ) / ( p.voltageTolerance * p.voltageLSB ) ) );

  %% allocate transition voltage storage

  transitionVoltage = nan( 1, 2 .^ p.adcResolution - 1 );

  %% determine all the transition voltages

  for iTransition = 1 : 2 .^ p.adcResolution - 1

    %% determine the lowest voltage and the highest voltage

    lowVoltage = 0;
    highVoltage = p.vRef;

    %% binary search by iteration

    for iIteration = 1 : numIterations

      voltageMiddle = ( lowVoltage + highVoltage ) / 2;

      %% run ADC conversion

      conversionResult = conversionFunction( voltageMiddle, p, capArray );
      outputCode = round( idealDAC( conversionResult ) );

      %% update search interval

      if outputCode >= iTransition
        highVoltage = voltageMiddle;
      else
        lowVoltage = voltageMiddle;
      end

    end

    %% save transition voltage

    transitionVoltage( iTransition ) = ( lowVoltage + highVoltage ) / 2;

  end

  %% add the first and last transition voltage

  allTransitionVoltage = [ 0, transitionVoltage, p.vRef ];

  %% calculate DNL

  codeWidth = diff( allTransitionVoltage );
  dnlResult = codeWidth / p.voltageLSB - 1;

  %% calculate raw INL

  inlResult = [ 0, cumsum( dnlResult ) ];

  %% save code index

  adcStaticPerformanceMetrics.dnlResult = dnlResult;
  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.dnlCodeIndex = 0 : 2 .^ p.adcResolution - 1;
  adcStaticPerformanceMetrics.inlCodeIndex = 0 : 2 .^ p.adcResolution;
end