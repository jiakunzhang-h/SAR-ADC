
function Vdac = differentialSbwCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );

  %% considering the parasitic capacitance

  H = capArray * controlSignal .' / ( capTotal + p.capPar );

  %% calculate vdac

  Vdac = p.vcm - Vin + p.vRef * H;

end