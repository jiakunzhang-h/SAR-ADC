function [dnlObj, inlObj] = plotStaticStandardDeviation( p, adcStaticPerformanceMetrics )

  %% plot DNL

  dnlObj = figure;

  %% plot histogram dnl

  plot( adcStaticPerformanceMetrics.dnlCodeIndex, adcStaticPerformanceMetrics.dnlStd, 'b', 'LineWidth', 2.5 );
  hold on;

  dnlStdMatrix = [adcStaticPerformanceMetrics.dnlStd( : )];

  %% set plot specification

  xlabel( 'Code' );
  ylabel( '\sigma_{DNL} (LSB)' );
  title( 'Standard Deviation of DNL' );
  statisticsText = sprintf( 'N = %d\nmismatch = %.2f %% \n comparator input referred noise = %.0f uV \n \\sigma_{DNL} max = %.2f LSB', p.numMonteCarlo, p.mismatchStd * 100, p.compNoise * 1e6, max( abs( dnlStdMatrix ) ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [0, 1.2 * max( dnlStdMatrix )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot histogram inl

  plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlStd, 'b', 'LineWidth', 2.5 );
  hold on;

  inlStdMatrix = [adcStaticPerformanceMetrics.inlStd( : )];

  %% set plot specification

  xlabel( 'Code' );
  ylabel( '\sigma_{INL} (LSB)' );
  title( 'Standard Deviation of DNL' );
  statisticsText = sprintf( 'N = %d\nmismatch = %.2f %% \n comparator input referred noise = %.0f uV \n \\sigma_{INL} max = %.2f LSB', p.numMonteCarlo, p.mismatchStd * 100, p.compNoise * 1e6, max( inlStdMatrix ) );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [0, 1.2 * max( inlStdMatrix )] );
  grid on;

end