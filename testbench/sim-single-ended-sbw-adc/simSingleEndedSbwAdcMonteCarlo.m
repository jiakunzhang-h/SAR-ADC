%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDynamicTest();

%% allocate storage for simulation data

idealDacOutput = nan( p.fftLen, p.numMonteCarlo );
toneBin = nan( 1, p.numMonteCarlo );

%% Monte Carlo simulation

parfor iMonteCarlo = 1 : p.numMonteCarlo

  %% load single simulation configuration and parameters

  conversionResult = nan( p.fftLen, p.adcResolution );
  singleIdealDacOutput = nan( p.fftLen, 1 );

  %% generate samples

  samples = genSamples( p );
  toneBin( iMonteCarlo ) = samples.toneBin;

  %% generate CDAC array

  capArray = genSbwCdac( p );

  %% run simulation

  for iSample = 1 : p.fftLen
    sample = samples.data( iSample );
    conversionResult( iSample, : ) = sbwSarAdc( sample, p, capArray );
    singleIdealDacOutput( iSample ) = idealDAC( conversionResult( iSample, : ) );
  end

  idealDacOutput( : , iMonteCarlo ) = singleIdealDacOutput;

end

%% process simulation data

adcDynamicPerformanceMetrics = processAdcMonteCarloData( p, toneBin, idealDacOutput );

%% plot simulation results

mcObj = plotMonteCarlo( p, adcDynamicPerformanceMetrics.enobResult );

%% export plots

drawing = 'drawing/sbw-monte-carlo-enob-distribution.png';
exportgraphics( mcObj, drawing );

