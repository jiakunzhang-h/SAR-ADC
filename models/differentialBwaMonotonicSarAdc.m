function [conversionResult, cdacTrace] = differentialBwaMonotonicSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );
  if nargout > 1
    cdacTrace = nan( p.adcResolution, 2 );
  end
  positiveControl = zeros( 1, p.adcResolution - 1 );
  negativeControl = zeros( 1, p.adcResolution - 1 );

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
      cdacTrace( iCycle, 1 ) = positiveVin;
      cdacTrace( iCycle, 2 ) = negativeVin;
    end

    %% comparison and save results
    
    compOutput = comparator( positiveVin, negativeVin, p );
    digitalWord( iCycle ) = compOutput;

    if iCycle == p.adcResolution
      break;
    end

    %% logic

    [positiveControl, negativeControl] = differentialMonotonicSarLogic( positiveControl, negativeControl, iCycle, compOutput );

    %% CDAC

    positiveVin = differentialBwaMonotonicCdac( samplePositive, p, positiveCapArray, positiveControl );
    negativeVin = differentialBwaMonotonicCdac( sampleNegative, p, negativeCapArray, negativeControl );


  end

  %% output

  conversionResult = digitalWord;

end