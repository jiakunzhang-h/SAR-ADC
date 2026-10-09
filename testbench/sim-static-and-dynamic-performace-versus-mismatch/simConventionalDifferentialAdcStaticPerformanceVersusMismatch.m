%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialConventionalAdcStaticPerformanceVersusMismatchTest();

%% allocate storage for simulation data

inlMaxResult = nan( 4, length( p.mismatchStdList ) );
dnlMaxResult = nan( 4, length( p.mismatchStdList ) );

%% set the seed

rng( 120 );

%% fast inl method

%% generate piecewise ramp samples

[positiveSamples, negativeSamples] = genDifferentialPiecewiseRampSamples( p );

for iMismatchStd = 1 : length( p.mismatchStdList )

  %% allocate storage for simulation data

  numTotalFastInlSamples = numel( positiveSamples );
  conversionFastInlResult = nan( numTotalFastInlSamples, p.adcResolution, 4 );
  fastInlIdealDacOutput = nan( numTotalFastInlSamples, 4 );


  %% set the mismatch standard deviation for the comparison

  p.mismatchStd = p.mismatchStdList( iMismatchStd );

  for iTopology = 1 : length( p.dacTopologyList )

    %% select different  BWA architecture

    p.dacTopology = p.dacTopologyList{ iTopology };

    %% generate  BWA CDAC array

    positiveCapArray = genBwaCdac( p );
    negativeCapArray = genBwaCdac( p );


    %% run simulation

    for iSample = 1 : numTotalFastInlSamples
      samplePositive = positiveSamples( iSample );
      sampleNegative = negativeSamples( iSample );
      conversionFastInlResult( iSample, :, iTopology ) = differentialBwaConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
      fastInlIdealDacOutput( iSample, iTopology ) = idealDAC( conversionFastInlResult( iSample, :, iTopology ) );
    end
  end
  %% gererate CBW CDAC array

  positiveCapArray = genCbwCdac( p );
  negativeCapArray = genCbwCdac( p );

  %% run simulation

  for iSample = 1 : numTotalFastInlSamples
    samplePositive = positiveSamples( iSample );
    sampleNegative = negativeSamples( iSample );
    conversionFastInlResult( iSample, :, 4 ) = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    fastInlIdealDacOutput( iSample, 4 ) = idealDAC( conversionFastInlResult( iSample, :, 4 ) );
  end

  %% process simulation data

  adcDynamicPerformanceMetrics = processDifferentialConventionalStaticPerformanceVersusMismatchData( p, fastInlIdealDacOutput );
  inlMaxResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.inlMaxResult;
  dnlMaxResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.dnlMaxResult;

end

%% plot simulation results

[dnlObj, inlObj] = plotStaticPerformanceVersusMismatchSimulationResult( p, inlMaxResult, dnlMaxResult );

%% export plots

drawingDnl = 'drawing/comparison-differential-conventional-adc-dnl-max-versus-mismatch.png';
exportgraphics( dnlObj, drawingDnl );

drawingInl = 'drawing/comparison-differential-conventional-adc-inl-max-versus-mismatch.png';
exportgraphics( inlObj, drawingInl );