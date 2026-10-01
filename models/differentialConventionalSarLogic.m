function [positiveControl, negativeControl] = differentialConventionalSarLogic( positiveControl, negativeControl, bitIndex, compOutput )

  %% generate a digital bit from the output of Comparator

  if compOutput == 0
    positiveControl( bitIndex ) = 1;
    negativeControl( bitIndex ) = 0;
  else
    positiveControl( bitIndex ) = 0;
    negativeControl( bitIndex ) = 1;
  end

end