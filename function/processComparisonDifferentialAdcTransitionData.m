function adcStaticPerformanceMetrics = processComparisonDifferentialAdcTransitionData( p, sineWave, conversionResult )

  %% allocate storage for simulation data
  codeCount = nan( 2 .^ p.adcResolution, 3 );
  cumCount = nan( 2 .^ p.adcResolution, 3 );
  transitionVoltage = nan( 2 .^ p.adcResolution - 1, 3 );
  codeWidth = nan( 2 .^ p.adcResolution - 2, 3 );
  dnlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  rawInlResult = nan( 2 .^ p.adcResolution - 2, 3 );
  inlResult = nan( 2 .^ p.adcResolution - 2, 3 );

  %% calculate ideal LSB and edges

  voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;
  edges = -0.5 : 1 : 2 .^ ( p.adcResolution ) - 0.5;

  for iTopology = 1 : 3

    %% find actual hits of each code

    codeCount( :, iTopology ) = histcounts( conversionResult( :, iTopology ), edges ) .';

    %% compile cumulative histogram

    cumCount( :, iTopology ) = cumsum( codeCount( :, iTopology ) );

    %% determine transition voltage

    transitionVoltage( :, iTopology ) = - p.inputAmplitude * cos( pi * cumCount( 1 : end - 1, iTopology ) / sineWave.numOfSamples );

    %% calculate DNL and INL

    codeWidth( :, iTopology ) = diff( transitionVoltage( :, iTopology ) ) ;
    dnlResult( :, iTopology ) = codeWidth( :, iTopology ) / voltageLSB - 1;
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
