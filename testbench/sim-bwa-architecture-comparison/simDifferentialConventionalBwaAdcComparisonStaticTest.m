%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDynamicTest();

%% code density method

%% generate sine samples

sineWave = genDifferentialSineSamples( p );

%% allocate storage for simulation data

numTotalCodeDensitySamples = sineWave.numOfSamples;
conversionCodeDensityResult = nan( numTotalCodeDensitySamples, p.adcResolution, 3 );
codeDensityIdealDacOutput = nan( numTotalCodeDensitySamples, 3 );

%% select different architecture

dacTopology = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};
for iTopology = 1 : length( dacTopology )

  p.dacTopology = dacTopology{ iTopology };

  rng( 20 );
 
  %% generate CDAC array

  positiveCapArray = genBwaCdac( p );
  negativeCapArray = genBwaCdac( p );

  %% run simulation

  for iSample = 1 : numTotalCodeDensitySamples
    samplePositive = sineWave.positiveInput( iSample );
    sampleNegative = sineWave.negativeInput( iSample );
    conversionCodeDensityResult( iSample, :, iTopology ) = differentialBwaConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    codeDensityIdealDacOutput( iSample, iTopology ) = idealDAC( conversionCodeDensityResult( iSample, :, iTopology ) );
  end


end

%% process simulation data

adcCodeDensityStaticPerformanceMetrics = processComparisonDifferentialAdcTransitionData( p, sineWave, codeDensityIdealDacOutput );

%% plot simulation results

[dnlObj, inlObj] = plotComparisonDifferentialAdcStaticSimulationResult( p, adcCodeDensityStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/comparison-differential-bwa-conventional-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );
drawingInl = 'drawing/comparison-differential-bwa-conventional-adc-inl.png';
exportgraphics( inlObj, drawingInl );

