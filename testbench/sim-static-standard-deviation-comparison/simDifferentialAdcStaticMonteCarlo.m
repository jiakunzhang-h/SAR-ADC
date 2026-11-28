
%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialStaticMonteCarloTest();

%% allocate storage for simulation data

numMonteCarlo = p.numMonteCarlo;
numDnlCode = 2 .^ p.adcResolution;
numInlCode = 2 .^ p.adcResolution + 1;

dnlResult = nan( numMonteCarlo, numDnlCode , 2 );
inlResult = nan( numMonteCarlo, numInlCode , 2 );

%% Monte Carlo simulation

parfor iMonteCarlo = 1 : numMonteCarlo

  %% generate CDAC array

  cbwCapArray = genDifferentialCbwCdac( p );
  sbwCapArray = genDifferentialSbwCdac( p );

  %% binary search method

  conventionalAdcStaticPerformanceMetrics = processDifferentialBinarySearchData( p, cbwCapArray, p.adcConversionFunctionList{ 1 } );
  splitAdcStaticPerformanceMetrics = processDifferentialBinarySearchData( p, sbwCapArray, p.adcConversionFunctionList{ 2 } );

  %% store simulation results

  dnlResult( iMonteCarlo, :, : ) = cat( 3, conventionalAdcStaticPerformanceMetrics.dnlResult, splitAdcStaticPerformanceMetrics.dnlResult );
  inlResult( iMonteCarlo, :, : ) = cat( 3, conventionalAdcStaticPerformanceMetrics.inlResult, splitAdcStaticPerformanceMetrics.inlResult );

end

%% calculate standard deviation

adcStaticPerformanceMetrics.dnlResult = dnlResult;
adcStaticPerformanceMetrics.inlResult = inlResult;

adcStaticPerformanceMetrics.dnlStd = squeeze( std( dnlResult, 0, 1 ) );
adcStaticPerformanceMetrics.inlStd = squeeze( std( inlResult, 0, 1 ) );

adcStaticPerformanceMetrics.dnlCodeIndex = 0 : numDnlCode - 1;
adcStaticPerformanceMetrics.inlCodeIndex = 0 : numInlCode - 1;

%% plot simulation results

[ dnlObj, inlObj ] = plotStaticStandardDeviationComparison( p, adcStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/static-standard-deviation/standard-deviation-of-differential-sbw-adc-dnl-comparison.png';
exportgraphics( dnlObj, drawingDnl );

drawingInl = 'drawing/static-standard-deviation/standard-deviation-of-differential-sbw-adc-inl-comparison.png';
exportgraphics( inlObj, drawingInl );
