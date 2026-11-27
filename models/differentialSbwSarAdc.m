function [conversionResult, cdacTrace, switchingEnergy] = differentialSbwSarAdc( samplePositive, sampleNegative, p, capArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );

  if nargout > 1
    cdacTrace = nan( p.adcResolution + 1, 2 );

    %% sampling phase

    cdacTrace( 1, : ) = [ p.vcm, p.vcm ];

  end

  positiveControl = zeros( 1, 2 * p.adcResolution );
  negativeControl = ones( 1, 2 * p.adcResolution );

  %% storage the initial control signal

  if nargout > 2
    switchingEnergy = 0;
    controlSignalList = nan( p.adcResolution + 1, 2 * p.adcResolution, 2 );
    controlSignalList( 1, :, 1 ) = ones( 1, 2 * p.adcResolution ) * samplePositive;
    controlSignalList( 1, :, 2 ) = ones( 1, 2 * p.adcResolution ) * sampleNegative;
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

  %% Trial current bit

  positiveControl( 1 : p.adcResolution ) = 1;
  negativeControl( 1 : p.adcResolution ) = 0;

  for iCycle = 1 : p.adcResolution

    %% CDAC

    positiveVin = differentialSbwCdac( samplePositive, p, capArray.positiveCapArray, positiveControl );
    negativeVin = differentialSbwCdac( sampleNegative, p, capArray.negativeCapArray, negativeControl );
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
      controlVoltage.lastBottomVoltage = reshape( controlSignalList( iCycle, :, : ), 2 * p.adcResolution, 2 );
      controlVoltage.bottomVoltage = reshape( controlSignalList( iCycle + 1, :, : ), 2 * p.adcResolution, 2 );
      switchingEnergy = switchingEnergy + calculateSwitchingEnergy( p, capArray, controlVoltage, deltaTopVoltage );
    end

    %% SAR Logic

    digitalWord( iCycle ) = ~ compVout;


    if iCycle == p.adcResolution
      break;
    end

    [positiveControl, negativeControl] = differentialSbwSarLogic( p, positiveControl, negativeControl, iCycle, compVout );

  end

  %% output

  conversionResult = digitalWord;

end