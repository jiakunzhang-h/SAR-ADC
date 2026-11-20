%% simulation preparation

clear
close all
clc
format long g

%% determine ADC resolution

resolutionArray = 2 : 15;

%% allocate storage for average switching energy

averageSwitchingEnergy = nan( numel( resolutionArray ), 6 );

%% simulate different resolutions

for iResolution = 1 : numel( resolutionArray )

  %% load configuration

  p = configDifferentSwitchingAlgorithmsEnergyComparisonTest();

  %% update ADC resolution

  p.adcResolution = resolutionArray( iResolution );

  %% update ramp offset

  p.rampOffset = 2 * p.vRef / 2 ^ p.adcResolution / 1000;
  
  %% generate samples

  histogramSamples = genDifferentialRampSamplesForEnergyComparison( p );

  numTotalHistogramSamples = numel( histogramSamples.Positive );

  %% allocate storage

  switchingEnergyResult = nan( numTotalHistogramSamples, 6 );

  %% Run original six switching algorithm simulations

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
  end

  %% calculate average switching energy

  averageSwitchingEnergy( iResolution, : ) = mean( switchingEnergyResult, 1 );

end

%% plot simulation results

obj = plotDifferentialAdcSwitchingEnergyVersusResolutionSimulationResult( p, averageSwitchingEnergy, resolutionArray );
drawing = ['drawing/switching-algorithm-figures/switching-energy-versus-resolution-comparison.png'];
exportgraphics( obj, drawing );