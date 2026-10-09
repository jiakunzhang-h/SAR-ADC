%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configSingleEndedAdcDynamicPerformanceVersusMismatchTest();

%% allocate storage for simulation data

enobResult = nan( 5, length( p.mismatchStdList ) );

%% set the seed

rng( 41 );

%% generate samples

samples = genSamples( p );

for iMismatchStd = 1 : length( p.mismatchStdList )

  %% allocate storage for simulation data

  conversionResult = nan( p.fftLen, p.adcResolution, 5 );
  idealDacOutput = nan( p.fftLen, 5 );

  %% set the mismatch standard deviation for the comparison

  p.mismatchStd = p.mismatchStdList( iMismatchStd );

  for iTopology = 1 : length( p.dacTopologyList )

    %% select different  BWA architecture

    p.dacTopology = p.dacTopologyList{ iTopology };

    %% generate  BWA CDAC array

    capArray = genBwaCdac( p );

    %% run simulation

    for iSample = 1 : p.fftLen
      sample = samples.data( iSample );
      conversionResult( iSample, : , iTopology ) = bwaSarAdc( sample, p, capArray );
      idealDacOutput( iSample, iTopology ) = idealDAC( conversionResult( iSample, :, iTopology ) );
    end

  end
  %% gererate CBW CDAC array

  capArray = genCbwCdac( p );

  %% run simulation

  for iSample = 1 : p.fftLen
    sample = samples.data( iSample );
    conversionResult( iSample, : , 4 ) = cbwSarAdc( sample, p, capArray );
    idealDacOutput( iSample, 4 ) = idealDAC( conversionResult( iSample, :, 4 ) );
  end

  %% gererate SBW CDAC array

  capArray = genSbwCdac( p );

  %% run simulation

  for iSample = 1 : p.fftLen
    sample = samples.data( iSample );
    conversionResult( iSample, : , 5 ) = sbwSarAdc( sample, p, capArray );
    idealDacOutput( iSample, 5 ) = idealDAC( conversionResult( iSample, :, 5 ) );
  end

  %% process simulation data

  adcDynamicPerformanceMetrics = processDynamicPerformanceVersusMismatchData( p, samples, idealDacOutput );
  enobResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.enob;

end

%% plot simulation results

obj = plotDynamicPerformanceVersusMismatchSimulationResult( p, enobResult );

%% export plots

drawingSpectrum = sprintf( 'drawing/comparison-single-ended-adc-enob-versus-mismatch.png' );
exportgraphics( obj, drawingSpectrum );

