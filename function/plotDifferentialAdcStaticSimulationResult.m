function [dnlObj, inlObj] = plotDifferentialAdcStaticSimulationResult( p, adcCodeDensityStaticPerformanceMetrics, adcFastInlStaticPerformanceMetrics, adcHistogramStaticPerformanceMetrics )

  %% plot DNL

  dnlObj = figure;

  %% plot code density dnl

  plot( adcCodeDensityStaticPerformanceMetrics.dnlCodeIndex, adcCodeDensityStaticPerformanceMetrics.dnlResult, 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot fast inl dnl

  plot( adcFastInlStaticPerformanceMetrics.dnlCodeIndex, adcFastInlStaticPerformanceMetrics.dnlResult, 'r--', 'LineWidth', 2.5 );

  %% plot ramp histogram dnl 

  plot( adcHistogramStaticPerformanceMetrics.dnlCodeIndex, adcHistogramStaticPerformanceMetrics.dnlResult, 'g-.', 'LineWidth', 2.5 );

  %% construct dnl result matrix

  dnlResultMatrix = [adcCodeDensityStaticPerformanceMetrics.dnlResult( : ), adcFastInlStaticPerformanceMetrics.dnlResult( : ), adcHistogramStaticPerformanceMetrics.dnlResult( : )];
  legendText = {'Code Density Method', 'Fast INL Method', 'Ramp Histogram Method'};

  %% find the maximum deviation

  deviationDnlResult = max( dnlResultMatrix, [], 2 ) - min( dnlResultMatrix, [], 2 );
  [maxDnlDeviation, maxDnlDeviationIndex] = max( deviationDnlResult );
  maxDnlDeviationCode = adcFastInlStaticPerformanceMetrics.dnlCodeIndex( maxDnlDeviationIndex );
  allDnlResult = dnlResultMatrix( : );

  %% set plot properties

  xlabel( 'Code' );
  ylabel( 'DNL (LSB)' );
  title( 'Differential ADC DNL Comparison' );
  legend( legendText, 'Location', 'best' );
  statisticsText =  sprintf( 'mismatch = %.2f %% \n comparator input referred noise = %.0f uV \n DNL max = %.2f LSB \n DNL deviation max = %.2f LSB @ code %d', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allDnlResult ) ), maxDnlDeviation, maxDnlDeviationCode );
  text( 0.02, 0.99, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^   ( p.adcResolution ) ] );
  ylim( [1.2 * min( allDnlResult ), 1.5 * max( allDnlResult )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot code density inl

  plot( adcCodeDensityStaticPerformanceMetrics.inlCodeIndex, adcCodeDensityStaticPerformanceMetrics.inlResult, 'b', 'LineWidth', 2.5 );
  hold on;
  
  %% plot fast inl inl

  plot( adcFastInlStaticPerformanceMetrics.inlCodeIndex, adcFastInlStaticPerformanceMetrics.inlResult, 'r--', 'LineWidth', 2.5 );

  %% plot ramp histogram inl

  plot( adcHistogramStaticPerformanceMetrics.inlCodeIndex, adcHistogramStaticPerformanceMetrics.inlResult, 'g-.', 'LineWidth', 2.5 );

  %% construct inl result matrix

  inlResultMatrix = [adcCodeDensityStaticPerformanceMetrics.inlResult( : ), adcFastInlStaticPerformanceMetrics.inlResult( : ), adcHistogramStaticPerformanceMetrics.inlResult( : )];
  legendText = {'Code Density Method', 'Fast INL Method', 'Ramp Histogram Method'};

  %% find the maximum deviation

  deviationInlResult = max( inlResultMatrix, [], 2 ) - min( inlResultMatrix, [], 2 );
  [maxInlDeviation, maxInlDeviationIndex] = max( deviationInlResult );
  maxInlDeviationCode = adcFastInlStaticPerformanceMetrics.inlCodeIndex( maxInlDeviationIndex );
  allInlResult = inlResultMatrix( : );

  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'Differential ADC INL Comparison' );
  legend( legendText, 'Location', 'best' );
  statisticsText =  sprintf( 'mismatch = %.2f %% \n comparator input referred noise = %.0f uV \n INL max = %.2f LSB \n INL deviation max = %.2f LSB @ code %d', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allInlResult ) ), maxInlDeviation, maxInlDeviationCode );
  text( 0.02, 0.99, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^   ( p.adcResolution ) ] );
  ylim( [1.2 * min( allInlResult ), 1.5 * max( allInlResult )] );
  grid on;

end