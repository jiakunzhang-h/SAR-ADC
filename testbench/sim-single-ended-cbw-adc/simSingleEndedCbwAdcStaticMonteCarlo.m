
%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configSingleEndedStaticMonteCarloTest();

%% allocate storage for simulation data

numMonteCarlo = p.numMonteCarlo;
numDnlCode = 2 .^ p.adcResolution;
numInlCode = 2 .^ p.adcResolution + 1;

dnlResult = nan( numMonteCarlo, numDnlCode );
inlResult = nan( numMonteCarlo, numInlCode );

%% Monte Carlo simulation

parfor iMonteCarlo = 1 : numMonteCarlo

  %% generate CDAC array

  capArray = genCbwCdac( p );

  %% define ADC conversion function

  adcConversionFunction = @cbwSarAdc;

  %% binary search method

  singleAdcStaticPerformanceMetrics = processAdcBinarySearchData( p, capArray, adcConversionFunction );

  %% store simulation results

  dnlResult( iMonteCarlo, : ) = singleAdcStaticPerformanceMetrics.dnlResult;
  inlResult( iMonteCarlo, : ) = singleAdcStaticPerformanceMetrics.inlResult;

end

%% calculate standard deviation

adcStaticPerformanceMetrics.dnlResult = dnlResult;
adcStaticPerformanceMetrics.inlResult = inlResult;

adcStaticPerformanceMetrics.dnlStd = std( dnlResult, 0, 1 );
adcStaticPerformanceMetrics.inlStd = std( inlResult, 0, 1 );

adcStaticPerformanceMetrics.dnlCodeIndex = 1 : numDnlCode;
adcStaticPerformanceMetrics.inlCodeIndex = 1 : numInlCode;

%% plot simulation results

[ dnlObj, inlObj ] = plotStaticStandardDeviation( p, adcStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/static-standard-deviation/standard-deviation-of-single-ended-cbw-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );

drawingInl = 'drawing/static-standard-deviation/standard-deviation-of-single-ended-cbw-adc-inl.png';
exportgraphics( inlObj, drawingInl );
