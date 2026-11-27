function capArray = genMergedCapacitorCbwCdac( p )

  %% generate weight CDAC

  weightCDAC = 2 .^ ( p.adcResolution - 2 : -1 : 0 );

  %% include dummy capacitor

  weightArray = [weightCDAC, 1];

  %% actual capacitor array

  capArray.positiveCapArray = p.unitCap * normrnd( weightArray, p.mismatchStd .* sqrt( weightArray ) / p.numOfSmallestCap );
  capArray.negativeCapArray = p.unitCap * normrnd( weightArray, p.mismatchStd .* sqrt( weightArray ) / p.numOfSmallestCap );
end