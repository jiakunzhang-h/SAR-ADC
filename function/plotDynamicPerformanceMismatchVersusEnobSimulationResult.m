function obj = plotDynamicPerformanceMismatchVersusEnobSimulationResult( p, enobResult )

  %% create figure

  obj = figure;

  %% define marker styles and legend text for different architectures

  if size( enobResult, 1 ) == 5
    lineStyle = {'-o', '-x', '-^', '-s', '-d'};
    lineColor = {'b', 'r', 'g', 'k', 'm'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture', 'SBW Architecture'};
  else
    lineStyle = {'-o', '-x', '-^', '-s'};
    lineColor = {'b', 'r', 'g', 'm'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture'};
  end

  %% plot different architectures

  for iTopology = 1 : size( enobResult, 1 )
    semilogx( enobResult( iTopology, : ), p.mismatchStdList, lineStyle{ iTopology }, 'Color', lineColor{ iTopology }, 'LineWidth', 2.5, 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', lineColor{ iTopology } );
    hold on;
  end

  %% configure axes

  xlabel( 'ENOB ' );
  ylabel( 'Mismatch Standard Deviation' );
  title( 'ENOB vs. Mismatch Standard Deviation Comparison' );
  totalEnobResult = enobResult( : );
  xlim( [min( totalEnobResult ) * 0.95, max( totalEnobResult ) * 1.05]  );
  ylim( [min( p.mismatchStdList ) - 0.005, max( p.mismatchStdList ) + 0.005]  );

  %% display legend

  legend( legendText, 'Location', 'best' );

  %% configure grid and format

  grid on;

end