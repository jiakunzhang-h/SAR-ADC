function [dnlObj, inlObj] = plotDifferentialAdcStaticSimulationResult( p, adcCodeDensityStaticPerformanceMetrics )

  %% plot DNL

  dnlObj = figure;

  %% plot code density dnl

  plot( adcCodeDensityStaticPerformanceMetrics.dnlCodeIndex, adcCodeDensityStaticPerformanceMetrics.dnlResult, 'b', 'LineWidth', 2.5 );
  xlabel( 'Code' );
  ylabel( 'DNL (LSB)' );
  title( 'Differential ADC DNL' );
  allDnlResult = [adcCodeDensityStaticPerformanceMetrics.dnlResult( : )];
  subtitle( sprintf( 'mismatch = %.2f %% \n comparator input refered noise = %.0f uV \n DNLmax = %.2f LSB', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allDnlResult ) ) ) )
  xlim( [0, 2 .^   ( p.adcResolution ) ] );
  ylim( [1.2 * min( allDnlResult ), 1.2 * max( allDnlResult )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot code density inl

  plot( adcCodeDensityStaticPerformanceMetrics.inlCodeIndex, adcCodeDensityStaticPerformanceMetrics.inlResult, 'b', 'LineWidth', 2.5 );
  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'Differential ADC INL' );
  allInlResult = [adcCodeDensityStaticPerformanceMetrics.inlResult( : )];
  subtitle( sprintf( 'mismatch = %.2f %% \n comparator input refered noise = %.0f uV \n INLmax = %.2f LSB', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allInlResult ) ) ) )
  xlim( [0, 2 .^   ( p.adcResolution ) ] );
  ylim( [1.2 * min( allInlResult ), 1.2 * max( allInlResult )] );
  grid on;

end