function obj = plotDifferentialBwaAdcConversionError( p, adcStaticPerformanceMetrics )

  %% create figure

  obj = figure;

  %% calculate voltage LSB

  voltLSB = 2 * p.vRef / ( 2 .^   ( p.adcResolution ) );

  %% topology names

  topologyName = {'Sub Cap Array with Dummy Cap', 'Main Cap Array with Dummy Cap', 'Both Arrays without Dummy Cap'};

  %% plot different architectures

  for iTopology = 1 : 3

    subplot( 3, 1, iTopology );

    plot( adcStaticPerformanceMetrics.inlCodeIndex, adcStaticPerformanceMetrics.inlResult( : , iTopology ) * voltLSB, 'b', 'LineWidth', 2.5 );

    xlabel( 'Code' );
    ylabel( 'Conversion Error (V)' );
    title( topologyName{ iTopology } );

    text( 0.99, 0.99, sprintf( 'gain error = %.2f %%  ', adcStaticPerformanceMetrics.gainError( iTopology ) ), 'Units', 'normalized', 'HorizontalAlignment', 'right','VerticalAlignment', 'top', 'FontWeight', 'bold' );
    allInlResult = adcStaticPerformanceMetrics.inlResult( :, iTopology ) * voltLSB;
    xlim( [0, 2 .^   ( p.adcResolution ) ] );
    ylim( [1.2 * min( allInlResult ), 1.5 * max( allInlResult )] );

    grid on;

  end

  %% overall title

  sgtitle( 'BWA ADC Conversion Error Comparison ' );

end
