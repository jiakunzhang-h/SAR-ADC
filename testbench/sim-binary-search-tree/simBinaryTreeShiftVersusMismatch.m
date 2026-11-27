%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configBinaryTreeTest();

%% determine the number of resolutions and switching algorithms

numMismatches = numel( p.mismatchArray );

%% generate samples

samples = genDifferentialRampSamplesForEnergyComparison( p );

numSamples = numel( samples.Positive );

%% allocate storage for simulation data
cdacTraceCell = cell( numMismatches, 1 );
conversionResultCell = cell( numMismatches, 1 );
idealDacOutputCell = cell( numMismatches, 1 );
differentialCdacTraceCell = cell( numMismatches, 1 );
decisionVoltageCell = cell( numMismatches, 1 );

%% calculate differential input voltage

inputVoltage = samples.Positive( : ) - samples.Negative( : );

for iMismatch = 1 : numMismatches

  %% select simulation configuration

  currentConfig = p.mismatchConfig( iMismatch );

  %% generate CDAC array

  capArray = genDifferentialCbwCdac( currentConfig );

  %% allocate storage for current switching algorithm

  cdacTraceCell{ iMismatch } = nan( numSamples, p.adcResolution + 1, 2 );
  conversionResultCell{ iMismatch } = nan( numSamples, p.adcResolution );
  idealDacOutputCell{ iMismatch } = nan( numSamples, 1 );
  differentialCdacTraceCell{ iMismatch } = nan( numSamples, p.adcResolution + 1 );
  decisionVoltageCell{ iMismatch } = nan( numSamples, p.adcResolution + 1 );
  %% run simulation

  for iSample = 1 : numSamples
    samplePositive = samples.Positive( iSample );
    sampleNegative = samples.Negative( iSample );
    [ conversionResultCell{ iMismatch }( iSample, : ), sampleCdacTrace ] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, currentConfig, capArray );
    cdacTraceCell{ iMismatch }( iSample, :, : ) = sampleCdacTrace;
    idealDacOutputCell{ iMismatch }( iSample ) = idealDAC( conversionResultCell{ iMismatch }( iSample, : ) );
  end


  %% calculate differential CDAC voltage

  differentialCdacTraceCell{ iMismatch }( :, 1 : end - 1 ) = cdacTraceCell{ iMismatch }( :, 2 : end, 1 ) - cdacTraceCell{ iMismatch }( :, 2 : end, 2 );

  %% calculate decision voltage

  decisionVoltageCell{ iMismatch }( :, 1 : end - 1 ) = inputVoltage + differentialCdacTraceCell{ iMismatch }( :, 1 : end - 1 );
  decisionVoltageCell{ iMismatch }( :, end ) = -p.vRef + ( idealDacOutputCell{ iMismatch } + 0.5 ) .* p.voltageLSB;

end

%% plot binary decision tree

traceObj = plotDifferentialSarAdcBinaryTreeWithMismatch( p, numSamples, decisionVoltageCell );

%% export plots

drawingTrace = 'drawing/differential-cbw-conventional-binary-tree.png';
drawing = [ 'drawing/binary-search-tree/', num2str( p.adcResolution ), 'bit-binary-search-tree-with-The effect-of-capacitor-mismatch.png' ];
exportgraphics( traceObj, drawing );
