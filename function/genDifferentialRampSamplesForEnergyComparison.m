function samples = genDifferentialRampSamplesForEnergyComparison( p )

  %% calculate LSB

  voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;

  %% generate ramp signal

  sampleVoltage = - p.vRef + p.rampOffset : voltageLSB : p.vRef;

  %% generate differential samples

  samples.Positive = p.vcm + sampleVoltage / 2;
  samples.Negative = p.vcm - sampleVoltage / 2;

end