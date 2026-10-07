%% simulation preparation

clear
close all
clc
format long g

%% set the seed

rng( 177 );

%% load simulation configuration and parameters

p = configDifferentialCbwSarAdcStaticTest();

%% generate CDAC array

positiveCapArray = genMonotonicCbwCdac( p );
negativeCapArray = genMonotonicCbwCdac( p );

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
  conversionCodeDensityResult( iSample, : ) = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  codeDensityIdealDacOutput( iSample ) = idealDAC( conversionCodeDensityResult( iSample, : ) );
end

%% process simulation data

adcCodeDensityStaticPerformanceMetrics = processDifferentialAdcTransitionData( p, sineWave, codeDensityIdealDacOutput );

%% fast INL test method

%% generate piecewise ramp samples

[positiveSamples, negativeSamples] = genDifferentialPiecewiseRampSamples( p );

%% allocate storage for simulation data

numTotalFastInlSamples = numel( positiveSamples );
conversionFastInlResult = nan( numTotalFastInlSamples, p.adcResolution );
fastInlIdealDacOutput = nan( numTotalFastInlSamples, 1 );

%% run simulation

for iSample = 1 : numTotalFastInlSamples
  samplePositive = positiveSamples( iSample );
  sampleNegative = negativeSamples( iSample );
  conversionFastInlResult( iSample, : ) = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  fastInlIdealDacOutput( iSample ) = idealDAC( conversionFastInlResult( iSample, : ) );
end

%% process simulation data

adcFastInlStaticPerformanceMetrics = processMonotonicAdcFastInlData( p, fastInlIdealDacOutput );

%% ramp histogram method

%% generate samples

histogramSamples = genDifferentialRampSamples( p );

%% allocate storage for simulation data

numTotalHistogramSamples = numel( histogramSamples.Positive );
conversionHistogramResult = nan( numTotalHistogramSamples, p.adcResolution );
histogramIdealDacOutput = nan( numTotalHistogramSamples, 1 );

%% run simulation

for iSample = 1 : numTotalHistogramSamples
  samplePositive = histogramSamples.Positive( iSample );
  sampleNegative = histogramSamples.Negative( iSample );
  conversionHistogramResult( iSample, : ) = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
  histogramIdealDacOutput( iSample ) = idealDAC( conversionHistogramResult( iSample, : ) );
end

%% process simulation data

adcHistogramStaticPerformanceMetrics = processAdcHistogramData( p, histogramIdealDacOutput );
%% plot simulation results

[dnlObj, inlObj] = plotDifferentialAdcStaticSimulationResult( p, adcCodeDensityStaticPerformanceMetrics, adcFastInlStaticPerformanceMetrics, adcHistogramStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/differential-cbw-monotonic-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );
drawingInl = 'drawing/differential-cbw-monotonic-adc-inl.png';
exportgraphics( inlObj, drawingInl );

