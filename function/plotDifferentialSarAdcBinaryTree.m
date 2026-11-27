function traceObj = plotDifferentialSarAdcBinaryTree( p, numSamples, decisionVoltage )

  %% figure initialization

  traceObj = figure( 'Color', 'w' );
  hold on;

  %% determine conversion cycle

  conversionCycle = 1 : p.adcResolution + 1;

  %% plot decision paths

  for iSample = 1 : numSamples

    plot( decisionVoltage( iSample, : ), conversionCycle, ...
      'Color', 'b', 'LineWidth', 2.5 );

  end

  %% phase labels

  numPhase = 2 ^ p.adcResolution;
  phaseLabel = strings( 1, numPhase );

  for iPhase = 1 : numPhase

    phaseLabel( iPhase ) = ...
      string( dec2bin( iPhase - 1, p.adcResolution ) );

  end

  %% calculate digital word positions

  phasePosition = -p.vRef + ...
    ( ( 0 : numPhase - 1 ) + 0.5 ) * p.voltageLSB;

  %% calculate phase boundaries

  phaseBoundary = -p.vRef + ...
    ( 1 : numPhase - 1 ) * p.voltageLSB;

  xline( phaseBoundary, ':r', 'HandleVisibility', 'off' );

  %% configure axes

  xlim( [ -p.vRef, p.vRef ] );
  xticks( phasePosition );
  xticklabels( phaseLabel );
  xtickangle( 0 );

  ylim( [ 0.75, p.adcResolution + 1 ] );
  yticks( conversionCycle );

  set( gca, 'YDir', 'reverse' );

  %% plot settings

  title( 'SAR ADC Binary Decision Tree' );
  statisticsText = sprintf( 'mismatch = %.2f %% ', p.mismatchStd * 100 );
  text( 0.01, 0.95, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  
  xlabel( 'Digital Output Code' );
  ylabel( 'Decision Level' );

  grid off;
  box on;

  hold off;

end