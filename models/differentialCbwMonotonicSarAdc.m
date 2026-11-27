function [conversionResult, cdacTrace, switchingEnergy] = differentialCbwMonotonicSarAdc( samplePositive, sampleNegative, p, capArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );

  if nargout > 1
    cdacTrace = nan( p.adcResolution + 1, 2 );

    %% sampling phase

    cdacTrace( 1, : ) = [ samplePositive, sampleNegative ];

  end
  positiveControl = ones( 1, p.adcResolution );
  negativeControl = ones( 1, p.adcResolution );

  if nargout > 2
    switchingEnergy = 0;
    controlSignalList = nan( p.adcResolution + 1, p.adcResolution, 2 );

    controlSignalList( 1, :, 1 ) = positiveControl * p.vRef;
    controlSignalList( 1, :, 2 ) = negativeControl * p.vRef;
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

  %% sample and hold

  positiveVin = samplePositive;
  negativeVin = sampleNegative;

  %% successive approximation

  for iCycle = 1 : p.adcResolution

    %% save CDAC voltage

    if nargout > 1
      cdacTrace( iCycle + 1, 1 ) = positiveVin;
      cdacTrace( iCycle + 1, 2 ) = negativeVin;
    end
    if nargout > 2
      controlSignalList( iCycle + 1, :, 1 ) = positiveControl * p.vRef;

      controlSignalList( iCycle + 1, :, 2 ) = negativeControl * p.vRef;
    end


    %% comparison and save results

    compOutput = comparator( positiveVin, negativeVin, p );
    digitalWord( iCycle ) = compOutput;

    %% calculate the switching energy

    if nargout > 2
      deltaTopVoltage = cdacTrace( iCycle + 1, : ) - cdacTrace( iCycle, : );
      controlVoltage.lastBottomVoltage = reshape( controlSignalList( iCycle, :, : ), p.adcResolution, 2 );
      controlVoltage.bottomVoltage = reshape( controlSignalList( iCycle + 1, :, : ), p.adcResolution, 2 );
      switchingEnergy = switchingEnergy + calculateSwitchingEnergy( p, capArray, controlVoltage, deltaTopVoltage );
    end

    if iCycle == p.adcResolution
      break;
    end

    %% logic

    [positiveControl, negativeControl] = differentialMonotonicSarLogic( positiveControl, negativeControl, iCycle, compOutput );

    %% CDAC

    positiveVin = differentialCbwMonotonicCdac( samplePositive, p, capArray.positiveCapArray, positiveControl );
    negativeVin = differentialCbwMonotonicCdac( sampleNegative, p, capArray.negativeCapArray, negativeControl );

  end

  %% output

  conversionResult = digitalWord;

end