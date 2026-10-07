function samples = genDifferentialRampSamples( p )

  %% calculate LSB

  voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;

  %% calculate voltage step

  voltStep = voltageLSB / p.samplesPerStair;

  %% generate ramp signal

  sampleVoltage = - p.vRef + p.rampOffset : voltStep : p.vRef;

  %% generate differential samples

  samples.Positive = p.vcm + sampleVoltage / 2;
  samples.Negative = p.vcm - sampleVoltage / 2;

end