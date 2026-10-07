function adcStaticPerformanceMetrics = processComparisonDifferentialMonotonicBwaAdcHistogramData( p,  conversionResult )

  %% allocate storage for simulation data
  codeCount = nan( 2 .^ p.adcResolution, 3 );
  dnlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  inlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  gainError = nan( 3, 1 );
  offsetError = nan( 3, 1 );

  %% calculate ideal LSB and edges

  edges = -0.5 : 1 : 2 .^ ( p.adcResolution ) - 0.5;

  for iTopology = 1 : 3

    %% find actual hits of each code

    codeCount( :, iTopology ) = histcounts( conversionResult( :, iTopology ), edges ) .';

    %% calculate DNL and INL

    dnlResult( :, iTopology ) = codeCount( 2 : end - 1, iTopology ) / p.samplesPerStair - 1;
    inlResult( :, iTopology ) = cumsum( dnlResult( :, iTopology ) );
    fitCoefficient = polyfit( 1 : 2 .^ p.adcResolution - 2, inlResult( :, iTopology ) .' , 1 );
    gainError( iTopology ) = fitCoefficient( 1 ) * 100;
    offsetError( iTopology ) = fitCoefficient( 2 );
  end

  %% save the result

  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.inlCodeIndex = 1 : 2 .^ p.adcResolution - 2;
  adcStaticPerformanceMetrics.gainError = gainError;
  adcStaticPerformanceMetrics.offsetError = offsetError;

end
