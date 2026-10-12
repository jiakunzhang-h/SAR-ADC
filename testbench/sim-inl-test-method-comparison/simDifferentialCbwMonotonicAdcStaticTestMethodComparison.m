%% simulation preparation

clear
close all
clc
format long g

%% set the seed

rng( 177 );

%% load simulation configuration and parameters

p = configInlTestMethodComparison();

%% allocate storage for simulation data

timeOfTestList = nan( 4, 1 );

%% generate CDAC array

positiveCapArray = genMonotonicCbwCdac( p );
negativeCapArray = genMonotonicCbwCdac( p );
%% ramp histogram method

%% start timer

initialTimeOfRampHistogram = tic;

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

%% caluculate the operation time

totalTimeOfRampHistogram = toc( initialTimeOfRampHistogram );
timeOfTestList( 1 ) = totalTimeOfRampHistogram;

%% code density method

%% start timer

initialTimeOfSineCodeDensity = tic;

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

%% caluculate the operation time

totalTimeOfSineCodeDensity = toc( initialTimeOfSineCodeDensity );
timeOfTestList( 2 ) = totalTimeOfSineCodeDensity;

%% fast INL test method

%% start timer

initialTimeOfFastInlTest = tic;

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

%% caluculate the operation time

totalTimeOfFastInlTest = toc( initialTimeOfFastInlTest );
timeOfTestList( 3 ) = totalTimeOfFastInlTest;

%% binary search method

%% start timer

initialTimeOfBinarySearch = tic;

%% run simulation

adcBinarySearchStaticPerformanceMetrics = processDifferentialBinarySearchData( p, positiveCapArray, negativeCapArray );

%% caluculate the operation time

totalTimeOfBinarySearch = toc( initialTimeOfBinarySearch );
timeOfTestList( 4 ) = totalTimeOfBinarySearch;

%% plot simulation results

[inlObj, comprehensionObj, accuracyObj] = plotInlTestMethodComparison( p, timeOfTestList, adcHistogramStaticPerformanceMetrics, adcCodeDensityStaticPerformanceMetrics, adcFastInlStaticPerformanceMetrics, adcBinarySearchStaticPerformanceMetrics )
%% export plots

drawingInl = 'drawing/inl-test-comparison.png';
exportgraphics( inlObj, drawingInl );

drawingComprehension = 'drawing/inl-test-comprehension-comparison.png';
exportgraphics( comprehensionObj, drawingComprehension );

drawingAccuracy = 'drawing/inl-test-accuracy-comparison.png';
exportgraphics( accuracyObj, drawingAccuracy );

