close all,
clearvars,
clc,
format long e

%% Global settings
set(groot, 'defaultLineLineWidth', 1.5)
set(groot, 'defaultAxesXGrid', 'on')
set(groot, 'defaultAxesYGrid', 'on')
set(groot, 'defaultFigurePosition', [400 250 900 600])

%% Import data
filename = 'Output/trans_v1.txt';
A = importdata(filename); 
Vgs_v1 = A.data(103:end,1);
Ids_v1 = A.data(103:end,2);

filename = 'Output/trans_v2.txt';
A = importdata(filename); 
Vgs_v2 = A.data(103:end,1);
Ids_v2 = A.data(103:end,2);

filename = 'Output/trans_v3.txt';
A = importdata(filename); 
Vgs_v3 = A.data(103:end,1);
Ids_v3 = A.data(103:end,2);

filename = 'Output/trans_v3_low.txt';
A = importdata(filename); 
Vgs_v3_low = A.data(:,1);
Ids_v3_low = A.data(:,2);

filename = 'Output/trans_rmg.txt';
A = importdata(filename); 
Vgs_rmg = A.data(103:end,1);
Ids_rmg = A.data(103:end,2);

filename = 'Output/trans_rmg_low.txt';
A = importdata(filename); 
Vgs_rmg_low = A.data(:,1);
Ids_rmg_low = A.data(:,2);

filename = 'Output/trans_HfO2.txt';
A = importdata(filename); 
Vgs_HfO2 = A.data(103:end,1);
Ids_HfO2 = A.data(103:end,2);

filename = 'Output/trans_HfO2_low.txt';
A = importdata(filename); 
Vgs_HfO2_low = A.data(:,1);
Ids_HfO2_low = A.data(:,2);

%% Calculations
Vds = 2; % [V]
Vds_low = 0.2; % [V]

Ioff_v1 = Ids_v1(1); % [A/um]
Ion_v1 = Ids_v1(end); % [A/um]
on_off_ratio_v1 = Ion_v1 / Ioff_v1;
Vth_v1 = threshold(Vgs_v1, Ids_v1); % [V]
SS_v1 = subthreshold_slope(Vgs_v1, Ids_v1); % [mV/dec]

Ioff_v2 = Ids_v2(1); % [A/um]
Ion_v2 = Ids_v2(end); % [A/um]
on_off_ratio_v2 = Ion_v2 / Ioff_v2;
Vth_v2 = threshold(Vgs_v2, Ids_v2); % [V]
SS_v2 = subthreshold_slope(Vgs_v2, Ids_v2); % [mV/dec]

Ioff_v3 = Ids_v3(1); % [A/um]
Ion_v3 = Ids_v3(end); % [A/um]
on_off_ratio_v3 = Ion_v3 / Ioff_v3;
Vth_v3 = threshold(Vgs_v3, Ids_v3); % [V]
Vth_v3_low = threshold(Vgs_v3_low, Ids_v3_low); % [V]
SS_v3 = subthreshold_slope(Vgs_v3, Ids_v3); % [mV/dec]
DIBL_v3 = 1000 * ( Vth_v3 - Vth_v3_low ) / ( Vds - Vds_low ); % [mV/V]
gm_v3 = 1000 * gradient(Ids_v3) ./ gradient(Vgs_v3); % [mS/um]

Ioff_rmg = Ids_rmg(1); % [A/um]
Ion_rmg = Ids_rmg(end); % [A/um]
on_off_ratio_rmg = Ion_rmg / Ioff_rmg;
Vth_rmg = threshold(Vgs_rmg, Ids_rmg); % [V]
Vth_rmg_low = threshold(Vgs_rmg_low, Ids_rmg_low); % [V]
SS_rmg = subthreshold_slope(Vgs_rmg, Ids_rmg); % [mV/dec]
DIBL_rmg = 1000 * ( Vth_rmg - Vth_rmg_low ) / ( Vds - Vds_low ); % [mV/V]
gm_rmg = 1000 * gradient(Ids_rmg) ./ gradient(Vgs_rmg); % [mS/um]

