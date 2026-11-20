
function traceObj = plotDifferentialCdacTrace( p, randomTrace, switchingMode )

  %% determine comparator input trace

  positiveTrace = randomTrace( :, 1 );
  negativeTrace = randomTrace( :, 2 );

  commonModeTrace = ( positiveTrace + negativeTrace ) / 2;

  %% generate conversion phase axis

  numPhase = size( randomTrace, 1 );

  phaseAxis = 0 : numPhase;

  positivePlot = [ positiveTrace; positiveTrace( end ) ];
  negativePlot = [ negativeTrace; negativeTrace( end ) ];
  commonModePlot = [ commonModeTrace; commonModeTrace( end ) ];

  %% plot

  traceObj = figure( 'Color', 'w' );

  hPositive = stairs( phaseAxis, positivePlot, 'b', 'LineWidth', 2.5 );

  hold on;

  hNegative = stairs( phaseAxis, negativePlot, 'r', 'LineWidth', 2.5 );

  hCommonMode = stairs( phaseAxis, commonModePlot, 'k-.', 'LineWidth', 1.2 );

  %% phase boundaries

  for iPhase = 1 : numPhase - 1
    xline( iPhase, ':', 'HandleVisibility', 'off' );
  end

  %% phase labels

  phaseLabel = strings( 1, numPhase );
  phaseLabel( 1 ) = "Sample";

  for iPhase = 2 : numPhase
    phaseLabel( iPhase ) = "Bit " + string( iPhase - 1 );
  end

  xlim( [ 0, numPhase ] );
  xticks( 0.5 : 1 : numPhase - 0.5 );
  xticklabels( phaseLabel );
  xtickangle( 0 );

  %% y-axis range

  allVoltage = [ positiveTrace; negativeTrace; p.vcm ];

  voltageMin = min( allVoltage );
  voltageMax = max( allVoltage );

  voltageMargin = max( ...
    0.1 * ( voltageMax - voltageMin ), 0.02 );

  ylim( [ voltageMin - voltageMargin, ...
    voltageMax + voltageMargin ] );

  %% plot settings

  xlabel( 'Conversion Phase' );
  ylabel( 'CDAC Top-Plate Voltage (V)' );

  legend( [ hPositive, hNegative, hCommonMode ], ...
    { 'V_P', 'V_N', 'V_{CM}' }, ...
    'Location', 'best' );

  %% choose the title

  switch lower( string( switchingMode ) )
    case "conventional"
      title( 'Conventional Switching Algorithm SAR ADC Conversion' );
    case "monotonic"
      title( 'Monotonic Switching Algorithm SAR ADC Conversion' );
    case "split-capacitor"
      title( 'Split-Capacitor Switching Algorithm SAR ADC Conversion' );
    case "energy-saving"
      title( 'Energy Saving Switching Algorithm SAR ADC Conversion' );
    case "merged-capacitor"
      title( 'Merged-Capacitor Switching Algorithm SAR ADC Conversion' );
    case "inverted-merged-capacitor"
      title( 'Inverted Merged-Capacitor Switching Algorithm SAR ADC Conversion' );
    otherwise
      error( 'Invalid switching mode: %s', char( switchingMode ) );
  end

  grid on;

end
