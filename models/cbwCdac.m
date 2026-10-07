function Vdac = cbwCdac( Vin, p, capArray, controlSignal, dummySignal )

  %% set default value
  if nargin < 5
    dummySignal = 0;
  end

  %% modeling preparation

  capTotal = sum( capArray );
  H = ( capArray( 1 : end - 1 ) * controlSignal .' + capArray( end ) * dummySignal ) / ( capTotal + p.capPar );

  %% calculate vdac

  Vdac = p.dacVcm - Vin + p.vRef * H;

end