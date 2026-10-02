function adcStaticPerformanceMetrics = processAdcFastInlData( p, conversionResult )

  %% find actual hits of each code

  edges = -0.5 : 1 : 2 .^ p.adcResolution - 0.5;
  codeCount = histcounts( conversionResult, edges );

  %% remove unwanted codes and fill empty codes

  finalCodeResult = nan( 1, 2 .^ p.adcResolution - 1 );

  for iCodePower = 0 : p.adcResolution - 1 

    finalCodeResult( 2 .^ iCodePower : 2 .^ ( iCodePower + 1 ) : end ) = codeCount( 2 .^ iCodePower );

  end

  %% calculate DNL and INL

  dnlResult = finalCodeResult( 2 : end ) / p.samplesPerStair - 1;
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
