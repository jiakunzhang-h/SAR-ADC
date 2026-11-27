function switchingEnergy = calculateSwitchingEnergy( p, capArray, controlVoltage, deltaTopVoltage )

  %% modeling preparation

  positiveCapArray = capArray.positiveCapArray( : );
  negativeCapArray = capArray.negativeCapArray( : );

  lastPositiveControl = controlVoltage.lastBottomVoltage( : , 1 );
  lastNegativeControl = controlVoltage.lastBottomVoltage( : , 2 );
  positiveControl = controlVoltage.bottomVoltage( : , 1 );
  negativeControl = controlVoltage.bottomVoltage( : , 2 );

  %% calculate charge supplied by reference voltage

  deltaPositiveCharge = positiveCapArray .* ( ( positiveControl - lastPositiveControl ) - deltaTopVoltage( 1 ) );
  deltaNegativeCharge = negativeCapArray .* ( ( negativeControl - lastNegativeControl  ) - deltaTopVoltage( 2 ) );

  %% calculate the switching energy

  positiveEnergy = sum( deltaPositiveCharge .* positiveControl );
  negativeEnergy = sum( deltaNegativeCharge .* negativeControl );

  %% calculate and normalize reference energy

  switchingEnergy = ( positiveEnergy + negativeEnergy ) / (p.unitCap * p.vRef ^ 2);

end