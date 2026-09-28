function [Vdac, cdacVoltage] = cbwTopSampleCdac( Vin, p, capArray, controlSignal )

  %% modeling preparation

  capTotal = sum( capArray );
  H = capArray( 1 : end - 1 ) * controlSignal .' / ( capTotal + p.capPar );

  %% calculate CDAC voltage

  cdacVoltage = p.vRef * H;

  %% calculate top-plate voltage

  Vdac = Vin + cdacVoltage;
  
end