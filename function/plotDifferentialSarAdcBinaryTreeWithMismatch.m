function traceObj = plotDifferentialSarAdcBinaryTreeWithMismatch( p, numSamples, decisionVoltageCell )

  %% figure initialization

  traceObj = figure( 'Color', 'w' );
  hold on;

  %% basic settings

  numMismatches = numel( p.mismatchArray );
  conversionCycle = 1 : p.adcResolution + 1;
  lineColor = { 'b', 'r', 'c' };
  lineStyle = { '-', '--', '-.' };
  lineObj = gobjects( numMismatches, 1 );

  %% plot decision paths

  for iMismatch = 1 : numMismatches
    for iSample = 1 : numSamples
      lineObj( iMismatch ) = plot( decisionVoltageCell{ iMismatch }( iSample, : ), conversionCycle, 'Color', lineColor{ iMismatch }, 'LineStyle', lineStyle{ iMismatch }, 'LineWidth', 2.5 );
    end
  end

  %% generate digital output code labels

  numPhase = 2 ^ p.adcResolution;
  phaseLabel = strings( 1, numPhase );
  for iPhase = 1 : numPhase
    phaseLabel( iPhase ) = string( dec2bin( iPhase - 1, p.adcResolution ) );
  end

  %% calculate digital code positions and boundaries

  phasePosition = -p.vRef + ( ( 0 : numPhase - 1 ) + 0.5 ) * p.voltageLSB;
  phaseBoundary = -p.vRef + ( 1 : numPhase - 1 ) * p.voltageLSB;

  %% plot phase boundaries

  xline( phaseBoundary, ':k', 'HandleVisibility', 'off' );

  %% configure axes

  xlim( [ -p.vRef, p.vRef ] );
  xticks( phasePosition );
  xticklabels( phaseLabel );
  xtickangle( 0 );
  ylim( [ 0.75, p.adcResolution + 1 ] );
  yticks( conversionCycle );
  set( gca, 'YDir', 'reverse' );

  %% add title, labels, and legend

  title( 'SAR ADC Binary Decision Tree' );
  legendText = "Mismatch = " + string( p.mismatchArray );
  legend( lineObj, legendText, 'Location', 'northwest' );
  xlabel( 'Digital Output Code' );
  ylabel( 'Decision Level' );

  %% figure style

  grid off;
  box on;

  hold off;

end