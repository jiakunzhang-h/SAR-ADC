%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialBwaAdcComparisonDynamicTest();

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, p.adcResolution, 3 );
idealDacOutput = nan( p.fftLen, 3 );
sndrResult = nan( 3, 1 );
enobResult = nan( 3, 1 );

%% set the seed

rng( 100 );

%% generate samples

samples = genDifferentialSamples( p );

%% select different architecture

dacTopology = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};

%% set the mismatch standard deviation for the comparison

mismatchStd = { 0, 0.01};

for iMismatchStd = 1 : length( mismatchStd )

  p.mismatchStd = mismatchStd{ iMismatchStd };


  for iTopology = 1 : length( dacTopology )

    p.dacTopology = dacTopology{ iTopology };

    %% generate CDAC array

    positiveCapArray = genBwaCdac( p );
    negativeCapArray = genBwaCdac( p );

    %% run simulation

    for iSample = 1 : p.fftLen
      samplePositive = samples.positiveInput( iSample );
      sampleNegative = samples.negativeInput( iSample );
      conversionResult( iSample, :, iTopology ) = differentialBwaConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
      idealDacOutput( iSample, iTopology ) = idealDAC( conversionResult( iSample, :, iTopology ) );
    end

  end
  %% process simulation data

  adcDynamicPerformanceMetrics = processComparisonDifferentialBwaAdcDynamicData( p, samples, idealDacOutput );

  %% plot simulation results

  obj = plotComparisonDifferentialAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics );

  %% export plots

  drawingSpectrum = sprintf( 'drawing/comparison-differential-bwa-spectrum-mismatch-%.2f.png', p.mismatchStd );
  exportgraphics( obj, drawingSpectrum );

end


