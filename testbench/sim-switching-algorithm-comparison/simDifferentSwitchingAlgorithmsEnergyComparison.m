%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentSwitchingAlgorithmsEnergyComparisonTest();

%% generate samples

histogramSamples = genDifferentialRampSamplesForEnergyComparison( p );
numTotalHistogramSamples = numel( histogramSamples.Positive );

%% determine the number of switching algorithms

numAlgorithms = numel( p.conversionFunctionList );

%% allocate storage for simulation data

switchingEnergyResult = nan( numTotalHistogramSamples, numAlgorithms );
conversionResult = nan( numTotalHistogramSamples, p.adcResolution, numAlgorithms );
dacOutput = nan( numTotalHistogramSamples, numAlgorithms );

%% simulate different switching algorithms

for iAlgorithm = 1 : numAlgorithms

  %% generate CDAC

  capArray = p.capGenerationFunctionList{ iAlgorithm }( p );

  %% perform ADC conversions

  for iSample = 1 : numTotalHistogramSamples

    [ conversionResult( iSample, :, iAlgorithm ), ~, switchingEnergyResult( iSample, iAlgorithm ) ] = ...
      p.conversionFunctionList{ iAlgorithm }( ...
      histogramSamples.Positive( iSample ), ...
      histogramSamples.Negative( iSample ), ...
      p, capArray );

    dacOutput( iSample, iAlgorithm ) = idealDAC( conversionResult( iSample, :, iAlgorithm ) );

  end

end

%% plot simulation results

energyObj = plotDifferentialAdcSwitchingEnergySimulationResult( p, switchingEnergyResult, dacOutput );
drawing = [ 'drawing/switching-algorithm-figures/', num2str( p.adcResolution ), 'bit-switching-energy-versus-output-code-comparison.png' ];
exportgraphics( energyObj, drawing );