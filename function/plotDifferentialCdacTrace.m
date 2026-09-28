function traceObj = plotDifferentialCdacTrace( p, randomTrace, randomSample )

  %% calculate differential CDAC voltage

  differentialCdac = randomTrace( :, 1 ) - randomTrace( :, 2 );

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;
  randomTraceLSB = differentialCdac / voltageLSB;
  sampleLSB = randomSample / voltageLSB;

  %% plot cdac trace result

  traceObj = figure;
  stairs( 1 : p.adcResolution, randomTraceLSB, 'b', 'LineWidth', 2.5 );
  hold on;
  yline( - sampleLSB, '--r', 'Vin', 'LineWidth', 2.5 );
  xlabel( 'Bit Cycle' );
  ylabel( 'Vdac (LSB)' );
  title( 'CDAC Conversion Waveform' );
  xlim( [ 1, p.adcResolution ] );
  ylim( [ - 2 .^ p.adcResolution, 2 .^ p.adcResolution ]);
  grid on;

end
