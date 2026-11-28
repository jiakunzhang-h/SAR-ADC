function adcStaticPerformanceMetrics = processDifferentialBinarySearchData( p, capArray, adcConversionFunction )

  %% calculate number of codes and iterations

  numIterations = ceil( log2( ( 2 * p.vRef ) / ( p.voltageTolerance * p.voltageLSB ) ) );

  %% allocate transition voltage storage

  transitionVoltage = nan( 1, 2 .^ p.adcResolution - 1 );

  %% determine all the transition voltages

  for iTransition = 1 : 2 .^ p.adcResolution - 1

    %% determine the lowest voltage and the highest voltage

    lowVoltage = - p.vRef;
    highVoltage = p.vRef;

    %% binary search by iteration

    for iIteration = 1 : numIterations
      voltageMiddle = ( lowVoltage + highVoltage ) / 2;

      %% generate differential input

      samplePositive = p.vcm + voltageMiddle / 2;
      sampleNegative = p.vcm - voltageMiddle / 2;

      %% run ADC conversion

      conversionResult = adcConversionFunction( samplePositive, sampleNegative, p, capArray );
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

  allTransitionVoltage = [ -p.vRef, transitionVoltage, p.vRef ];

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