Ioff_HfO2 = Ids_HfO2(1); % [A/um]
Ion_HfO2 = Ids_HfO2(end); % [A/um]
on_off_ratio_HfO2 = Ion_HfO2 / Ioff_HfO2;
Vth_HfO2 = threshold(Vgs_HfO2, Ids_HfO2); % [V]
Vth_HfO2_low = threshold(Vgs_HfO2_low, Ids_HfO2_low); % [V]
SS_HfO2 = subthreshold_slope(Vgs_HfO2, Ids_HfO2); % [mV/dec]
DIBL_HfO2 = 1000 * ( Vth_HfO2 - Vth_HfO2_low ) / ( Vds - Vds_low ); % [mV/V]
gm_HfO2 = 1000 * gradient(Ids_HfO2) ./ gradient(Vgs_HfO2); % [mS/um]

%% Results
fprintf('VERSION 1 (NA = 1e18 cm^-3)\n')
fprintf('Vth = %.0f mV\n', Vth_v1*1e3);
fprintf('Ion = %.3f mA/um @ Vds=2V\n', Ion_v1*1e3);
fprintf('Ioff = %.3f uA/um @ Vds=2V\n', Ioff_v1*1e6);
fprintf('Ion/Ioff ratio: %.3f\n', on_off_ratio_v1);
fprintf('SS = %.3f mV/dec\n\n', SS_v1);

fprintf('VERSION 2 (NA = 2.5e18 cm^-3)\n')
fprintf('Vth = %.0f mV\n', Vth_v2*1e3);
fprintf('Ion = %.3f mA/um @ Vds=2V\n', Ion_v2*1e3);
fprintf('Ioff = %10e uA/um @ Vds=2V\n', Ioff_v2*1e6);
fprintf('Ion/Ioff ratio: %10e\n', on_off_ratio_v2);
fprintf('SS = %.3f mV/dec\n\n', SS_v2);

fprintf('VERSION 3, poly gate (NA = 5e18 cm^-3)\n')
fprintf('Vth = %.0f mV @ Vds = 2V, Vth = %.0f mV @ Vds = 0.2V\n', Vth_v3*1e3, Vth_v3_low*1e3);
fprintf('Ion = %.3f mA/um @ Vds=2V\n', Ion_v3*1e3);
fprintf('Ioff = %10e uA/um @ Vds=2V\n', Ioff_v3*1e6);
fprintf('Ion/Ioff ratio: %10e\n', on_off_ratio_v3);
fprintf('SS = %.3f mV/dec\n', SS_v3);
fprintf('DIBL = %.3f mV/V\n\n', DIBL_v3);

fprintf('VERSION 3, RMG with SiO2 (NA = 5e18 cm^-3)\n')
fprintf('Vth = %.0f mV @ Vds = 2V, Vth = %.0f mV @ Vds = 0.2V\n', Vth_rmg*1e3, Vth_rmg_low*1e3);
fprintf('Ion = %.3f mA/um @ Vds=2V\n', Ion_rmg*1e3);
fprintf('Ioff = %10e uA/um @ Vds=2V\n', Ioff_rmg*1e6);
fprintf('Ion/Ioff ratio: %10e\n', on_off_ratio_rmg);
fprintf('SS = %.3f mV/dec\n', SS_rmg);
fprintf('DIBL = %.3f mV/V\n\n', DIBL_rmg);

fprintf('VERSION 3, RMG with HfO2 (NA = 5e18 cm^-3)\n')
fprintf('Vth = %.0f mV @ Vds = 2V, Vth = %.0f mV @ Vds = 0.2V\n', Vth_HfO2*1e3, Vth_HfO2_low*1e3);
fprintf('Ion = %.3f mA/um @ Vds=2V\n', Ion_HfO2*1e3);
fprintf('Ioff = %10e uA/um @ Vds=2V\n', Ioff_HfO2*1e6);
fprintf('Ion/Ioff ratio: %10e\n', on_off_ratio_HfO2);
fprintf('SS = %.3f mV/dec\n', SS_HfO2);
fprintf('DIBL = %.3f mV/V\n', DIBL_HfO2);

