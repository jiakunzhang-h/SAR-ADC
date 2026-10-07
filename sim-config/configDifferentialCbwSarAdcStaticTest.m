function p = configDifferentialCbwSarAdcStaticTest

  %% basic specification

  p.adcResolution = 12;
  p.vRef = 1.2;
  p.vcm = 0;
  p.inputAmplitude = 1.2;
  p.k = 1.380649e-23;   
  p.temperature = 300;  

  %% code density test specification

  p.samplesPerStair = 100;
  p.rampOffset = 2 * p.vRef / 2 .^ p.adcResolution / 1000;

  %% transition test spcification

  p.confidence = 0.9;
  p.dnlPrecision = 0.1;
  
  %% fast INL test specification

  p.halfWindow = 4;
  p.initialStop = 10;
  p.startExponent = 4;
  p.fastSamplesPerStair = 256;

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStd = 0.01;
  p.capPar = 0;
  p.dacVcm = 0;
  
  %% Comparator specification

  p.compVos = 0;
  p.compNoise = 0;
  
end