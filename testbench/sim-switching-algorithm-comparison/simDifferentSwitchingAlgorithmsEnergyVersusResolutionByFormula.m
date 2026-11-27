%% simulation preparation

clear
close all
clc
format long g

%% load simulation configuration and parameters

p = configDifferentSwitchingAlgorithmsEnergyVersusResolutionTest();

%% determine the number of resolutions

numResolutions = numel( p.adcResolutionArray );

%% allocate storage

convSwEn = zeros( numResolutions, 1 );
splitSwEn = zeros( numResolutions, 1 );
savinSwEn = zeros( numResolutions, 1 );
monoSwEn = zeros( numResolutions, 1 );
mcsSwEn = zeros( numResolutions, 1 );

%% calculate theoretical switching energy

for iResolution = 1 : numResolutions

  iBit = p.adcResolutionArray( iResolution );

  %% initialize switching energy

  splitSwEn( iResolution ) = 2 ^ ( iBit - 1 );
  savinSwEn( iResolution ) = 3 * 2 ^ ( iBit - 3 );

  %% calculate conventional, split and merged switching energy

  for idx = 1 : iBit
    convSwEn( iResolution ) = convSwEn( iResolution ) + 2 ^ ( iBit + 1 - 2 * idx ) * ( 2 ^ idx - 1 );
    splitSwEn( iResolution ) = splitSwEn( iResolution ) + 2 ^ ( iBit + 1 - 2 * idx ) * ( 2 ^ ( idx - 1 ) - 1 );
  end

  %% calculate energy saving switching energy

  for idx = 3 : iBit
    savinSwEn( iResolution ) = savinSwEn( iResolution ) +  2 ^ ( iBit - idx ) - 2 ^ ( iBit + 1 - 2 * idx );
  end

  %% calculate monotonic switching energy

  for idx = 1 : iBit - 1
    monoSwEn( iResolution ) = monoSwEn( iResolution ) + 2 ^ ( iBit - 2 - idx );
    mcsSwEn( iResolution ) = mcsSwEn( iResolution ) + 2 ^ ( iBit - 2 - 2 * idx ) * ( 2 ^ idx - 1 );
  end

end

%% combine switching energy results

averageSwitchingEnergy = [ convSwEn, splitSwEn, savinSwEn, monoSwEn, mcsSwEn, mcsSwEn ];

%% plot simulation results

obj = plotDifferentialAdcSwitchingEnergyVersusResolutionSimulationResult( p, averageSwitchingEnergy, p.adcResolutionArray );
drawing = 'drawing/switching-algorithm-figures/switching-energy-versus-resolution-comparison-by-formula.png';
exportgraphics( obj, drawing );