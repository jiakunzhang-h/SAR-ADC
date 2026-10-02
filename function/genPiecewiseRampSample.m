function samples = genPiecewiseRampSample( p )

  %% calculate LSB

  voltageLSB = p.vRef / 2 .^ p.adcResolution;

  %% ramp step

  voltStep = voltageLSB / p.samplesPerStair;

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

  %% add ramp offset

  samples = p.rampOffset + sampleVoltage;

end