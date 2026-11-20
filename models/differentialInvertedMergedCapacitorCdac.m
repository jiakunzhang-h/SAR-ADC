function Vdac = differentialInvertedMergedCapacitorCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );

  %% calculate CDAC voltage

  cdacVoltage = capArray * controlSignal .' / ( capTotal + p.capPar );

  %% calculate top-plate voltage

  Vdac = p.vcm + cdacVoltage - capTotal * Vin / ( capTotal + p.capPar );

end
