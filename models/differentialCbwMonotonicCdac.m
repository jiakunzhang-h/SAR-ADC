function Vdac = differentialCbwMonotonicCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );

  %% considering the parasitic capacitance
  deltaControl = controlSignal - 1;

  H = capArray * deltaControl .' / ( capTotal + p.capPar );

  %% calculate CDAC voltage

  cdacVoltage = p.vRef * H;

  %% calculate top-plate voltage

  Vdac = Vin + cdacVoltage;

end
