function samples = genSamples( p )

  %% use genInputFrequency function

  [toneBin, frequency] = genInputFrequency( p );

  %% generate input voltage

  time = ( 0 : p.fftLen - 1 ) / p.fs;
  samples.data = p.vcm + p.inputAmplitude * sin( 2 * pi * frequency * time );
  samples.toneBin = toneBin;
  samples.frequency = frequency;
  samples.time = time;
  
end