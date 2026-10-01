function Vdac = cbwCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );
  H = capArray( 1 : end - 1 ) * controlSignal .' / ( capTotal + p.capPar );

  %% calculate vdac

  Vdac = p.dacVcm - Vin + p.vRef * H;

end