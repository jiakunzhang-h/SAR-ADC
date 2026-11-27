function [conversionResult, cdacTrace, switchingEnergy] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, capArray )

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
    numCap = numel( capArray.positiveCapArray );
    controlSignalList = nan( p.adcResolution + 1, numCap, 2 );
    controlSignalList( 1, :, 1 ) = ones( 1, numCap ) * samplePositive;
    controlSignalList( 1, :, 2 ) = ones( 1, numCap ) * sampleNegative;
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
      controlSignalList( iCycle + 1, :, 1 ) = [ positiveControl, 0 ] * p.vRef;
      controlSignalList( iCycle + 1, :, 2 ) = [ negativeControl, 1 ] * p.vRef;
    end

    %% CDAC

    positiveVin = cbwCdac( samplePositive, p, capArray.positiveCapArray, positiveControl, 0 );
    negativeVin = cbwCdac( sampleNegative, p, capArray.negativeCapArray, negativeControl, 1 );
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
      controlVoltage.lastBottomVoltage = reshape( controlSignalList( iCycle, :, : ), numCap, 2 );
      controlVoltage.bottomVoltage = reshape( controlSignalList( iCycle + 1, :, : ), numCap, 2 );
      switchingEnergy = switchingEnergy + calculateSwitchingEnergy( p, capArray, controlVoltage, deltaTopVoltage );
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