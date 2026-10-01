function adcStaticPerformanceMetrics = processDifferentialAdcTransitionData( p, sineWave, conversionResult )

  %% find actual hits of each code

  edges = -0.5 : 1 : 2 .^ ( p.adcResolution ) - 0.5;
  codeCount = histcounts( conversionResult, edges );

  %% compile cumulative histogram

  cumCount = cumsum( codeCount );

  %% determine transition voltage

  transitionVoltage = - p.inputAmplitude * cos( pi * cumCount( 1 : end - 1 ) / sineWave.numOfSamples );

  %% calculate endpoint LSB

  numTransition = length( transitionVoltage );
  voltageLSB = ( transitionVoltage( end ) - transitionVoltage( 1 ) ) / ( numTransition - 1 );

  %% calculate DNL and INL

  codeWidth = diff( transitionVoltage ) ;
  dnlResult = codeWidth / voltageLSB - 1;
  inlResult = cumsum( dnlResult );

  %% save the result

  adcStaticPerformanceMetrics.dnlResult = dnlResult;
  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.dnlCodeIndex = 1 : length( dnlResult );
  adcStaticPerformanceMetrics.inlCodeIndex = 1 : length( inlResult );
  
  disp( inlResult( 1 ) );
  disp( inlResult( end ) );
  
end
