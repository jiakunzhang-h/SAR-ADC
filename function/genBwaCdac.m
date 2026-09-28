function capArray = genBwaCdac( p )

  %% choose topology

  switch p.dacTopology
    case 'split-array_type-1'
      mainArrayExponent = p.mainArraySize - 1 : -1 : 0;
      subArrayExponent = [p.subArraySize - 1 : -1 : 0, 0];
      mainArrayCapWeight = 2 .^ mainArrayExponent;
      subArrayCapWeight = 2 .^ subArrayExponent;
      capWeight = [mainArrayCapWeight, subArrayCapWeight, p.bridgeCapWeight];
    case 'split-array_type-2'
      mainArrayExponent = [p.mainArraySize - 1 : -1 : 0, 0];
      subArrayExponent = p.subArraySize - 1 : -1 : 0;
      mainArrayCapWeight = 2 .^ mainArrayExponent;
      subArrayCapWeight = 2 .^ subArrayExponent;
      capWeight = [mainArrayCapWeight, subArrayCapWeight, p.bridgeCapWeight];
    case 'split-array_type-3'
      mainArrayExponent = p.mainArraySize - 1 : -1 : 0;
      subArrayExponent = p.subArraySize - 1 : -1 : 0;
      mainArrayCapWeight = 2 .^ mainArrayExponent;
      subArrayCapWeight = 2 .^ subArrayExponent;
      capWeight = [mainArrayCapWeight, subArrayCapWeight, p.bridgeCapWeight];
    otherwise
      warning( 'DAC synthesis failed! Please check the p.dacTopology.' )
  end

  %% choose matching

  switch p.matching
    case 'good'
      caps = p.unitCap * normrnd( capWeight, p.mismatchStd .* sqrt( capWeight ) );
    case 'bad'
      caps = p.unitCap * normrnd( capWeight, p.mismatchStd .* capWeight );
    otherwise
      warning( 'Unkown matching flag! Matching flag must be set.' )
  end

  %% store results

  switch p.dacTopology
    case 'split-array_type-1'
      capArray.main = caps( 1 : p.mainArraySize );
      capArray.sub = caps( p.mainArraySize + 1 : end - 1 );
      capArray.att = caps( end );
    case 'split-array_type-2'
      capArray.main = caps( 1 : p.mainArraySize + 1 );
      capArray.sub = caps( p.mainArraySize + 2 : end - 1 );
      capArray.att = caps( end );
    case 'split-array_type-3'
      capArray.main = caps( 1 : p.mainArraySize );
      capArray.sub = caps( p.mainArraySize + 1 : end - 1 );
      capArray.att = caps( end );
  end

end