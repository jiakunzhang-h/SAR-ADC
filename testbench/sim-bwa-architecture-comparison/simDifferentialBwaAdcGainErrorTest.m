%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentialBwaAdcComparisonStaticTest();

%% ramp histogram method

%% generate samples

histogramSamples = genDifferentialRampSamples( p );

%% allocate storage for simulation data

numTotalHistogramSamples = numel( histogramSamples.Positive );
conversionHistogramResult = nan( numTotalHistogramSamples, p.adcResolution, 3 );
histogramIdealDacOutput = nan( numTotalHistogramSamples, 3 );

%% select different architecture

dacTopology = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};
for iTopology = 1 : length( dacTopology )

  p.dacTopology = dacTopology{ iTopology };

  rng( 66 );
 
  %% generate CDAC array

  positiveCapArray = genBwaCdac( p );
  negativeCapArray = genBwaCdac( p );

  %% run simulation

  for iSample = 1 : numTotalHistogramSamples
    samplePositive = histogramSamples.Positive( iSample );
    sampleNegative = histogramSamples.Negative( iSample );
    conversionHistogramResult( iSample, :, iTopology ) = differentialBwaMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray );
    histogramIdealDacOutput( iSample, iTopology ) = idealDAC( conversionHistogramResult( iSample, :, iTopology ) );
  end


end

%% process simulation data

adcHistogramStaticPerformanceMetrics  = processComparisonDifferentialMonotonicBwaAdcHistogramData( p, histogramIdealDacOutput );

%% plot simulation results

obj = plotDifferentialBwaAdcConversionError( p, adcHistogramStaticPerformanceMetrics );

%% export plots

drawing = 'drawing/comparison-differential-bwa-adc-conversion-error.png';
exportgraphics( obj, drawing );

