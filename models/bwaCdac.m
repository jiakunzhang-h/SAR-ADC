function Vdac = bwaCdac( Vin, p, capArray, digitalWord, dummySignal )

  %% set default value
  if nargin < 5 
    dummySignal = 0;
  end

  %% load parameter

  capTotalMain = sum( capArray.main );
  capTotalSub = sum( capArray.sub );

  %% calculate attenuation factor

  AR = capArray.att / ( capTotalMain + capArray.att + p.capParMain );

  %% calculate factors for different topologies

  switch p.dacTopology
    case 'split-array_type-1'
      hSub = ( capArray.sub( 1 : end - 1 ) * digitalWord( p.mainArraySize + 1 : end ).' + capArray.sub( end ) * dummySignal ) / ( capTotalSub + p.capParSub + capArray.att );
      hMain = capArray.main * digitalWord( 1 : p.mainArraySize ) .' / ( capTotalMain + p.capParMain + capArray.att );
    case 'split-array_type-2'
      hSub = capArray.sub * digitalWord( p.mainArraySize + 1 : end ).' / ( capTotalSub + p.capParSub + capArray.att );
      hMain = ( capArray.main( 1 : end - 1 ) * digitalWord( 1 : p.mainArraySize ) .' + capArray.main( end ) * dummySignal ) / ( capTotalMain + p.capParMain + capArray.att );
    case 'split-array_type-3'
      hSub = capArray.sub * digitalWord( p.mainArraySize + 1 : end ).' / ( capTotalSub + p.capParSub + capArray.att );
      hMain = capArray.main * digitalWord( 1 : p.mainArraySize ) .' / ( capTotalMain + p.capParMain + capArray.att );
  end

  %% calculate vdac

  H = hMain + AR * hSub;
  Vdac = p.dacVcm - Vin + p.vRef * H;

end