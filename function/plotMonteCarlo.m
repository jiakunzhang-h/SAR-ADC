function mcObj = plotMonteCarlo( p, enobMCResult )

  %% plot Monte Carlo result

  mcObj = figure;
  meanEnob = mean( enobMCResult );
  stdEnob = std( enobMCResult );
  h = histfit( enobMCResult, [], 'kernel' );
  h( 2 ).Color = 'r';
  h( 2 ).LineWidth = 2.5;
  xlabel( 'ENOB' );
  ylabel( 'Count' );
  xlim( [min( enobMCResult ) - 0.05, p.adcResolution] );
  title( "Monte Carlo ENOB Distribution" );

  %% display Monte Carlo statistics

  statisticsText = sprintf( 'N = %d\nMean = %.2f bits\nStd = %.2f bits', p.numMonteCarlo, meanEnob, stdEnob );
  text( 0.03, 0.95, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  grid on;

end
