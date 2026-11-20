function energyObj = plotDifferentialAdcSwitchingEnergyVersusResolutionSimulationResult( p, averageSwitchingEnergy, resolutionArray )

  %% plot switching energy

  energyObj = figure;
  lineColor = {'b', 'r', 'g', 'k', 'm', 'm'};
  legendText = {'Conventional', 'Split Capacitor', 'Energy Saving', 'Monotonic', 'Merged Capacitor', 'Inverted Merged Capacitor'};

  %% plot different architectures

  for iTopology = 1 : size( averageSwitchingEnergy, 2 )
    semilogy( resolutionArray, averageSwitchingEnergy( :, iTopology ), 'Color', lineColor{ iTopology }, 'LineWidth', 2.5 );
    hold on;
  end

  %% set plot properties

  xlabel( 'Number of Bits' );
  ylabel( 'Normalized Switching Energy [CV_{ref}^2]' );
  title( ['Different Switching Schemes Energy versus Resolution Comparison '] );
  legend( legendText, 'Location', 'northwest' );
  xticks( 1 : 15 );
  xlim( [0, 15] );
  totalSwitchingEnergyResult = averageSwitchingEnergy( : );
  ylim( [0, 1.5 * max( totalSwitchingEnergyResult )] );
  grid on;


end