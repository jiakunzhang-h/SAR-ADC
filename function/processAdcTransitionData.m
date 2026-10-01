function adcStaticPerformanceMetrics = processAdcTransitionData( p, sineWave, conversionResult )

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;

  %% find actual hits of each code

  edges = -0.5 : 1 : 2 .^  p.adcResolution - 0.5;
  codeCount = histcounts( conversionResult, edges );

  %% compile cumulative histogram

  cumCount = cumsum( codeCount );

  %% determine transition voltage

  transitionVoltage = p.vcm - p.inputAmplitude * cos( pi * cumCount( 1 : end - 1 ) / sineWave.numOfSamples );

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
