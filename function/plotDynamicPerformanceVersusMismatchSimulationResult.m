function obj = plotDynamicPerformanceVersusMismatchSimulationResult( p, enobResult )

  %% create figure

  obj = figure;

  %% define marker styles and legend text for different architectures

  if size( enobResult, 1 ) == 5
    lineStyle = {'-o', '-x', '-^', '-s', '-d'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture', 'SBW Architecture'};
  else
    lineStyle = {'-o', '-x', '-^', '-s'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture'};
  end

  %% plot different architectures

  for iTopology = 1 : size( enobResult, 1 )
    plot( p.mismatchStdList * 100, enobResult( iTopology, : ), lineStyle{ iTopology }, 'Color', 'b', 'LineWidth', 2.5, 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b' );
    hold on;
  end

  %% configure axes

  xlabel( 'Mismatch Standard Deviation (%)' );
  ylabel( 'ENOB ' );
  title( 'ENOB vs. Mismatch Standard Deviation Comparison' );

  xlim( [min( p.mismatchStdList ) - 0.005, max( p.mismatchStdList ) + 0.005] * 100 );

  %% display legend

  legend( legendText, 'Location', 'best' );

  %% configure grid and format

  grid on;

end