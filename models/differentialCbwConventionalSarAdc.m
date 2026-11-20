function [conversionResult, cdacTrace, switchingEnergy] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );

  if nargout > 1
    cdacTrace = nan( p.adcResolution + 1, 2 );

    %% sampling phase

    cdacTrace( 1, : ) = [ p.vcm, p.vcm ];

  end

  positiveControl = zeros( 1, p.adcResolution );
  negativeControl = ones( 1, p.adcResolution );

  %% storage the initial control signal

  if nargout > 2
    switchingEnergy = 0;
    controlSignalList = nan( p.adcResolution + 1, p.adcResolution, 2 );
    controlSignalList( 1, :, 1 ) = ones( 1, p.adcResolution ) * samplePositive;
    controlSignalList( 1, :, 2 ) = ones( 1, p.adcResolution ) * sampleNegative;
  end

  % %% calculate thermal noise
  %
  % capTotal = sum( capArray );
  % thermalNoiseStd = sqrt( p.k * p.temperature / capTotal );
  % thermalNoise = normrnd( 0, thermalNoiseStd );
  %
  % %% inject thermal noise
  %
  % sample = sample + thermalNoise;

  %% successive approximation

  for iCycle = 1 : p.adcResolution

    %% Trial current bit

    positiveControl( iCycle ) = 1;
    negativeControl( iCycle ) = 0;

    %% store the control signal

    if nargout > 2
      controlSignalList( iCycle + 1, :, 1 ) = positiveControl * p.vRef;
      controlSignalList( iCycle + 1, :, 2 ) = negativeControl * p.vRef;
    end

    %% CDAC

    positiveVin = cbwCdac( samplePositive, p, positiveCapArray, positiveControl, 0 );
    negativeVin = cbwCdac( sampleNegative, p, negativeCapArray, negativeControl, 1 );
    if nargout > 1
      cdacTrace( iCycle + 1, 1 ) = positiveVin;
      cdacTrace( iCycle + 1, 2 ) = negativeVin;
    end

    %% Comparator

    compVout = comparator( positiveVin, negativeVin, p );

    %% SAR Logic

    digitalWord( iCycle ) = ~ compVout;

    %% calculate the switching energy
    if nargout > 2
      deltaTopVoltage = cdacTrace( iCycle + 1, : ) - cdacTrace( iCycle, : );
      oldBottomVoltage = reshape( controlSignalList( iCycle, :, : ), p.adcResolution, 2 );
      newBottomVoltage = reshape( controlSignalList( iCycle + 1, :, : ), p.adcResolution, 2 );
      switchingEnergy = switchingEnergy + calculateSwitchingEnergy( p, positiveCapArray, negativeCapArray, oldBottomVoltage, newBottomVoltage, deltaTopVoltage );
    end

    %% end the loop

    if iCycle == p.adcResolution
      break;
    end

    [positiveControl, negativeControl] = differentialConventionalSarLogic( positiveControl, negativeControl, iCycle, compVout );

  end

  %% output

  conversionResult = digitalWord;

end