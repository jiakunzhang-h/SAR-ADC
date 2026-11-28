function [dnlObj, inlObj] = plotStaticStandardDeviationComparison( p, adcStaticPerformanceMetrics )

  %% define the specification

  legendText = {'CBW', 'SBW'};

  %% plot DNL

  dnlObj = figure;

  %% plot histogram dnl

  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlStd( :, 1 ), 'b', 'LineWidth', 2.5 );
  hold on;
  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlStd( :, 2 ), 'r--', 'LineWidth', 2.5 );
 
  dnlStdMatrix = adcStaticPerformanceMetrics.dnlStd( : );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( '\sigma_{DNL} (LSB)' );
  title( 'Standard Deviation of DNL Comparison' );
  legend( legendText, 'Location', 'best' );
  statisticsText = sprintf( 'N = %d\nmismatch = %.2f %% \n comparator input referred noise = %.0f uV \n CBW \\sigma_{DNL} max = %.2f LSB\n SBW \\sigma_{DNL} max = %.2f LSB', p.numMonteCarlo, p.mismatchStd * 100, p.compNoise * 1e6, max( adcStaticPerformanceMetrics.dnlStd( :, 1 ) ), max( adcStaticPerformanceMetrics.dnlStd( :, 2 ) ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [0, 1.3 * max( dnlStdMatrix )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot histogram inl

  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlStd( :, 1 ), 'b', 'LineWidth', 2.5 );
  hold on;
  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlStd( :, 2 ), 'r--', 'LineWidth', 2.5 );
 
  inlStdMatrix = adcStaticPerformanceMetrics.inlStd( : );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( '\sigma_{INL} (LSB)' );
  legend( legendText, 'Location', 'best' );
  title( 'Standard Deviation of INL Comparison' );
  statisticsText = sprintf( 'N = %d\nmismatch = %.2f %% \n comparator input referred noise = %.0f uV \n CBW \\sigma_{INL} max = %.2f LSB\n SBW \\sigma_{INL} max = %.2f LSB', p.numMonteCarlo, p.mismatchStd * 100, p.compNoise * 1e6, max( adcStaticPerformanceMetrics.inlStd( :, 1 ) ), max( adcStaticPerformanceMetrics.inlStd( :, 2 ) ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [0, 1.3 * max( inlStdMatrix )] );
  grid on;

end