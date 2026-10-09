function adcStaticPerformanceMetrics = processDifferentialMonotonicStaticPerformanceVersusMismatchData( p, conversionResult )

  %% allocate storage for simulation data
  codeCount = nan( 2 .^ p.adcResolution, size( conversionResult, 2 ) );
  dnlResult = nan( 2 .^ p.adcResolution - 2, size( conversionResult, 2 ) );
  rawInlResult = nan( 2 .^ p.adcResolution - 2, size( conversionResult, 2 ) );
  inlResult = nan( 2 .^ p.adcResolution - 2, size( conversionResult, 2 ) );
  inlMaxResult = nan( size( conversionResult, 2 ), 1 );
  dnlMaxResult = nan( size( conversionResult, 2 ), 1 );
  finalCodeResult = nan( 2 .^ p.adcResolution - 1, size( conversionResult, 2 ) );
  
  %% calculate ideal LSB and edges

  edges = -0.5 : 1 : 2 .^ ( p.adcResolution ) - 0.5;
  for iTopology = 1 : size( conversionResult, 2 )

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

    %% the best-fit straight line

    fitCoefficient = polyfit( 1 : 2 .^ p.adcResolution - 2, rawInlResult( :, iTopology ) .' , 1 );
    inlResult( :, iTopology ) = rawInlResult( :, iTopology ) - fitCoefficient( 1 ) * (1 : 2 .^ p.adcResolution - 2) .' - fitCoefficient( 2 );
    inlMaxResult( iTopology, 1 ) = max( abs( inlResult( :, iTopology ) ) );
    dnlMaxResult( iTopology, 1 ) = max( abs( dnlResult( :, iTopology ) ) );

  end
  %% save the result

  adcStaticPerformanceMetrics.dnlMaxResult = dnlMaxResult;
  adcStaticPerformanceMetrics.inlMaxResult = inlMaxResult;