%% Plots
figure
semilogy(Vgs_v1, Ids_v1)
hold on
semilogy(Vgs_v2, Ids_v2)
semilogy(Vgs_v3, Ids_v3)
xlabel('V_{gs} [V]')
ylabel('I_{ds} [A/\mum]')
legend('poly gate, N_A=1\times10^{18} cm^{-3}', ...
    'poly gate, N_A=2.5\times10^{18} cm^{-3}', ...
    'poly gate, N_A=5\times10^{18} cm^{-3}', ...
    Location = 'southeast')
xlim([min(Vgs_v3) max(Vgs_v3)])
exportgraphics(gcf, 'Figures/comparison_v123.pdf')

figure
semilogy(Vgs_v3, Ids_v3)
hold on
semilogy(Vgs_v3_low, Ids_v3_low)
xlabel('V_{gs} [V]')
ylabel('I_{ds} [A/\mum]')
legend('poly gate, V_{ds}=2V', 'poly gate, V_{ds}=0.2V', Location = 'southeast')
xlim([min(Vgs_v3) max(Vgs_v3)])
exportgraphics(gcf, 'Figures/trans_poly.pdf')

figure
semilogy(Vgs_HfO2, Ids_HfO2)
hold on
semilogy(Vgs_HfO2_low, Ids_HfO2_low)
xlabel('V_{gs} [V]')
ylabel('I_{ds} [A/\mum]')
legend('RMG + HfO_2, V_{ds}=2V', 'RMG + HfO_2, V_{ds}=0.2V', Location = 'southeast')
xlim([min(Vgs_HfO2) max(Vgs_HfO2)])
exportgraphics(gcf, 'Figures/trans_HfO2.pdf')

figure
semilogy(Vgs_v3, Ids_v3)
hold on
semilogy(Vgs_rmg, Ids_rmg)
semilogy(Vgs_HfO2, Ids_HfO2)
xlabel('V_{gs} [V]')
ylabel('I_{ds} [A/\mum]')
legend('poly gate, V_{ds}=2V', 'RMG + SiO_2, V_{ds}=2V', 'RMG + HfO_2, V_{ds}=2V', ...
    Location = 'southeast')
xlim([min(Vgs_rmg) max(Vgs_rmg)])
exportgraphics(gcf, 'Figures/trans_poly_rmg_comparison.pdf')

figure
plot(Vgs_v3, gm_v3)
hold on
plot(Vgs_rmg, gm_rmg)
semilogy(Vgs_HfO2, gm_HfO2)
xlabel('V_{gs} [V]')
ylabel('g_m [mS/\mum]')
legend('poly gate, V_{ds}=2V', 'RMG + SiO_2, V_{ds}=2V', 'RMG + HfO_2, V_{ds}=2V', ...
    Location = 'southeast')
xlim([min(Vgs_rmg) max(Vgs_rmg)])
exportgraphics(gcf, 'Figures/gm_poly_rmg_comparison.pdf')

%% Function to calculate the threshold voltage
function [Vth] = threshold(Vgs, Ids)
    diff1 = gradient(Ids) ./ gradient(Vgs); % first derivative
    diff2 = gradient(diff1) ./ gradient(Vgs); % second derivative
    [~, pos] = max(diff2); % inflection point
    Vth = Vgs(pos); % threshold voltage
end

%% Function to calculate the subthreshold slope
function [SS] = subthreshold_slope(Vgs, Ids)
    difflog = diff(log10(Ids)) ./ diff(Vgs);
    [peak, ~] = max(difflog);
    SS = 1000 / peak; % [mV/dec]
end