function Vdac = cbwCdac( Vin, p, capArray, digitalWord )

  %% modeling preparation

  capTotal = sum( capArray );
  H = capArray( 1 : end - 1 ) * digitalWord .' / ( capTotal + p.capPar );

  %% calculate vdac

  Vdac = - Vin + p.vRef * H;

end