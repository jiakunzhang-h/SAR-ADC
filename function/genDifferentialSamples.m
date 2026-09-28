function samples = genDifferentialSamples( p )

  %% use genInputFrequency function

  [toneBin, frequency] = genInputFrequency( p );

  %% generate input voltage

  time = ( 0 : p.fftLen - 1 ) / p.fs;
  vinDiff = p.inputAmplitude * sin( 2 * pi * frequency * time );
  samples.positiveInput = p.vcm + vinDiff / 2;
  samples.negativeInput = p.vcm - vinDiff / 2;
  samples.toneBin = toneBin;
  samples.frequency = frequency;

end