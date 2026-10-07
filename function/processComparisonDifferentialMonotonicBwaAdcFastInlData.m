function adcStaticPerformanceMetrics = processComparisonDifferentialMonotonicBwaAdcFastInlData( p,  conversionResult )

  %% allocate storage for simulation data
  codeCount = nan( 2 .^ p.adcResolution, 3 );
  dnlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  rawInlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  inlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  finalCodeResult = nan( 2 .^ p.adcResolution - 1, 3 );

  %% calculate ideal LSB and edges

  edges = -0.5 : 1 : 2 .^ ( p.adcResolution ) - 0.5;

  for iTopology = 1 : 3

    %% find actual hits of each code

    codeCount( :, iTopology ) = histcounts( conversionResult( :, iTopology ), edges ) .';

    %% remove unwanted codes and fill empty codes

    for iCodePower = 1 : p.adcResolution - 1

      finalCodeResult( 2 .^ iCodePower : 2 .^ ( iCodePower + 1 ) : end, iTopology ) = codeCount( 2 .^ iCodePower, iTopology );
      finalCodeResult( 2 .^ iCodePower + 1 : 2 .^ ( iCodePower + 1 ) : end, iTopology ) = codeCount( 2 .^ iCodePower + 1, iTopology );

    end

    %% calculate DNL and INL

    dnlResult( :, iTopology ) = finalCodeResult( 2 : end, iTopology ) / p.fastSamplesPerStair - 1;
    rawInlResult( :, iTopology ) = cumsum( dnlResult( :, iTopology ) );
    fitCoefficient = polyfit( 1 : 2 .^ p.adcResolution - 2, rawInlResult( :, iTopology ) .' , 1 );
    inlResult( :, iTopology ) = rawInlResult( :, iTopology ) - fitCoefficient( 1 ) * (1 : 2 .^ p.adcResolution - 2) .' - fitCoefficient( 2 );
  end
  %% save the result

  adcStaticPerformanceMetrics.dnlResult = dnlResult;
  adcStaticPerformanceMetrics.inlResult = inlResult;
  adcStaticPerformanceMetrics.dnlCodeIndex = 1 : 2 .^ p.adcResolution - 2;
  adcStaticPerformanceMetrics.inlCodeIndex = 1 : 2 .^ p.adcResolution - 2;


end
