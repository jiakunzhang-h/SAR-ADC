%% simulation preparation

clear
close all
clc
format long g

%% load configuration

p = configDifferentSwitchingAlgorithmsEnergyVersusResolutionTest();

%% determine the number of resolutions and switching algorithms

numResolutions = numel( p.adcResolutionArray );
numAlgorithms = numel( p.conversionFunctionList );

%% generate samples with the maximum ADC resolution

maxResolutionSamples = genDifferentialRampSamplesForEnergyComparison( p.resolutionConfig( end ) );

%% allocate storage for simulation data

averageSwitchingEnergy = nan( numResolutions, numAlgorithms );
switchingEnergyResult = cell( numResolutions, numAlgorithms );
conversionResult = cell( numResolutions, numAlgorithms );

%% simulate different resolutions

for iResolution = 1 : numResolutions

  %% select simulation configuration

  currentConfig = p.resolutionConfig( iResolution );
  numTotalHistogramSamples = p.numTotalHistogramSamples( iResolution );

  %% select input samples

  histogramSamples.Positive = maxResolutionSamples.Positive( currentConfig.sampleIndex );
  histogramSamples.Negative = maxResolutionSamples.Negative( currentConfig.sampleIndex );

  %% simulate different switching algorithms

  for iAlgorithm = 1 : numAlgorithms

    %% allocate storage for current switching algorithm

    conversionResult{ iResolution, iAlgorithm } = nan( numTotalHistogramSamples, currentConfig.adcResolution );
    switchingEnergyResult{ iResolution, iAlgorithm } = nan( numTotalHistogramSamples, 1 );

    %% generate CDAC array

    capArray = p.capGenerationFunctionList{ iAlgorithm }( currentConfig );

    %% perform ADC conversions

    for iSample = 1 : numTotalHistogramSamples
      [ conversionResult{ iResolution, iAlgorithm }( iSample, : ), ~, switchingEnergyResult{ iResolution, iAlgorithm }( iSample ) ] = ...
        p.conversionFunctionList{ iAlgorithm }( histogramSamples.Positive( iSample ), histogramSamples.Negative( iSample ), currentConfig, capArray );
    end

    %% calculate average switching energy

    averageSwitchingEnergy( iResolution, iAlgorithm ) = mean( switchingEnergyResult{ iResolution, iAlgorithm } );

  end

end

%% plot simulation results

obj = plotDifferentialAdcSwitchingEnergyVersusResolutionSimulationResult( p, averageSwitchingEnergy, p.adcResolutionArray );
drawing = 'drawing/switching-algorithm-figures/switching-energy-versus-resolution-comparison.png';
exportgraphics( obj, drawing );