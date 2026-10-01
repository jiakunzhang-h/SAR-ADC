function capArray = genCbwCdac( p )

  %% generate weight CDAC

  weightCDAC = 2 .^ ( p.adcResolution - 1 : -1 : 0 );

  %% include dummy capacitor

  weightArray = [weightCDAC, 1];

  %% actual capacitor array
  
  capArray = p.unitCap * normrnd( weightArray, p.mismatchStd .* sqrt( weightArray / p.numOfSmallestCap ) );

end