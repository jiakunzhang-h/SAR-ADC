function [conversionResult, cdacTrace] = differentialCbwConventionalSarAdc( samplePositive, sampleNegative, p, positiveCapArray, negativeCapArray )

  %% SAR logic initialization

  digitalWord = nan( 1, p.adcResolution );
  if nargout > 1
    cdacTrace = nan( p.adcResolution, 2 );
  end
  positiveControl = zeros( 1, p.adcResolution );
  negativeControl = ones( 1, p.adcResolution );

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

    %% CDAC

    positiveVin = cbwCdac( samplePositive, p, positiveCapArray, positiveControl, 0 );
    negativeVin = cbwCdac( sampleNegative, p, negativeCapArray, negativeControl, 1 );
    if nargout > 1
      cdacTrace( iCycle, 1 ) = positiveVin;
      cdacTrace( iCycle, 2 ) = negativeVin;
    end

    %% Comparator

    compVout = comparator( positiveVin, negativeVin, p );

    %% SAR Logic
    
    digitalWord( iCycle ) = ~ compVout;
    [positiveControl, negativeControl] = differentialConventionalSarLogic( positiveControl, negativeControl, iCycle, compVout );
    
  end

%% output

conversionResult = digitalWord;

end