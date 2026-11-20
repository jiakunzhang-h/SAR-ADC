function [positiveControl, negativeControl] = differentialSbwSarLogic( p, positiveControl, negativeControl, bitIndex, compOutput )


  %% determine the control signals for the second bit based on the comparator output

  if compOutput == 0
    positiveControl( bitIndex )  = 1;
    positiveControl( bitIndex + p.adcResolution ) = 1;
    negativeControl = ~ positiveControl;
  else
    positiveControl( bitIndex )  = 0;
    positiveControl( bitIndex + p.adcResolution ) = 0;
    negativeControl = ~ positiveControl;
  end

end