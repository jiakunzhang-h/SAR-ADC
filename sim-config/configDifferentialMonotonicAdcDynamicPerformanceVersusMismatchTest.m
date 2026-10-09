function p = configDifferentialMonotonicAdcDynamicPerformanceVersusMismatchTest

  %% basic specification

  p.adcResolution = 12;
  p.fftLen = 16384;
  p.vRef = 1.2;
  p.fs = 10e6;
  p.randomInputFrequency = true;
  p.toneBin = 103;
  p.vcm = 0;
  p.inputAmplitude = 1.11;
  p.k = 1.380649e-23;   
  p.temperature = 300;  

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStdList = [ 0,  0.01, 0.02, 0.03, 0.04, 0.05, 0.06, 0.07, 0.08, 0.09, 0.1];
  p.mismatchStd = 0.01;
  p.capPar = 0;
  p.dacVcm = 0;
  p.mainArraySize = 6;
  p.subArraySize = 5;
  p.capParMain = 0;
  p.capParSub = 0;
  p.dacTopology = 'split-array_type-3';
  p.dacTopologyList = {'split-array_type-1', 'split-array_type-2', 'split-array_type-3'};
  p.matching = 'good';
  p.bridgeCapWeight = 1;
  
  %% Comparator specification

  p.compVos = 0;
  p.compNoise = 0;
  
end