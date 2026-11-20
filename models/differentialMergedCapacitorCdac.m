function Vdac = differentialMergedCapacitorCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );

  %% calculate CDAC voltage

  cdacVoltage = capArray * controlSignal .' / ( capTotal + p.capPar );

  %% calculate top-plate voltage

  Vdac = Vin + cdacVoltage - capTotal * p.vcm / ( capTotal + p.capPar );

end
