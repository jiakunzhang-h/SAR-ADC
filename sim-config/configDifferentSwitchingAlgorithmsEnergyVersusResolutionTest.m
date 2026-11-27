function p = configDifferentSwitchingAlgorithmsEnergyVersusResolutionTest

  %% basic specification

  p.adcResolutionArray = 3 : 16;
  p.vRef = 1.2;
  p.fs = 10e6;
  p.vcm = 0.6;
  p.inputAmplitude = 1.2;
  p.k = 1.380649e-23;
  p.temperature = 300;

  %% histogram test specification

  p.numTotalHistogramSamples = 2 .^ p.adcResolutionArray;
  p.maxAdcResolution = max( p.adcResolutionArray );
  p.sampleStepArray = 2 .^ ( p.maxAdcResolution - p.adcResolutionArray );
  p.sampleStartArray = floor( p.sampleStepArray / 2 ) + 1;

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStd = 0;
  p.capPar = 0;
  p.mainArraySize = 6;
  p.subArraySize = 5;
  p.capParMain = 0;
  p.capParSub = 0;
  p.dacTopology = 'split-array_type-3';
  p.matching = 'good';
  p.bridgeCapWeight = 1;

  %% comparator specification

  p.compVos = 0;
  p.compNoise = 0;

  %% simulation specification

  p.capGenerationFunctionList = { ...
    @genDifferentialCbwCdac, @genDifferentialSbwCdac, ...
    @genEnergySavingCdac, @genDifferentialMonotonicCbwCdac, ...
    @genMergedCapacitorCbwCdac, @genInvertedMergedCapacitorCbwCdac ...
    };

  p.conversionFunctionList = { ...
    @differentialCbwConventionalSarAdc, @differentialSbwSarAdc, ...
    @differentialEnergySavingSarAdc, @differentialCbwMonotonicSarAdc, ...
    @differentialMergedCapacitorSarAdc, @differentialInvertedMergedCapacitorSarAdc ...
    };

  %% generate configurations for different resolutions

  resolutionConfig = repmat( p, 1, numel( p.adcResolutionArray ) );

  for iResolution = 1 : numel( p.adcResolutionArray )
    resolutionConfig( iResolution ).adcResolution = p.adcResolutionArray( iResolution );
    resolutionConfig( iResolution ).sampleIndex = p.sampleStartArray( iResolution ) : p.sampleStepArray( iResolution ) : 2 ^ p.maxAdcResolution;
  end

  p.resolutionConfig = resolutionConfig;

end