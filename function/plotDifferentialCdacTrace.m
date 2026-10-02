function traceObj = plotDifferentialCdacTrace( p, randomTrace )

  %% determine comparator input trace

  positiveTrace = randomTrace( :, 1 );
  negativeTrace = randomTrace( :, 2 );

  %% generate conversion phase axis

  numPhase = length( positiveTrace );

  phaseAxis = 0 : numPhase;

  positivePlot = [positiveTrace; positiveTrace( end )];
  negativePlot = [negativeTrace; negativeTrace( end )];

  %% plot

  traceObj = figure;

  stairs( phaseAxis, positivePlot, 'b', 'LineWidth', 2.5 );

  hold on;

  stairs( phaseAxis, negativePlot, 'r--', 'LineWidth', 2.5 );

  %% common-mode reference

  yline( p.vcm, '--', 'V_{CM}', 'LineWidth', 2 );

  %% phase boundaries

  for iPhase = 1 : numPhase - 1
    xline( iPhase, ':', 'HandleVisibility', 'off' );
  end

  %% phase labels

  phaseLabel = strings( 1, numPhase );
  phaseLabel( 1 ) = "Sample";

  for iPhase = 2 : numPhase
    phaseLabel( iPhase ) = "Phase " + string( iPhase - 1 );
  end

  xticks( 0.5 : 1 : numPhase - 0.5 );
  xticklabels( phaseLabel );
  xtickangle( 0 );

  %% y-axis range

  allVoltage = [positiveTrace; negativeTrace; p.vcm];

  voltageMin = min( allVoltage );
  voltageMax = max( allVoltage );

  voltageMargin = 0.1 * ( voltageMax - voltageMin );

  ylim( [ voltageMin - voltageMargin, voltageMax + voltageMargin ] );

  %% plot settings

  xlabel( 'Conversion Phase' );
  ylabel( 'Cdac Trace Voltage (V)' );
  legend( 'V_P', 'V_N', 'V_{CM}', 'Location', 'best' );
  title( 'Monotonic Differential SAR ADC Conversion' );
  grid on;

end