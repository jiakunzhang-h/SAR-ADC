function traceObj = plotCdacTrace( p, samples, randomTrace, randomIndex )

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;

  %% normalize voltage

  cdacTraceLSB = randomTrace / voltageLSB;
  sampleLSB = samples.data( randomIndex ) / voltageLSB;

  %% generate input sine wave before sampling

  sampleTime = ( randomIndex - 1 ) / p.fs;
  samplePeriod = 1 / p.fs;
  sineTime = linspace( sampleTime - 2 * samplePeriod, sampleTime, 1000 );
  sineWave = p.vcm + p.inputAmplitude * sin( 2 * pi * samples.frequency * sineTime );
  sineWaveLSB = sineWave / voltageLSB;

  %% generate normalized time axis

  sineAxis = linspace( -2, 0, length( sineWaveLSB ) );
  conversionAxis = 1 : p.adcResolution;

  %% plot

  traceObj = figure;

  plot( sineAxis, sineWaveLSB, 'b', 'LineWidth', 2.5 );
  hold on;

  plot( 0, sampleLSB, 'ro', 'LineWidth', 2.5, 'MarkerSize', 8 );

  stairs( [0, conversionAxis], [cdacTraceLSB( 1 ), cdacTraceLSB], 'b', 'LineWidth', 2.5 );

  plot( [0, p.adcResolution], [sampleLSB, sampleLSB], 'r--', 'LineWidth', 2.5 );

  %% plot specification

  xlabel( 'SAR Conversion Cycle' );
  ylabel( 'Voltage (LSB)' );
  title( 'Single-Ended CDAC Conversion Waveform' );
  xlim( [-2, p.adcResolution] );
  ylim( [0, 2 .^ p.adcResolution] );
  grid on;

end