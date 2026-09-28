function [Vdac, cdacVoltage] = sbwTopSampleCdac( Vin, p, capArray, controlSignal )

  %% determine the location of the vital bit

  for iMsbWord = 1 : p.adcResolution
    if controlSignal( iMsbWord ) == 1
      break
    end
  end

  %% transform digital word to digtalWordMSB and digitalWordRest

  digitalWordMSB = [zeros( 1, iMsbWord - 1 ), ones( 1, p.adcResolution - iMsbWord + 1 )];
  digitalWordRest = [zeros( 1, iMsbWord - 1 ), controlSignal( iMsbWord + 1 : p.adcResolution )];

  %% modeling preparation

  capTotal = sum( capArray );
  hMsb = capArray( 1 : p.adcResolution ) * digitalWordMSB .' / ( capTotal + p.capPar );
  hRest = capArray( p.adcResolution + 1 : end - 1 ) * digitalWordRest .' / ( capTotal + p.capPar );
  H = hMsb + hRest;

  %% calculate CDAC voltage

  cdacVoltage = p.vRef * H;

  %% calculate top-plate voltage

  Vdac = Vin + cdacVoltage;

end