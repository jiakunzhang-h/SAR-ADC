function [positiveControl, negativeControl] = differentialInvertedMergedCapacitorSarLogic( p, positiveControl, negativeControl, bitIndex, compOutput )

  %% generate a digital bit from the output of Comparator

  if compOutput == 0
    negativeControl( bitIndex ) = 0;
    positiveControl( bitIndex ) = p.vRef;
  else
    positiveControl( bitIndex ) = 0;
    negativeControl( bitIndex ) = p.vRef;
  end

end