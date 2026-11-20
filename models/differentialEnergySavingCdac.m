function Vdac = differentialEnergySavingCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );

  %% considering the parasitic capacitance

  H = capArray * controlSignal .' / ( capTotal + p.capPar );

  %% calculate CDAC voltage

  cdacVoltage = p.vRef * H;

  %% calculate top-plate voltage

  Vdac = p.vRef + cdacVoltage - capTotal * Vin / ( capTotal + p.capPar );

end
