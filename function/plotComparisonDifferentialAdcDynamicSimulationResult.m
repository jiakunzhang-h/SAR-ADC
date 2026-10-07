function obj = plotComparisonDifferentialAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics )

  %% create figure

  obj = figure;

  %% topology names

  topologyName = {'Sub Cap Array with Dummy Cap', 'Main Cap Array with Dummy Cap', 'Both Arrays without Dummy Cap'};

  %% calculate noise floor

  noiseFloor = - ( 6.02 * p.adcResolution + 1.76 ) - 10 * log10( p.fftLen / 2 );

  %% plot different architectures

  for iTopology = 1 : 3
    %% set display floor

    spectrumDb = adcDynamicPerformanceMetrics.spectrumDb( :, iTopology );
    displayFloor = noiseFloor - 10;

    spectrumDb( ~isfinite( spectrumDb ) ) = displayFloor;
    subplot( 3, 1, iTopology );

    plot( adcDynamicPerformanceMetrics.frequency / 1e6, adcDynamicPerformanceMetrics.spectrumDb, 'b', 'LineWidth', 2.5 );

    xlabel( 'Frequency (MHz)' );
    ylabel( 'Magnitude (dBFS)' );

    title( topologyName{ iTopology } );

    text( max( adcDynamicPerformanceMetrics.frequency / 1e6 ) * 0.7, -20, sprintf( 'SNDR = %.2f dB\nENOB = %.2f bit', adcDynamicPerformanceMetrics.sndr( iTopology ), adcDynamicPerformanceMetrics.enob( iTopology ) ), 'FontWeight', 'bold' );

    ylim( [noiseFloor - 10, 5] );

    grid on;

  end

  %% overall title

  if p.mismatchStd == 0

    sgtitle( 'BWA ADC Dynamic Comparison without Mismatch' );

  else

    sgtitle( sprintf( 'BWA ADC Dynamic Comparison with %.2f %% Mismatch', p.mismatchStd * 100 ) );

  end

end