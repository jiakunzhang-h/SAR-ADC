function [positiveControl, negativeControl] = differentialMonotonicSarLogic( positiveControl, negativeControl, bitIndex, compOutput )

  %% generate a digital bit from the output of Comparator

  if compOutput == 0
    negativeControl( bitIndex ) = 0;
  else
    positiveControl( bitIndex ) = 0;
  end

end