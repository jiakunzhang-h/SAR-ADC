%% simulation preparation

clear
close all
clc
format long g

%% set the seed

rng( 125 );

%% load simulation configuration and parameters

p = configDynamicTest();

%% generate CDAC array

positiveCapArray = genCbwCdac( p );
negativeCapArray = genCbwCdac( p );

%% code density method

%% generate sine samples

sineWave = genDifferentialSineSamples( p );

%% allocate storage for simulation data

numTotalCodeDensitySamples = sineWave.numOfSamples;
conversionCodeDensityResult = nan( numTotalCodeDensitySamples, p.adcResolution );
codeDensityIdealDacOutput = nan( numTotalCodeDensitySamples, 1 );

%% run simulation

for iSample = 1 : numTotalCodeDensitySamples
  samplePositive = sineWave.positiveInput( iSample );
  sampleNegative = sineWave.negativeInput( iSample );
  conversionCodeDensityResult( iSample, : ) = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  codeDensityIdealDacOutput( iSample ) = idealDAC( conversionCodeDensityResult( iSample, : ) );
end

%% process simulation data

adcCodeDensityStaticPerformanceMetrics = processDifferentialAdcTransitionData( p, sineWave, codeDensityIdealDacOutput );

%% plot simulation results

[dnlObj, inlObj] = plotDifferentialAdcStaticSimulationResult( p, adcCodeDensityStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/differential-conventional-cbw-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );
drawingInl = 'drawing/differential-conventional-cbw-adc-inl.png';
exportgraphics( inlObj, drawingInl );

