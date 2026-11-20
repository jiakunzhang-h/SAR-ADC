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

%% allocate storage for switching energy simulation data

switchingEnergyResult = nan( numTotalHistogramSamples, 6 );
dacOutput = nan( numTotalHistogramSamples, 6 );

%% Conventional switching algorithm simulation

%% allocate storage for conventional switching algorithm simulation data

conventionalConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genCbwCdac( p );
negativeCapArray = genCbwCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [conventionalConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 1 )] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 1 ) = idealDAC( conventionalConversionResult( iSample, : ) );
end

%% Split Capacitor switching algorithm simulation

%% allocate storage for split capacitor switching algorithm simulation data

splitConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genSbwCdac( p );
negativeCapArray = genSbwCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [splitConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 2 )] = differentialSbwSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 2 ) = idealDAC( splitConversionResult( iSample, : ) );
end

%% energy saving switching algorithm simulation

%% allocate storage for energy saving switching algorithm simulation data

energySavingConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genEnergySavingCdac( p );
negativeCapArray = genEnergySavingCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [energySavingConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 3 )] = differentialEnergySavingSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 3 ) = idealDAC( energySavingConversionResult( iSample, : ) );
end

%% monotonic switching algorithm simulation

%% allocate storage for monotonic switching algorithm simulation data

monotonicConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genMonotonicCbwCdac( p );
negativeCapArray = genMonotonicCbwCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [monotonicConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 4 )] = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 4 ) = idealDAC( monotonicConversionResult( iSample, : ) );
end

%% merged capacitor switching algorithm simulation

%% allocate storage for merged capacitor switching algorithm simulation data

mergedConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genMergedCapacitorCbwCdac( p );
negativeCapArray = genMergedCapacitorCbwCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [mergedConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 5 )] = differentialMergedCapacitorSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 5 ) = idealDAC( mergedConversionResult( iSample, : ) );
end

%% inverted merged capacitor switching algorithm simulation

%% allocate storage for inverted merged capacitor switching algorithm simulation data

invertedMergedConversionResult = nan( numTotalHistogramSamples, p.adcResolution );

%% generate CDAC array

positiveCapArray = genInvertedMergedCapacitorCbwCdac( p );
negativeCapArray = genInvertedMergedCapacitorCbwCdac( p );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  [invertedMergedConversionResult( iSample, : ), sampleCdacTrace, switchingEnergyResult( iSample, 6 )] = differentialInvertedMergedCapacitorSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  dacOutput( iSample, 6 ) = idealDAC( invertedMergedConversionResult( iSample, : ) );
end

%% plot simulation results

energyObj = plotDifferentialAdcSwitchingEnergySimulationResult( p, switchingEnergyResult, dacOutput );
drawing = ['drawing/switching-algorithm-figures/', num2str( p.adcResolution ), 'bit-switching-energy-versus-output-code-comparison.png'];
exportgraphics( energyObj, drawing );