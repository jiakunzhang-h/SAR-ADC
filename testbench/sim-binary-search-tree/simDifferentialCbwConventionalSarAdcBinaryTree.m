%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configBinaryTreeTest();

%% generate samples

samples = genDifferentialRampSamplesForEnergyComparison( p );

numSamples = numel( samples.Positive );

%% allocate storage for simulation data

cdacTrace = nan( numSamples, p.adcResolution + 1, 2 );
conversionResult = nan( numSamples, p.adcResolution );
idealDacOutput = nan( numSamples, 1 );
differentialCdacTrace = nan( numSamples, p.adcResolution + 1 );
decisionVoltage = nan( numSamples, p.adcResolution + 1 );

%% generate CDAC array

capArray = genDifferentialCbwCdac( p );

%% run simulation

for iSample = 1 : numSamples
  samplePositive = samples.Positive( iSample );
  sampleNegative = samples.Negative( iSample );
  [ conversionResult( iSample, : ), sampleCdacTrace ] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, capArray );
  cdacTrace( iSample, :, : ) = sampleCdacTrace;
  idealDacOutput( iSample ) = idealDAC( conversionResult( iSample, : ) );
end

%% calculate differential input voltage

inputVoltage = samples.Positive( : ) - samples.Negative( : );

%% calculate differential CDAC voltage

differentialCdacTrace( :, 1 : end - 1 ) = cdacTrace( :, 2 : end, 1 ) - cdacTrace( :, 2 : end, 2 );

%% calculate decision voltage

decisionVoltage( :, 1 : end - 1 ) = inputVoltage + differentialCdacTrace( :, 1 : end - 1 );
decisionVoltage( :, end ) = -p.vRef + ( idealDacOutput + 0.5 ) .* p.voltageLSB;

%% plot binary decision tree

traceObj = plotDifferentialSarAdcBinaryTree( p, numSamples, decisionVoltage );


%% export plots

drawingTrace = 'drawing/differential-cbw-conventional-binary-tree.png';
drawing = [ 'drawing/binary-search-tree/', num2str( p.adcResolution ), 'bit-binary-search-tree-with-mismatch', num2str( p.mismatchStd ), '.png' ];
exportgraphics( traceObj, drawing );