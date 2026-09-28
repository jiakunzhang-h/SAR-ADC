function [conversionResult, cdacTrace] = differentialBwaSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution + 1 );
  if nargout > 1
    cdacTrace = nan( p.adcResolution, 2 );
  end
  positiveControl = zeros( 1, p.adcResolution );
  negativeControl = zeros( 1, p.adcResolution );

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

  for iCycle = 1 : p.adcResolution + 1

    %% comparison and save results

    compOutput = comparator( positiveVin, negativeVin, p );
    digitalWord( iCycle ) = compOutput;

    if iCycle == p.adcResolution + 1
      break;
    end

    %% logic

    [positiveControl, negativeControl] = differentialSarLogic( positiveControl, negativeControl, iCycle, compOutput );

    %% CDAC

    [positiveVin, positiveCdacVoltage] = bwaTopSampleCdac( samplePositive, p, positiveCapArray, positiveControl );
    [negativeVin, negativeCdacVoltage] = bwaTopSampleCdac( sampleNegative, p, negativeCapArray, negativeControl );

    %% save CDAC voltage

    if nargout > 1
      cdacTrace( iCycle, 1 ) = positiveCdacVoltage;
      cdacTrace( iCycle, 2 ) = negativeCdacVoltage;
    end

  end

  %% output

  conversionResult = digitalWord;

end