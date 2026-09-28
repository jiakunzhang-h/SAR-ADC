function [dnlObj, inlObj] = plotAdcStaticSimulationResult( p, adcHistogramStaticPerformanceMetrics, adcCodeDensityStaticPerformanceMetrics )

  %% plot DNL

  dnlObj = figure;

  %% plot histogram dnl

  plot( adcHistogramStaticPerformanceMetrics.dnlCodeIndex, adcHistogramStaticPerformanceMetrics.dnlResult, 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot code density dnl

  plot( adcCodeDensityStaticPerformanceMetrics.dnlCodeIndex, adcCodeDensityStaticPerformanceMetrics.dnlResult, 'r--', 'LineWidth', 2.5 );
  xlabel( 'Code' );
  ylabel( 'DNL (LSB)' );
  title( 'ADC DNL comparison' );
  legend( 'Ramp histogram method', 'Code density method', 'Location', 'best' );
  allDnlResult = [adcHistogramStaticPerformanceMetrics.dnlResult( : ) ; adcCodeDensityStaticPerformanceMetrics.dnlResult( : )];
  subtitle( sprintf( 'mismatch = %.2f %% \n comparator input refered noise = %.0f uV \n DNLmax = %.2f LSB', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allDnlResult ) ) ) )
  xlim( [0, 2 .^   p.adcResolution] );
  ylim( [1.2 * min( allDnlResult ), 1.2 * max( allDnlResult )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot histogram inl

  plot( adcHistogramStaticPerformanceMetrics.inlCodeIndex, adcHistogramStaticPerformanceMetrics.inlResult, 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot code density inl

  plot( adcCodeDensityStaticPerformanceMetrics.inlCodeIndex, adcCodeDensityStaticPerformanceMetrics.inlResult, 'r--', 'LineWidth', 2.5 );
  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'ADC INL comparison' );
  legend( 'Ramp histogram method', 'Code density method', 'Location', 'best' );
  allInlResult = [adcHistogramStaticPerformanceMetrics.inlResult( : ) ; adcCodeDensityStaticPerformanceMetrics.inlResult( : )];
  subtitle( sprintf( 'mismatch = %.2f %% \n comparator input refered noise = %.0f uV \n INLmax = %.2f LSB', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allInlResult ) ) ) )
  xlim( [0, 2 .^   p.adcResolution] );
  ylim( [1.2 * min( allInlResult ), 1.2 * max( allInlResult )] );
  grid on;

end