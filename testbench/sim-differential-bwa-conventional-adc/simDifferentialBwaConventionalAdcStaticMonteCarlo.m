
%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialStaticMonteCarloTest();

%% generate samples

histogramSamples = genDifferentialRampSamples( p );

%% allocate storage for simulation data

numTotalHistogramSamples = numel( histogramSamples.Positive );
numMonteCarlo = p.numMonteCarlo;

conversionHistogramResult = cell( numMonteCarlo, 1 );
histogramIdealDacOutput = cell( numMonteCarlo, 1 );

%% Monte Carlo simulation

parfor iMonteCarlo = 1 : numMonteCarlo

  %% allocate storage for single simulation data

  singleConversionHistogramResult = nan( numTotalHistogramSamples, p.adcResolution );
  singleHistogramIdealDacOutput = nan( numTotalHistogramSamples, 1 );

  %% generate CDAC array

positiveCapArray = genBwaCdac( p );
negativeCapArray = genBwaCdac( p );

  %% run simulation

  for iSample = 1 : numTotalHistogramSamples
    samplePositive = histogramSamples.Positive( iSample );
    sampleNegative = histogramSamples.Negative( iSample );
    singleConversionHistogramResult( iSample, : ) = differentialBwaConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    singleHistogramIdealDacOutput( iSample ) = idealDAC( singleConversionHistogramResult( iSample, : ) );

  end

  %% store simulation results

  conversionHistogramResult{ iMonteCarlo } = singleConversionHistogramResult;
  histogramIdealDacOutput{ iMonteCarlo } = singleHistogramIdealDacOutput;

end

%% process simulation data

adcStaticPerformanceMetrics = processAdcStaticMonteCarloData( p, histogramIdealDacOutput );

%% plot simulation results

[ dnlObj, inlObj ] = plotStaticStandardDeviation( p, adcStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/standard-deviation-of-differential-bwa-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );

drawingInl = 'drawing/standard-deviation-of-differential-bwa-adc-inl.png';
exportgraphics( inlObj, drawingInl );
