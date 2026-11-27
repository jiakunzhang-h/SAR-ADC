function p = configBinaryTreeTest

  %% basic specification

  p.adcResolution = 4;
  p.vRef = 1.2;
  p.voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;
  p.fs = 10e6;
  p.randomInputFrequency = true;
  p.toneBin = 103;
  p.vcm = 0.6;
  p.inputAmplitude = 1.2;
  p.k = 1.380649e-23;
  p.temperature = 300;

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStd = 0;
  p.mismatchArray = { 0, 0.05, 0.5 };
  p.capPar = 0;
  p.dacVcm = 0;
  p.mainArraySize = 6;
  p.subArraySize = 6;
  p.capParMain = 0;
  p.capParSub = 0;
  p.dacTopology = 'split-array_type-3';
  p.matching = 'good';
  p.bridgeCapWeight = 1;

  %% Comparator specification

  p.compVos = 0;
  p.compNoise = 0;

  %% generate configurations for different mismatches

  mismatchConfig = repmat( p, 1, numel( p.mismatchArray ) );

  for iMismatch = 1 : numel( p.mismatchArray )
    mismatchConfig( iMismatch ).mismatchStd = p.mismatchArray{ iMismatch };
  end

  p.mismatchConfig = mismatchConfig;

end