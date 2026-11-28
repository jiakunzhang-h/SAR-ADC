function p = configDifferentialStaticMonteCarloTest

  %% basic specification

  p.adcResolution = 5;
  p.vRef = 1.2;
  p.voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;
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

  p.numMonteCarlo = 5000;

  %% CDAC specification

  p.smallestCap = 50e-15;
  p.numOfSmallestCap = 1;
  p.unitCap = p.smallestCap * p.numOfSmallestCap;
  p.mismatchStd = 0.03;
  p.capPar = 0;

  %% Comparator specification

  p.compVos = 0;
  p.compNoise = 0;

  %% conversion function specification

  p.adcConversionFunctionList = { @differentialCbwConventionalSarAdc, @differentialSbwSarAdc };

end