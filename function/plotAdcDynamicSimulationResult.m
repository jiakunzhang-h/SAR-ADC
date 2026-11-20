
function obj = plotAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics )

  %% calculate the display noise floor

  noiseFloor = -( 6.02 * p.adcResolution + 1.76 ) - 10 * log10( p.fftLen / 2 );

  displayFloor = noiseFloor - 10;

  %% prepare spectrum for plotting

  spectrumDbPlot = adcDynamicPerformanceMetrics.spectrumDb;

  %% replace negative infinity for visualization

  spectrumDbPlot( isinf( spectrumDbPlot ) & spectrumDbPlot < 0 ) = displayFloor;

  %% limit displayed spectrum floor

  spectrumDbPlot = max( spectrumDbPlot, displayFloor );

  %% plot FFT

  obj = figure( 'Color', 'w' );

  plot( adcDynamicPerformanceMetrics.frequency / 1e6, spectrumDbPlot, 'b', 'LineWidth', 2.5 );

  xlabel( 'Frequency (MHz)' );
  ylabel( 'Magnitude (dBFS)' );

  text( max( adcDynamicPerformanceMetrics.frequency / 1e6 ) * 0.7, -20, sprintf( 'SNDR = %.2f dB\nENOB = %.2f bit', ...
    adcDynamicPerformanceMetrics.sndr, adcDynamicPerformanceMetrics.enob ), 'FontWeight', 'bold' );

  title( 'ADC Frequency Spectrum' );

  grid on;

  %% axis settings

  xlim( [ 0, p.fs / 2 / 1e6 ] );
  ylim( [ displayFloor, 5 ] );

end
