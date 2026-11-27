%% simulation preparation

clear
close all
clc
format long g

%% set the seed

rng( 225 );

%% load simulation configuration and parameters

p = configDifferentialConventionalDynamicTest();

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, p.adcResolution );
idealDacOutput = nan( p.fftLen, 1 );
cdacTrace = nan( p.fftLen, p.adcResolution + 1, 2 );

%% generate samples

samples = genDifferentialSamples( p );

%% generate CDAC array

capArray = genDifferentialCbwCdac( p );

%% run simulation

for iSample = 1 : p.fftLen
  samplePositive = samples.positiveInput( iSample );
  sampleNegative = samples.negativeInput( iSample );
  [conversionResult( iSample, : ), sampleCdacTrace] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, capArray );
  cdacTrace( iSample, :, : ) = sampleCdacTrace;
  idealDacOutput( iSample ) = idealDAC( conversionResult( iSample, : ) );
end

%% process simulation data

adcDynamicPerformanceMetrics = processAdcData( p, samples, idealDacOutput );
disp( adcDynamicPerformanceMetrics.enob );
disp( adcDynamicPerformanceMetrics.sndr );

%% plot simulation results

obj = plotAdcDynamicSimulationResult( p, adcDynamicPerformanceMetrics );

%% plot cdac trace 

% randomIndex = randi( p.fftLen );
randomIndex = datasample( 1 : p.fftLen, 1 );
randomTrace = squeeze( cdacTrace( randomIndex, :, : ) );
diffTrace = randomTrace( :, 1 ) - randomTrace( :, 2 );
traceObj = plotDifferentialCdacTrace( p, randomTrace, "conventional" );
diffTraceObj = plotDifferentialDiffCdacTrace( p, diffTrace, "conventional" );
%% export plots

drawingSpectrum = 'drawing/differential-cbw-conventional-adc-spectrum.png';
exportgraphics( obj, drawingSpectrum );
drawingTrace = 'drawing/differential-cbw-conventional-cdac-conversion.png';
exportgraphics( traceObj, drawingTrace);
drawingDiffTrace = 'drawing/differential-cbw-conventional-cdac-diff-conversion.png';
exportgraphics( diffTraceObj, drawingDiffTrace);


