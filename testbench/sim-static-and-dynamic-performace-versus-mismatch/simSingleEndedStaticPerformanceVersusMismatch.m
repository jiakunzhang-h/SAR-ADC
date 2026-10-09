%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configSingleEndedAdcStaticPerformanceVersusMismatchTest();

%% allocate storage for simulation data

inlMaxResult = nan( 5, length( p.mismatchStdList ) );
dnlMaxResult = nan( 5, length( p.mismatchStdList ) );

%% set the seed

rng( 41 );

%% ramp histogram method


%% generate samples

histogramSamples = genRampSamples( p );

for iMismatchStd = 1 : length( p.mismatchStdList )

  %% allocate storage for simulation data

  numTotalHistogramSamples = p.samplesPerStair * 2 .^ p.adcResolution;
  conversionHistogramResult = nan( numTotalHistogramSamples, p.adcResolution, 5 );
  histogramIdealDacOutput = nan( numTotalHistogramSamples, 5 );


  %% set the mismatch standard deviation for the comparison

  p.mismatchStd = p.mismatchStdList( iMismatchStd );

  for iTopology = 1 : length( p.dacTopologyList )

    %% select different  BWA architecture

    p.dacTopology = p.dacTopologyList{ iTopology };

    %% generate  BWA CDAC array

    capArray = genBwaCdac( p );

    %% run simulation

    for iSample = 1 : numTotalHistogramSamples
      sample = histogramSamples( iSample );
      conversionHistogramResult( iSample, :, iTopology ) = bwaSarAdc( sample, p, capArray );
      histogramIdealDacOutput( iSample, iTopology ) = idealDAC( conversionHistogramResult( iSample, :, iTopology ) );
    end
  end
  %% gererate CBW CDAC array

  capArray = genCbwCdac( p );

  %% run simulation

  for iSample = 1 : numTotalHistogramSamples
    sample = histogramSamples( iSample );
    conversionHistogramResult( iSample, :, 4 ) = cbwSarAdc( sample, p, capArray );
    histogramIdealDacOutput( iSample, 4 ) = idealDAC( conversionHistogramResult( iSample, :, 4 ) );
  end

  %% gererate SBW CDAC array

  capArray = genSbwCdac( p );

  %% run simulation

  for iSample = 1 : numTotalHistogramSamples
    sample = histogramSamples( iSample );
    conversionHistogramResult( iSample, : , 5 ) = sbwSarAdc( sample, p, capArray );
    histogramIdealDacOutput( iSample, 5 ) = idealDAC( conversionHistogramResult( iSample, :, 5 ) );
  end

  %% process simulation data

  adcDynamicPerformanceMetrics = processStaticPerformanceVersusMismatchData( p, histogramIdealDacOutput );
  inlMaxResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.inlMaxResult;
  dnlMaxResult( :, iMismatchStd ) = adcDynamicPerformanceMetrics.dnlMaxResult;

end

%% plot simulation results

%% plot simulation results

[dnlObj, inlObj] = plotStaticPerformanceVersusMismatchSimulationResult( p, inlMaxResult, dnlMaxResult );

%% export plots

drawingDnl = 'drawing/comparison-single-ended-adc-dnl-max-versus-mismatch.png';
exportgraphics( dnlObj, drawingDnl );

drawingInl = 'drawing/comparison-single-ended-adc-inl-max-versus-mismatch.png';
exportgraphics( inlObj, drawingInl );