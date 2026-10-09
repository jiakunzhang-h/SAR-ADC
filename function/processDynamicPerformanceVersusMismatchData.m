function adcDynamicPerformanceMetrics = processDynamicPerformanceVersusMismatchData( p, samples, idealDacOutput )

  %% delete DC component

  fftSample = idealDacOutput - mean( idealDacOutput, 1 );

  %% calculate FFT

  spectrum = fft( fftSample, [], 1 );

  %% obtain single-sided spectrum

  spectrumSingle = spectrum( 1 : p.fftLen / 2, : );

  %% calculate SNDR
  
  sndrResult = nan( size( idealDacOutput, 2 ), 1 );
  for iSndrResult = 1 : size( idealDacOutput, 2 )
    sndrResult( iSndrResult ) = calculateSNR( spectrumSingle( : , iSndrResult ), samples.toneBin, 0 );
  end

  %% calculate ENOB

  enobResult = ( sndrResult - 1.76 ) / 6.02;

  %% store results

  adcDynamicPerformanceMetrics.sndr = sndrResult;
  adcDynamicPerformanceMetrics.enob = enobResult;

end

