%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDynamicTest();

%% allocate storage for simulation data

conversionResult = nan( p.fftLen, p.adcResolution + 1 );
idealDacOutput = nan( p.fftLen, 1 );
cdacTrace = nan( p.fftLen, p.adcResolution, 2 );

%% generate samples

samples = genDifferentialSamples( p );

%% generate CDAC array

positiveCapArray = genSbwCdac( p );
negativeCapArray = genSbwCdac( p );

%% run simulation

for iSample = 1 : p.fftLen
  samplePositive = samples.positiveInput( iSample );
  sampleNegative = samples.negativeInput( iSample );
  [conversionResult( iSample, : ), sampleCdacTrace] = differentialSbwSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
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

randomIndex = randi( p.fftLen );
randomTrace = squeeze( cdacTrace( randomIndex, :, : ) );
randomSample = samples.positiveInput( randomIndex ) - samples.negativeInput( randomIndex );
traceObj = plotDifferentialCdacTrace( p, randomTrace, randomSample );

%% export plots

drawingSpectrum = 'drawing/differential-sbw-adc-spectrum.png';
exportgraphics( obj, drawingSpectrum );
drawingTrace = 'drawing/differential-sbw-cdac-conversion.png';
exportgraphics( traceObj, drawingTrace);


