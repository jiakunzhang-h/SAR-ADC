%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialBwaAdcComparisonStaticTest();

%% fast inl method

%% generate piecewise ramp samples

[positiveSamples, negativeSamples] = genDifferentialPiecewiseRampSamples( p );

%% allocate storage for simulation data

numTotalFastInlSamples = numel( positiveSamples );
conversionFastInlResult = nan( numTotalFastInlSamples, p.adcResolution, 3 );
fastInlIdealDacOutput = nan( numTotalFastInlSamples, 3 );

%% select different architecture

dacTopology = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};
for iTopology = 1 : length( dacTopology )

  p.dacTopology = dacTopology{ iTopology };

  rng( 21 );
 
  %% generate CDAC array

  positiveCapArray = genBwaCdac( p );
  negativeCapArray = genBwaCdac( p );

  %% run simulation

  for iSample = 1 : numTotalFastInlSamples
    samplePositive = positiveSamples( iSample );
    sampleNegative = negativeSamples( iSample );
    conversionFastInlResult( iSample, :, iTopology ) = differentialBwaMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    fastInlIdealDacOutput( iSample, iTopology ) = idealDAC( conversionFastInlResult( iSample, :, iTopology ) );
  end


end

%% process simulation data

adcFastInlStaticPerformanceMetrics  = processComparisonDifferentialMonotonicBwaAdcFastInlData( p, fastInlIdealDacOutput );

%% plot simulation results

[dnlObj, inlObj] = plotComparisonDifferentialAdcStaticSimulationResult( p, adcFastInlStaticPerformanceMetrics );

%% export plots

drawingDnl = 'drawing/comparison-differential-bwa-conventional-adc-dnl.png';
exportgraphics( dnlObj, drawingDnl );
drawingInl = 'drawing/comparison-differential-bwa-conventional-adc-inl.png';
exportgraphics( inlObj, drawingInl );

