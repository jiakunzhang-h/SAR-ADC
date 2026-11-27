function capArray = genEnergySavingCdac( p )

  %% generate weight CDAC

  weightCDAC = 2 .^ ( p.adcResolution - 3 : -1 : 0 );
  
  %% include dummy capacitor

  weightArray = [2 .^ ( p.adcResolution - 1 ), weightCDAC, 1, weightCDAC, 1];

  %% actual capacitor array
  
  capArray.positiveCapArray = p.unitCap * normrnd( weightArray, p.mismatchStd .* sqrt( weightArray ) / p.numOfSmallestCap );
  capArray.negativeCapArray = p.unitCap * normrnd( weightArray, p.mismatchStd .* sqrt( weightArray ) / p.numOfSmallestCap );
  
end