function [dnlObj, inlObj] = plotAdcStaticSimulationResult( p, adcHistogramStaticPerformanceMetrics, adcCodeDensityStaticPerformanceMetrics, adcFastInlStaticPerformanceMetrics )

  %% determine whether fast INL result is provided

  hasFastInlResult = nargin >= 4;

  %% plot DNL

  dnlObj = figure;

  %% plot histogram dnl

  plot( adcHistogramStaticPerformanceMetrics.dnlCodeIndex, adcHistogramStaticPerformanceMetrics.dnlResult, 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot code density dnl

  plot( adcCodeDensityStaticPerformanceMetrics.dnlCodeIndex, adcCodeDensityStaticPerformanceMetrics.dnlResult, 'r--', 'LineWidth', 2.5 );

  %% construct dnl result matrix

  dnlResultMatrix = [adcHistogramStaticPerformanceMetrics.dnlResult( : ), adcCodeDensityStaticPerformanceMetrics.dnlResult( : )];
  legendText = {'Ramp histogram method', 'Code density method'};

  %% plot fast INL test dnl

  if hasFastInlResult
    plot( adcFastInlStaticPerformanceMetrics.dnlCodeIndex, adcFastInlStaticPerformanceMetrics.dnlResult, 'g--', 'LineWidth', 2.5 );
    dnlResultMatrix = [dnlResultMatrix, adcFastInlStaticPerformanceMetrics.dnlResult( : )];
    legendText{ end + 1 } = 'Fast INL Test method';
  end

  %% find the maximum deviation

  deviationDnlResult = max( dnlResultMatrix, [], 2 ) - min( dnlResultMatrix, [], 2 );
  [maxDnlDeviation, maxDnlDeviationIndex] = max( deviationDnlResult );
  maxDnlDeviationCode = adcHistogramStaticPerformanceMetrics.dnlCodeIndex( maxDnlDeviationIndex );
  allDnlResult = dnlResultMatrix( : );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( 'DNL (LSB)' );
  title( 'ADC DNL comparison' );
  legend( legendText, 'Location', 'best' );
  statisticsText = sprintf( 'mismatch = %.2f %% comparator input referred noise = %.0f uV \n DNL max = %.2f LSB DNL deviation max = %.2f LSB @ code %d', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allDnlResult ) ), maxDnlDeviation, maxDnlDeviationCode );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [1.2 * min( allDnlResult ), 1.2 * max( allDnlResult )] );
  grid on;

  %% plot INL

  inlObj = figure;

  %% plot histogram inl

  plot( adcHistogramStaticPerformanceMetrics.inlCodeIndex, adcHistogramStaticPerformanceMetrics.inlResult, 'b', 'LineWidth', 2.5 );
  hold on;

  %% plot code density inl

  plot( adcCodeDensityStaticPerformanceMetrics.inlCodeIndex, adcCodeDensityStaticPerformanceMetrics.inlResult, 'r--', 'LineWidth', 2.5 );

  %% construct inl result matrix

  inlResultMatrix = [adcHistogramStaticPerformanceMetrics.inlResult( : ), adcCodeDensityStaticPerformanceMetrics.inlResult( : )];
  legendText = {'Ramp histogram method', 'Code density method'};

  %% plot fast INL test inl

  if hasFastInlResult
    plot( adcFastInlStaticPerformanceMetrics.inlCodeIndex, adcFastInlStaticPerformanceMetrics.inlResult, 'g--', 'LineWidth', 2.5 );
    inlResultMatrix = [inlResultMatrix, adcFastInlStaticPerformanceMetrics.inlResult( : )];
    legendText{ end + 1 } = 'Fast INL Test method';
  end

  %% find the maximum deviation

  deviationInlResult = max( inlResultMatrix, [], 2 ) - min( inlResultMatrix, [], 2 );
  [maxInlDeviation, maxInlDeviationIndex] = max( deviationInlResult );
  maxInlDeviationCode = adcHistogramStaticPerformanceMetrics.inlCodeIndex( maxInlDeviationIndex );
  allInlResult = inlResultMatrix( : );

  %% set plot specification

  xlabel( 'Code' );
  ylabel( 'INL (LSB)' );
  title( 'ADC INL comparison' );
  legend( legendText, 'Location', 'best' );
  statisticsText = sprintf( 'mismatch = %.2f %% comparator input referred noise = %.0f uV \n INL max = %.2f LSB INL deviation max = %.2f LSB @ code %d', p.mismatchStd * 100, p.compNoise * 1e6, max( abs( allInlResult ) ), maxInlDeviation, maxInlDeviationCode );
  text( 0.001, 0.999, statisticsText, 'Units', 'normalized', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold' );
  xlim( [0, 2 .^ p.adcResolution] );
  ylim( [1.2 * min( allInlResult ), 1.2 * max( allInlResult )] );
  grid on;

end