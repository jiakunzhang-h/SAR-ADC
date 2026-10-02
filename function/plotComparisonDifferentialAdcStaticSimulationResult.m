function [dnlObj, inlObj] = plotComparisonDifferentialAdcStaticSimulationResult( p, adcStaticPerformanceMetrics )

  %% plot DNL

  dnlObj = figure;

  %% plot type one dnl

  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlResult( : , 1 ), 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot type two dnl

  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlResult( : , 2 ), 'r--', 'LineWidth', 2.5 );

  %% plot type three dnl

  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlResult( : , 3 ), 'g--', 'LineWidth', 2.5 );

  %% construct dnl result matrix

  dnlResultMatrix = [adcStaticPerformanceMetrics.dnlResult( :, 1 ), adcStaticPerformanceMetrics.dnlResult( :, 2 ), adcStaticPerformanceMetrics.dnlResult( :, 3 )];
  legendText = {'Sub Cap Array with Dummy Cap', 'Main Cap Array with Dummy Cap', 'Both Arrays without Dummy Cap'};

  %% find the maximum DNL

  maxDnlResult = max( abs( dnlResultMatrix ), [], 1 );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( 'DNL (LSB)' );
  title( 'ADC DNL comparison' );
  legend( legendText, 'Location', 'southeast' );
  statisticsText = sprintf( 'mismatch = %.2f %% comparator input referred noise = %.0f uV \n Type-1 DNL max = %.2f LSB Type-2 DNL max = %.2f LSB Type-3 DNL max = %.2f LSB', p.mismatchStd * 100, p.compNoise * 1e6, maxDnlResult( 1 ), maxDnlResult( 2 ), maxDnlResult( 3 ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [1.2 * min( dnlResultMatrix, [], 'all' ), 1.2 * max( dnlResultMatrix, [], 'all' )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot type one inl

  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlResult( : , 1 ), 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot type two inl

  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlResult( : , 2 ), 'r--', 'LineWidth', 2.5 );

  %% plot type three inl

  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlResult( : , 3 ), 'g--', 'LineWidth', 2.5 );

  %% construct inl result matrix

  inlResultMatrix = [adcStaticPerformanceMetrics.inlResult( :, 1 ), adcStaticPerformanceMetrics.inlResult( :, 2 ), adcStaticPerformanceMetrics.inlResult( :, 3 )];
  legendText = {'Sub Cap Array with Dummy Cap', 'Main Cap Array with Dummy Cap', 'Both Arrays without Dummy Cap'};

  %% find the maximum deviation

  maxInlResult = max( abs( inlResultMatrix ), [], 1 );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'ADC INL comparison' );
  legend( legendText, 'Location', 'southeast' );
  statisticsText = sprintf( 'mismatch = %.2f %% comparator input referred noise = %.0f uV \n Type-1 INL max = %.2f LSB Type-2 INL max = %.2f LSB Type-3 INL max = %.2f LSB ', p.mismatchStd * 100, p.compNoise * 1e6, maxInlResult( 1 ), maxInlResult( 2 ), maxInlResult( 3 ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [1.2 * min( inlResultMatrix, [], 'all' ), 1.2 * max( inlResultMatrix, [], 'all' )] );
  grid on;


end