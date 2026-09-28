function [positiveControl, negativeControl] = differentialSarLogic( positiveControl, negativeControl, bitIndex, compOutput )

  %% generate a digital bit from the output of Comparator

  if compOutput == 1
    negativeControl( bitIndex ) = 1;
  else
    positiveControl( bitIndex ) = 1;
  end

end