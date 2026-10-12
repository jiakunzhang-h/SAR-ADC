function adcStaticPerformanceMetrics = processDifferentialBinarySearchData( p, positiveCapArray, negativeCapArray )
  %% calculate voltage LSB

  voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;
  %% calculate number of codes and iterations

  numIterations = ceil( log2( ( p.vFS ) / ( p.voltageTolerance * voltageLSB ) ) );

  %% allocate transition voltage storage

  transitionVoltage = nan( 1, 2 .^ p.adcResolution - 1 );

  %% determine all the transition voltages

  for iTransition = 1 : 2 .^ p.adcResolution - 1

    %% determine the lowest voltage and the highest voltage

    lowVoltage = - p.inputAmplitude;
    highVoltage = p.inputAmplitude;

    %% binary search by iteration

    for iIteration = 1 : numIterations
      voltageMiddle = ( lowVoltage + highVoltage ) / 2;

      %% generate differential input

      samplePositive = p.vcm + voltageMiddle / 2;
      sampleNegative = p.vcm - voltageMiddle / 2;

      %% run ADC conversion

      conversionResult = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
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
  %% calculate DNL and INL

  codeWidth = diff( transitionVoltage ) ;
  dnlResult = codeWidth / voltageLSB - 1;
  rawInlResult = cumsum( dnlResult );

  %% the best-fit straight line

  fitCoefficient = polyfit( 1 : 2 .^ p.adcResolution - 2, rawInlResult, 1 );
  inlResult = rawInlResult - fitCoefficient( 1 ) * (1 : 2 .^ p.adcResolution - 2) - fitCoefficient( 2 );

  %% save the result

  adcStaticPerformanceMetrics.dnlResult = dnlResult;
  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.dnlCodeIndex = 1 : length( dnlResult );
  adcStaticPerformanceMetrics.inlCodeIndex = 1 : length( inlResult );

end