
function [inlObj, comprehensionObj, accuracyObj] = plotInlTestMethodComparison( p, timeOfTestList, adcHistogramStaticPerformanceMetrics, adcCodeDensityStaticPerformanceMetrics, adcFastInlStaticPerformanceMetrics, adcBinarySearchStaticPerformanceMetrics )

  %% plot INL

  inlObj = figure;

  %% plot ramp histogram inl

  plot( adcHistogramStaticPerformanceMetrics.inlCodeIndex, adcHistogramStaticPerformanceMetrics.inlResult, 'g-.', 'LineWidth', 2.5 );
  hold on;

  %% plot code density inl

  plot( adcCodeDensityStaticPerformanceMetrics.inlCodeIndex, adcCodeDensityStaticPerformanceMetrics.inlResult, 'b', 'LineWidth', 2.5 );

  %% plot fast inl inl

  plot( adcFastInlStaticPerformanceMetrics.inlCodeIndex, adcFastInlStaticPerformanceMetrics.inlResult, 'r--', 'LineWidth', 2.5 );

  %% plot binary search inl

  plot( adcBinarySearchStaticPerformanceMetrics.inlCodeIndex, adcBinarySearchStaticPerformanceMetrics.inlResult, 'm:', 'LineWidth', 2.5 );

  %% construct inl result matrix

  inlResultMatrix = [adcHistogramStaticPerformanceMetrics.inlResult( : ), adcCodeDensityStaticPerformanceMetrics.inlResult( : ), adcFastInlStaticPerformanceMetrics.inlResult( : ), adcBinarySearchStaticPerformanceMetrics.inlResult( : )];
  topologyName = {'Ramp Histogram Method', 'Code Density Method', 'Fast INL Method', 'Binary Search Method'};
  legendText = {'Ramp Histogram Method', 'Code Density Method', 'Fast INL Method', 'Binary Search Method'};
  allInlResult = inlResultMatrix( : );

  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'Differential ADC INL Comparison' );
  legend( legendText, 'Location', 'best' );

  statisticsText = sprintf( 'mismatch = %.2f %% \n comparator input referred noise = %.0f uV \n INL max = %.2f LSB ', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allInlResult ) ) );
  text( 0.02, 0.99, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [1.2 * min( allInlResult ), 1.5 * max( allInlResult )] );
  grid on;

  
  %% plot accuracy comparison

  accuracyObj = figure;

  for iTopology = 2 : 4

    %% find the maximum deviation

    deviationInlResult = inlResultMatrix( :, iTopology ) - inlResultMatrix( :, 1 );
    [maxInlDeviation, maxInlDeviationIndex] = max( abs( deviationInlResult ) );

    %% calculate RMSE

    rmseInlDeviation = sqrt( mean( deviationInlResult .^ 2 ) );

    %% plot INL error histogram

    subplot( 3, 1, iTopology - 1 );

    histogram( deviationInlResult, 50 );
    hold on;

    xlabel( 'INL Error Compared to Ramp Histogram(LSB)' );
    ylabel( 'Count' );
    title( topologyName{ iTopology } );

    statisticsText = sprintf( 'Max Error = %.4f LSB @ Code %d \n RMSE = %.4f LSB', maxInlDeviation, adcHistogramStaticPerformanceMetrics.inlCodeIndex( maxInlDeviationIndex ), rmseInlDeviation );
    text( 0.99, 0.99, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'right', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );

    grid on;

  end

  %% overall title

  sgtitle( 'INL Test Method Accuracy Comparison' );


  %% plot execution time comparison

  comprehensionObj = figure;

  %% plot execution time

  bar( timeOfTestList );

  %% figure settings

  xticks( 1 : 4 );
  xticklabels( {'Ramp Histogram', 'Code Density', 'Fast INL', 'Binary Search'} );

  xlabel( 'INL Test Method' );
  ylabel( 'Execution Time (s)' );
  title( 'INL Test Method Execution Time Comparison' );

  %% display execution time

  for iTopology = 1 : 4

    text( iTopology, timeOfTestList( iTopology ), sprintf( '%.3f s', timeOfTestList( iTopology ) ), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold' );

  end

  ylim( [0, 1.2 * max( timeOfTestList )] );
  grid on;

end
