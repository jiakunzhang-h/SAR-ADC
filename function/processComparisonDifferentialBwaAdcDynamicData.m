function adcDynamicPerformanceMetrics = processComparisonDifferentialBwaAdcDynamicData( p, samples, idealDacOutput )

  %% delete DC component

  fftSample = idealDacOutput - mean( idealDacOutput, 1 );

  %% calculate FFT

  spectrum = fft( fftSample, [], 1 );

  %% obtain single-sided spectrum

  spectrumSingle = spectrum( 1 : p.fftLen / 2, : );

  %% calculate SNDR
  
  sndrResult = nan( 3, 1 );
  for iSndrResult = 1 : 3
    sndrResult( iSndrResult ) = calculateSNR( spectrumSingle( : , iSndrResult ), samples.toneBin, 0 );
  end

  %% calculate ENOB

  enobResult = ( sndrResult - 1.76 ) / 6.02;
 %% generate frequency axis

  frequency = ( 0 : p.fftLen / 2 - 1 ).' * p.fs / p.fftLen;

  %% normalize spectrum for display

  fullScale = 2 .^ ( p.adcResolution - 1 );
  spectrumNormalized = spectrumSingle / ( p.fftLen / 2 ) / fullScale;

  %% convert spectrum to dB

  spectrumDb = dbv( spectrumNormalized );

  %% store results

  adcDynamicPerformanceMetrics.sndr = sndrResult;
  adcDynamicPerformanceMetrics.enob = enobResult;
  adcDynamicPerformanceMetrics.frequency = frequency;
  adcDynamicPerformanceMetrics.spectrum = spectrumSingle;
  adcDynamicPerformanceMetrics.spectrumDb = spectrumDb;

end

