function sineWave = genDifferentialSineSamples( p )

  %% calculate numbers of samples

  alpha = 1 - p.confidence;
  zAlphaHalf = norminv( 1 - alpha / 2 );
  numOfSamples = ceil( zAlphaHalf .^ 2 * pi * 2 .^ ( p.adcResolution - 1 ) / p.dnlPrecision .^ 2 );

  %% generate sine-wave samples
  
  phaseStep = 2 * pi / numOfSamples;
  phase = ( 0 : numOfSamples - 1 ) * phaseStep;
  sineWave.positiveInput = p.vcm + p.inputAmplitude / 2 * sin( phase );
  sineWave.negativeInput = p.vcm - p.inputAmplitude / 2 * sin( phase );
  sineWave.numOfSamples = numOfSamples;

end