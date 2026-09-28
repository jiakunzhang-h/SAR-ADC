function traceObj = plotCdacTrace( p, samples, randomTrace, randomIndex )

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;

  randomTraceLSB = randomTrace / voltageLSB;
  sampleLSB = samples.data( randomIndex ) / voltageLSB;

  %% sampling time

  sampleTime = ( randomIndex - 1 ) / p.fs;
  samplePeriod = 1 / p.fs;

  %% generate sine wave before sampling instant

  sineTime = linspace( sampleTime - 2 * samplePeriod, sampleTime, 1000 );
  sineWave = p.vcm + p.inputAmplitude * sin( 2 * pi * samples.frequency * sineTime );
  sineWaveLSB = sineWave / voltageLSB;

  %% generate conversion time axis

  conversionTime = sampleTime + ( 1 : p.adcResolution ) / p.adcResolution * samplePeriod;

  %% convert time to ns for plotting

  sineTime = sineTime * 1e9;
  sampleTime = sampleTime * 1e9;
  conversionTime = conversionTime * 1e9;

  %% plot

  traceObj = figure;

  %% input sine wave

  plot( sineTime, sineWaveLSB, 'b-', 'LineWidth', 2.5 );

  hold on;

  %% sampling point

  plot( sampleTime, sampleLSB, 'ro', 'LineWidth', 2.5, 'MarkerSize', 8 );

  %% SAR conversion waveform

  stairs( [sampleTime, conversionTime], [randomTraceLSB( 1 ), randomTraceLSB], 'b', 'LineWidth', 2.5 );

  %% sampled input reference

  plot( [sampleTime, conversionTime( end )], [sampleLSB, sampleLSB], 'r--', 'LineWidth', 2.5 );

  %% plot settings

  xlabel( 'Time (ns)' );
  ylabel( 'Voltage (LSB)' );
  ylim( [0, 2 .^ p.adcResolution] );
  title( 'CDAC Sampling and Conversion Waveform' );

  grid on;

end