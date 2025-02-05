close all,
clearvars,
clc,
format long e

%% Global settings
set(groot, 'defaultLineLineWidth', 1.5)
set(groot, 'defaultAxesXGrid', 'on')
set(groot, 'defaultAxesYGrid', 'on')
set(groot, 'defaultFigurePosition', [400 250 900 600])

%% Reference geometrical parameters
Lch_init = 46; % channel length [nm]
Tsi_init = 12; % Si overlay thickness [nm]
Tbox_init = 50; % BOX thickness [nm]
Tox_init = 1; % GOX thickness [nm]
xsi_init = 400; % [nm]
ysi_init = 200; % [nm]
xspacer_init = 50; % [nm]
yspacer_init = 15; % [nm]
xcontact_init = 7; % [nm]
ycontact_init = Lch_init; % [nm]

%% Scaling of the geometrical parameters 
Lch = 60; % [nm]
k = Lch_init / Lch; % scaling factor
Tsi = Tsi_init / k;
Tbox = Tbox_init / k;
Tox = Tox_init / k;

xsi = 200; % for simulation purposes
ysi = ysi_init / k;
xspacer = xspacer_init / k;
yspacer = yspacer_init / k;
xcontact = xcontact_init / k;
ycontact = ycontact_init / k;

fprintf('Channel length Lg = %.0f nm, scaling factor k = %.0f\n', Lch, k);
fprintf('Silicon overlay thickness: Tsi = %.0f nm\n', Tsi);
fprintf('BOX thickness: Tbox = %.0f nm\n', Tbox);
fprintf('GOX thickness: Tox = %.0f nm\n', Tox);
fprintf('Silicon substrate dimensions: xsi x ysi = (%.0f nm) x (%.0f nm)\n', xsi, ysi);
fprintf('Spacers dimensions: xspacer x yspacer = (%.0f nm) x (%.0f nm)\n', xspacer, yspacer);
fprintf('Contact dimensions: xcontact x ycontact = (%.0f nm) x (%.0f nm)\n', xcontact, ycontact);

%% Calculation of the expected threshold voltage
tox = Tox * 1e-7; % oxide thickness [cm]
Na = 5e18; % doping Si overlay [cm^-3]
tox_range = linspace(0.5e-7, 3e-7, 1e4);
Na_range = linspace(1e14, 1e19, 1e4);

nint = 1.45e10; % intrinsic concentration Si [cm^-3]
Affinity = 4.05; % [eV]
Eg = 1.12; % [eV]
kB = 1.380649e-23; % Boltzmann constant [J/K]
qel = 1.602176634e-19; % Elementary charge [C]
c = physconst('LightSpeed') * 1e2; % light velocity [cm/s]
mu0 = 4 * pi * 1e-9; % magnetic permeability of vacuum [H/cm]
eps0 = 1 / (mu0*c^2); % electric permittivity of vacuum [F/cm]
epsR_Si = 11.7; % Si relative permittivity
epsR_SiO2 = 3.9; % SiO2 relative permittivity
epsSi = eps0 * epsR_Si; % Si permittivity [F/cm]
epsSiO2 = eps0 * epsR_SiO2; % SiO2 permittivity [F/cm]
T = 300; % absolute temperature [K]
Vt = kB * T / qel; % thermal voltage [V]

Cox = @(tox) epsSiO2 ./ tox; % oxide capacitance
q_PhiM = Affinity; % workfunction of the poly gate
q_PhiP = @(Na) Vt .* log( Na ./ nint ); % EFi - EF
q_PhiSP = @(Na) Affinity + ( Eg / 2 ) + q_PhiP(Na); % workfunction of the Si overlay
VFB = @(Na) q_PhiM - q_PhiSP(Na); % flat-band voltage
gammaB = @(Na, tox) sqrt( 2 .* qel .* epsSi .* Na ) ./ Cox(tox); % body-effect coeff
threshold = @(Na, tox) VFB(Na) + 2 .* q_PhiP(Na) + gammaB(Na, tox) .* sqrt( 2 * q_PhiP(Na) ); % threshold voltage

Vth_expected = threshold(Na, tox);
fprintf('Expected threshold: Vth=%.0f mV\n', Vth_expected*1e3);

figure % threshold vs Na with fixed oxide thickness
plot(Na_range, threshold(Na_range, tox))
xlabel('N_A [cm^{-3}]')
ylabel('V_{th} [V]')
exportgraphics(gcf, 'Figures/threshold_vs_Na.pdf')

figure % threshold vs tox with fixed doping level
plot(tox_range*1e7, threshold(Na, tox_range))
xlabel('t_{ox} [nm]')
ylabel('V_{th} [V]')
exportgraphics(gcf, 'Figures/threshold_vs_tox.pdf')