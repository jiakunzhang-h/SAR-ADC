function vOut = comparator( vP, vN, p )

  %% Comparator

  vNoise = normrnd( 0, p.compNoise ); 
  if vP > vN + p.compVos + vNoise
    vOut = 1;
  else
    vOut = 0;
  end

end
