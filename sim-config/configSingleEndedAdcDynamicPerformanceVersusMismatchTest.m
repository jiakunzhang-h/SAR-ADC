function p = configSingleEndedAdcDynamicPerformanceVersusMismatchTest

  %% basic specification

  p.adcResolution = 24;
  p.fftLen = 4096;
  p.vRef = 1.2;
  p.fs = 10e6;
  p.randomInputFrequency = true;
  p.toneBin = 103;
  p.vcm = 0.6;
  p.inputAmplitude = 0.58;
  p.k = 1.380649e-23;   
  p.temperature = 300;  

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStdList = [ 0.00001, 0.0001, 0.001, 0.01, 0.1 ];
  p.mismatchStd = 0.01;
  p.capPar = 0;
  p.dacVcm = 0;
  p.mainArraySize = 12;
  p.subArraySize = 12;
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