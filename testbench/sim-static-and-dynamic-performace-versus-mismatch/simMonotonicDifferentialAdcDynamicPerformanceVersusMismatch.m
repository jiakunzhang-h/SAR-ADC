%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialMonotonicAdcDynamicPerformanceVersusMismatchTest();

%% allocate storage for simulation data

enobResult = nan( 4, length( p.mismatchStdList ) );

%% set the seed

rng( 41 );

%% generate samples

samples = genDifferentialSamples( p );

for iMismatchStd = 1 : length( p.mismatchStdList )

  %% allocate storage for simulation data

  conversionResult = nan( p.fftLen, p.adcResolution, 4 );
  idealDacOutput = nan( p.fftLen, 4 );

  %% set the mismatch standard deviation for the comparison

  p.mismatchStd = p.mismatchStdList( iMismatchStd );

  for iTopology = 1 : length( p.dacTopologyList )

    %% select different  BWA architecture

    p.dacTopology = p.dacTopologyList{ iTopology };

    %% generate CDAC array

    positiveCapArray = genBwaCdac( p );
    negativeCapArray = genBwaCdac( p );

    %% run simulation

    for iSample = 1 : p.fftLen
      samplePositive = samples.positiveInput( iSample );
      sampleNegative = samples.negativeInput( iSample );
      conversionResult( iSample, :, iTopology ) = differentialBwaMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
      idealDacOutput( iSample, iTopology ) = idealDAC( conversionResult( iSample, :, iTopology ) );
    end

  end

  %% generate CDAC array

  positiveCapArray = genMonotonicCbwCdac( p );
  negativeCapArray = genMonotonicCbwCdac( p );

  %% run simulation

  for iSample = 1 : p.fftLen
    samplePositive = samples.positiveInput( iSample );
    sampleNegative = samples.negativeInput( iSample );
    conversionResult( iSample, : , 4 ) = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    idealDacOutput( iSample, 4 ) = idealDAC( conversionResult( iSample, :, 4 ) );
  end

  %% process simulation data

  adcDynamicPerformanceMetrics = processDynamicPerformanceVersusMismatchData( p, samples, idealDacOutput );
  enobResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.enob;

end

%% plot simulation results

obj = plotDynamicPerformanceVersusMismatchSimulationResult( p, enobResult );

%% export plots

drawingSpectrum = sprintf( 'drawing/comparison-differential-monotonic-adc-enob-versus-mismatch.png' );
exportgraphics( obj, drawingSpectrum );
