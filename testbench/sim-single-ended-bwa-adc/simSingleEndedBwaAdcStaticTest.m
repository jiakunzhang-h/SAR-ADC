%% simulation preparation

clear
close all
clc
format long g

%% set the seed

rng( 66 );

%% load simulation configuration and parameters

p = configDynamicTest();

%% generate CDAC array

capArray = genBwaCdac( p );

%% ramp histogram method

%% allocate storage for simulation data

numTotalHistogramSamples = p.samplesPerStair * 2 .^ p.adcResolution;
conversionHistogramResult = nan( numTotalHistogramSamples, p.adcResolution );
histogramIdealDacOutput = nan( numTotalHistogramSamples, 1 );

%% generate samples

histogramSamples = genRampSamples( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  sample = histogramSamples( iSample );
  conversionHistogramResult( iSample, : ) = bwaSarAdc( sample, p, capArray );
  histogramIdealDacOutput( iSample ) = idealDAC( conversionHistogramResult( iSample, : ) );
end

%% process simulation data

adcHistogramStaticPerformanceMetrics = processAdcHistogramData( p, histogramIdealDacOutput );

%% code density method

%% generate sine samples

sineWave = genSineSamples( p );

%% allocate storage for simulation data

numTotalCodeDensitySamples = sineWave.numOfSamples;
conversionCodeDensityResult = nan( numTotalCodeDensitySamples, p.adcResolution );
codeDensityIdealDacOutput = nan( numTotalCodeDensitySamples, 1 );

%% run simulation

for iSample = 1 : numTotalCodeDensitySamples
  sample = sineWave.data( iSample );
  conversionCodeDensityResult( iSample, : ) = bwaSarAdc( sample, p, capArray );
  codeDensityIdealDacOutput( iSample ) = idealDAC( conversionCodeDensityResult( iSample, : ) );
end

%% process simulation data

adcCodeDensityStaticPerformanceMetrics = processAdcTransitionData( p, sineWave, codeDensityIdealDacOutput );

%% plot simulation results

[dnlObj, inlObj] = plotAdcStaticSimulationResult( p, adcHistogramStaticPerformanceMetrics, adcCodeDensityStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/bwa-adc-dnl-comparison.png';
exportgraphics( dnlObj, drawingDnl );
drawingInl = 'drawing/bwa-adc-inl-comparison.png';
exportgraphics( inlObj, drawingInl );

