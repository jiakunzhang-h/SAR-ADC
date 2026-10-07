function [samplePositive, sampleNegative] = genDifferentialPiecewiseRampSamples( p )

  %% calculate LSB

  voltageLSB = 2 * p.vRef / 2 .^ p.adcResolution;

  %% ramp step

  voltStep = voltageLSB / p.fastSamplesPerStair;

  %% first segment

  sampleVoltage = 0 : voltStep : p.initialStop * voltageLSB;

  %% generate transition centers

  transitionCode = 2 .^ ( p.startExponent : p.adcResolution - 1 );

  %% generate local ramp around each transition

  for iTransition = 1 : length( transitionCode )

    lowerCode = transitionCode( iTransition ) - p.halfWindow;
    upperCode = transitionCode( iTransition ) + p.halfWindow;

    localVoltage = lowerCode * voltageLSB : voltStep : upperCode * voltageLSB;

    sampleVoltage = [sampleVoltage, localVoltage];

  end

 %% shift to differential input range

  sampleVoltage = -p.vRef + p.rampOffset + sampleVoltage;

  %% generate differential samples

  samplePositive = p.vcm + sampleVoltage / 2;
  sampleNegative = p.vcm - sampleVoltage / 2;

end