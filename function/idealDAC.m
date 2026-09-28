function idealDacOutput = idealDAC( digitalWord )

  %% binary word transforms to decimal code

  idealDacOutput = bit2int(digitalWord.', length(digitalWord));
  
end