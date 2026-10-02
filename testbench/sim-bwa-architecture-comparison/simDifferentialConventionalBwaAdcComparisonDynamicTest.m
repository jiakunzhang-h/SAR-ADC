%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDynamicTest();

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, p.adcResolution, 3 );
idealDacOutput = nan( p.fftLen, 3 );
sndrResult = nan( 3, 1 );
enobResult = nan( 3, 1 );

%% select different architecture

dacTopology = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};
for iTopology = 1 : length( dacTopology )
  p.dacTopology = dacTopology{ iTopology };

  %% set the seed

  rng( 10 );

  %% generate samples

  samples = genDifferentialSamples( p );

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

  %% process simulation data

  adcDynamicPerformanceMetrics = processAdcData( p, samples, idealDacOutput( :, iTopology ) );

  %% plot simulation results

  obj = plotAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics );

  %% export plots

  drawingSpectrum = sprintf( 'drawing/comparison-differential-bwa-type-%d-spectrum.png', iTopology );
  exportgraphics( obj, drawingSpectrum );

end

