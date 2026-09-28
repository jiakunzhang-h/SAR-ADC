function [conversionResult, cdacTrace] = sbwSarAdc( sample, p, capArray )

  %% SAR logic initialization

  digitalWord = zeros( 1, p.adcResolution );
  cdacTrace = nan( 1, p.adcResolution );

  %% calculate thermal noise

  %%capTotal = sum( capArray );
  %%thermalNoiseStd = sqrt( p.k * p.temperature / capTotal );
  %%thermalNoise = normrnd( 0, thermalNoiseStd );

  %% inject thermal noise

  %%sample = sample + thermalNoise;

  %% binary search

  for iCycle = 1 : p.adcResolution

    %% Trial current bit

    digitalWord( iCycle ) = 1;

    %% CDAC

    vCompIn = sbwCdac( sample, p, capArray, digitalWord );
    cdacTrace( iCycle ) = vCompIn + sample;

    %% Comparator

    compVout = comparator( vCompIn, 0, p );

    %% SAR Logic

    digitalWord = sarLogic( digitalWord, iCycle, compVout );

  end

  %% output

  conversionResult = digitalWord;

end