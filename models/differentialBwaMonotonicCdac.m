
function Vdac = differentialBwaMonotonicCdac( Vin, p, capArray, controlSignal )

  %% load parameter

  capTotalMain = sum( capArray.main );
  capTotalSub = sum( capArray.sub );

  %% calculate control signal variation

  deltaControl = controlSignal - 1;

  %% calculate attenuation factor

  AR = capArray.att / ( capTotalMain + capArray.att + p.capParMain );

  %% calculate factors for different topologies

  switch p.dacTopology

    case 'split-array_type-1'

      hSub = capArray.sub( 1 : end - 1 ) * deltaControl( p.mainArraySize + 1 : end ).' / ...
        ( capTotalSub + p.capParSub + capArray.att );

      hMain = capArray.main * deltaControl( 1 : p.mainArraySize ).' / ...
        ( capTotalMain + p.capParMain + capArray.att );

    case 'split-array_type-2'

      hSub = capArray.sub * deltaControl( p.mainArraySize + 1 : end ).' / ...
        ( capTotalSub + p.capParSub + capArray.att );

      hMain = capArray.main( 1 : end - 1 ) * deltaControl( 1 : p.mainArraySize ).' / ...
        ( capTotalMain + p.capParMain + capArray.att );

    case 'split-array_type-3'

      hSub = capArray.sub * deltaControl( p.mainArraySize + 1 : end ).' / ...
        ( capTotalSub + p.capParSub + capArray.att );

      hMain = capArray.main * deltaControl( 1 : p.mainArraySize ).' / ...
        ( capTotalMain + p.capParMain + capArray.att );

  end

  %% calculate CDAC voltage

  H = hMain + AR * hSub;

  cdacVoltage = p.vRef * H;

  %% calculate top-plate voltage

  Vdac = Vin + cdacVoltage;

end
