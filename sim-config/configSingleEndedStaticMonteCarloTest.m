function p = configSingleEndedStaticMonteCarloTest

  %% basic specification

  p.adcResolution = 12;
  p.vRef = 1.2;
  p.voltageLSB = p.vRef / 2 .^ p.adcResolution;
  p.fs = 10e6;
  p.randomInputFrequency = true;
  p.toneBin = 103;
  p.vcm = 0.6;
  p.inputAmplitude = 0.6;
  p.k = 1.380649e-23;
  p.temperature = 300;

  %% binary search test specification

  p.voltageTolerance = 0.01;

  %% fast INL test specification

  p.halfWindow = 4;
  p.initialStop = 10;
  p.startExponent = 4;
  p.fastSamplesPerStair = 256;

  %% Monte Carlo specification

  p.numMonteCarlo = 1000;

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStd = 0.01;
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


end