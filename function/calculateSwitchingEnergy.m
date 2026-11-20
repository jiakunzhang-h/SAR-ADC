function switchingEnergy = calculateSwitchingEnergy( p, positiveCapArray, negativeCapArray, controlSignalList, controlSignalListNext, deltaTopVoltage )

  %% modeling preparation

  positiveCapArray = positiveCapArray( : );
  negativeCapArray = negativeCapArray( : );

  oldPositiveControl = controlSignalList( : , 1 );
  oldNegativeControl = controlSignalList( : , 2 );
  newPositiveControl = controlSignalListNext( : , 1 );
  newNegativeControl = controlSignalListNext( : , 2 );

  %% select capacitors connected to Vref after switching

  vrefPositiveIndex = newPositiveControl == p.vRef;
  vrefNegativeIndex = newNegativeControl == p.vRef;

  %% calculate the switching energy

  %% calculate charge supplied by Vref

  deltaQref = sum( positiveCapArray( vrefPositiveIndex ) .* ...
    ( ( newPositiveControl( vrefPositiveIndex ) - oldPositiveControl( vrefPositiveIndex ) ) - deltaTopVoltage( 1 ) ) ) + ...
    sum( negativeCapArray( vrefNegativeIndex ) .* ...
    ( ( newNegativeControl( vrefNegativeIndex ) - oldNegativeControl( vrefNegativeIndex ) ) - deltaTopVoltage( 2 ) ) );

  %% calculate and normalize reference energy

  switchingEnergy = p.vRef * deltaQref / ( p.unitCap * p.vRef ^ 2 );

end
