function [conversionResult, cdacTrace, switchingEnergy] = differentialEnergySavingSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );

  if nargout > 1
    cdacTrace = nan( p.adcResolution + 1, 2 );

    %% sampling phase

    cdacTrace( 1, : ) = [ p.vRef, p.vRef ];
  end

  positiveControl = zeros( 1, 2 * p.adcResolution - 1 );
  negativeControl = zeros( 1, 2 * p.adcResolution - 1 );

  %% storage the initial control signal

  if nargout > 2
    switchingEnergy = 0;
    controlSignalList = nan( p.adcResolution + 1, 2 * p.adcResolution - 1, 2 );
    controlSignalList( 1, :, 1 ) = ones( 1, 2 * p.adcResolution - 1  ) * samplePositive;
    controlSignalList( 1, :, 2 ) = ones( 1, 2 * p.adcResolution - 1  ) * sampleNegative;
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

    %% CDAC

    positiveVin = differentialEnergySavingCdac( samplePositive, p, positiveCapArray, positiveControl );
    negativeVin = differentialEnergySavingCdac( sampleNegative, p, negativeCapArray, negativeControl );
    if nargout > 1
      cdacTrace( iCycle + 1, 1 ) = positiveVin;
      cdacTrace( iCycle + 1, 2 ) = negativeVin;
    end

    if nargout > 2
      controlSignalList( iCycle + 1, :, 1 ) = positiveControl * p.vRef;

      controlSignalList( iCycle + 1, :, 2 ) = negativeControl * p.vRef;
    end
    %% Comparator

    compVout = comparator( positiveVin, negativeVin, p );

    %% calculate the switching energy

    if nargout > 2
      deltaTopVoltage = cdacTrace( iCycle + 1, : ) - cdacTrace( iCycle, : );
      oldBottomVoltage = reshape( controlSignalList( iCycle, :, : ), 2 * p.adcResolution - 1, 2 );
      newBottomVoltage = reshape( controlSignalList( iCycle + 1, :, : ), 2 * p.adcResolution - 1, 2 );
      switchingEnergy = switchingEnergy + calculateSwitchingEnergy( p, positiveCapArray, negativeCapArray, oldBottomVoltage, newBottomVoltage, deltaTopVoltage );
    end

    %% SAR Logic

    digitalWord( iCycle ) = ~ compVout;

    %% end the loop

    if iCycle == p.adcResolution
      break;
    end

    [positiveControl, negativeControl] = differentialEnergySavingSarLogic( p, positiveControl, negativeControl, iCycle, compVout );

  end

  %% output

  conversionResult = digitalWord;

end