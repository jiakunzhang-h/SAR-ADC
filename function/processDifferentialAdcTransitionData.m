function adcStaticPerformanceMetrics = processDifferentialAdcTransitionData( p, sineWave, conversionResult )

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;

  %% find actual hits of each code

  edges = -0.5 : 1 : 2 .^ ( p.adcResolution + 1 ) - 0.5;
  codeCount = histcounts( conversionResult, edges );

  %% compile cumulative histogram

  cumCount = cumsum( codeCount );

  %% determine transition voltage

  transitionVoltage = - p.inputAmplitude * cos( pi * cumCount( 1 : end - 1 ) / sineWave.numOfSamples );

  %% calculate DNL and INL

  codeWidth = diff( transitionVoltage ) ;
  dnlResult = codeWidth / voltageLSB - 1;
  inlResult = cumsum( dnlResult );

  %% save the result

  adcStaticPerformanceMetrics.dnlResult = dnlResult;
  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.dnlCodeIndex = 1 : 2 .^ ( p.adcResolution + 1 ) - 2;
  adcStaticPerformanceMetrics.inlCodeIndex = 1 : 2 .^ ( p.adcResolution + 1 ) - 2;

end
