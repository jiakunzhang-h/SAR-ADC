function energyObj = plotDifferentialAdcSwitchingEnergySimulationResult( p, switchingEnergyResult, dacOutput )

  %% plot switching energy

  energyObj = figure;
  numMarkers = 50;
  lineColor = {'b', 'r', 'g', 'c', 'm', 'm'};
  lineStyle = {'-o', '-x', '-^', '-s', '-d', '-v'};
  legendText = {'Conventional', 'Split Capacitor', 'Energy Saving', 'Monotonic', 'Merged Capacitor', 'Inverted Merged Capacitor'};

  %% plot different architectures

  for iTopology = 1 : size( switchingEnergyResult, 2 )
    plot( dacOutput( :, iTopology ), switchingEnergyResult( :, iTopology ), lineStyle{ iTopology }, 'Color', lineColor{ iTopology }, ...
      'LineWidth', 2.5, 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', lineColor{ iTopology }, ...
      'MarkerIndices', round( linspace( 1, size( switchingEnergyResult, 1 ), numMarkers ) ) );
    hold on;
  end

  %% set plot properties

  xlabel( 'Output Code' );
  ylabel( 'Switching Energy [CV_{ref}^2]' );
  title( ['Different Switching Schemes Energy versus Output Code Comparison (', num2str( p.adcResolution ), '-bit)'] );
  legend( legendText, 'Location', 'best' );
  xlim( [0, 2 .^   ( p.adcResolution ) ] );
  totalSwitchingEnergyResult = switchingEnergyResult( : );
  ylim( [0, 1.3 * max( totalSwitchingEnergyResult )] );
  grid on;


end