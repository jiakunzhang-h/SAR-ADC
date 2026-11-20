function [positiveControl, negativeControl] = differentialEnergySavingSarLogic( p, positiveControl, negativeControl, bitIndex, compOutput )

  %% generate a digital bit from the output of Comparator

  if bitIndex == 1

    %% determine the control signals for the second bit based on the comparator output
    if compOutput == 0
      positiveControl( 1 ) = 1;
      positiveControl( 2 : p.adcResolution ) = 0;
      positiveControl( p.adcResolution + 1 : end ) = 1;
      negativeControl = ~ positiveControl;
    else
      positiveControl( 1 ) = 0;
      positiveControl( 2 : p.adcResolution ) = 1;
      positiveControl( p.adcResolution + 1 : end ) = 0;
      negativeControl = ~ positiveControl;
    end
  else
    if compOutput == 0
      positiveControl( bitIndex )  = 1;
      positiveControl( bitIndex + p.adcResolution - 1 ) = 1;
      negativeControl = ~ positiveControl;
    else
      positiveControl( bitIndex )  = 0;
      positiveControl( bitIndex + p.adcResolution - 1 ) = 0;
      negativeControl = ~ positiveControl;
    end

  end