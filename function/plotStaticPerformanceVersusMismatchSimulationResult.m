function [dnlObj, inlObj] = plotStaticPerformanceVersusMismatchSimulationResult( p, inlMaxResult, dnlMaxResult )

  %% define marker styles and legend text for different architectures

  if size( inlMaxResult, 1 ) == 5
    lineStyle = {'-o', '-x', '-^', '-s', '-d'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture', 'SBW Architecture'};
  else
    lineStyle = {'-o', '-x', '-^', '-s'};
    legendText = {'BWA Architecture Type 1', 'BWA Architecture Type 2', 'BWA Architecture Type 3', 'CBW Architecture'};
  end

  %% plot DNL

  dnlObj = figure;

  %% plot different architectures

  for iTopology = 1 : size( dnlMaxResult, 1 )
    plot( p.mismatchStdList * 100, dnlMaxResult( iTopology, : ), lineStyle{ iTopology }, 'Color', 'b', 'LineWidth', 2.5, 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b' );
    hold on;
  end

  %% configure axes

  xlabel( 'Mismatch Standard Deviation (%)' );
  ylabel( 'Max |DNL| (LSB)' );
  title( 'DNL max vs. Mismatch Standard Deviation Comparison' );
  allDnlResult = dnlMaxResult( : );
  xlim( [min( p.mismatchStdList ) - 0.005, max( p.mismatchStdList ) + 0.005] * 100 );
  ylim( [0, 1.3 * max( allDnlResult )] );

  %% display legend

  legend( legendText, 'Location', 'northwest' );

  %% configure grid and format

  grid on;

  %% plot INL

  inlObj = figure;

  %% plot different architectures

  for iTopology = 1 : size( inlMaxResult, 1 )
    plot( p.mismatchStdList * 100, inlMaxResult( iTopology, : ), lineStyle{ iTopology }, 'Color', 'b', 'LineWidth', 2.5, 'MarkerSize', 7, 'MarkerFaceColor', 'w', 'MarkerEdgeColor', 'b' );
    hold on;
  end

  %% configure axes

  xlabel( 'Mismatch Standard Deviation (%)' );
  ylabel( 'Max |INL| (LSB)' );
  title( 'INL max vs. Mismatch Standard Deviation Comparison' );
  allInlResult = inlMaxResult( : );
  xlim( [min( p.mismatchStdList ) - 0.005, max( p.mismatchStdList ) + 0.005] * 100 );
  ylim( [0, 1.3 * max( allInlResult )] );

  %% display legend

  legend( legendText, 'Location', 'northwest' );

  %% configure grid and format

  grid on;


end