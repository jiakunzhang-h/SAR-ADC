function p = configDynamicTest

  %% basic specification

  p.adcResolution = 12;
  p.fftLen = 16384;
  p.vRef = 1.2;
  p.fs = 10e6;
  p.randomInputFrequency = true;
  p.toneBin = 103;
  p.vcm = 0;
  p.inputAmplitude = 1.2;
  p.k = 1.380649e-23;   
  p.temperature = 300;  

  %% Monte Carlo specification

  p.numMonteCarlo = 1000;

  %% code density test specification

  p.samplesPerStair = 256;
  p.rampOffset = p.vRef / 2 .^ p.adcResolution / 1000;

  %% transition test spcification

  p.confidence = 0.9;
  p.dnlPrecision = 0.1;
  
  %% piecewise ramp specification

  p.halfWindow = 4;
  p.initialStop = 10;
  p.startExponent = 4;

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