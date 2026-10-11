% =========================================================================
% Wind Energy Generation Model: Exact Interpolation & Regional Projection
% Evaluating Turbine 1 (50m) & Turbine 2 (100m) across 6 Regions
% =========================================================================
clear; clc; close all;

%% CONFIGURACIÓN GLOBAL PARA FORZAR TEMA BLANCO (ANTI-DARK MODE)
set(groot, 'defaultFigureColor', 'w');
set(groot, 'defaultAxesColor', 'w');
set(groot, 'defaultTextColor', 'k');
set(groot, 'defaultAxesXColor', 'k');
set(groot, 'defaultAxesYColor', 'k');
set(groot, 'defaultAxesGridColor', 'k');
set(groot, 'defaultLegendColor', 'w');
set(groot, 'defaultLegendTextColor', 'k');

%% 1. FOLDER SETUP FOR OVERLEAF
output_dir = 'Resultados_Overleaf_Energia';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% 2. INPUTS: EXACT TIME AND WIND MATRICES
% Exact vector of hours per month (Jan=31d, Feb=28d, Mar=31d, etc.)
horas_mes = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 744];

% Wind speed matrices for the 6 Regions (m/s)
V_mean_All_50 = [
    4.75, 4.63, 4.72, 4.72, 4.46, 6.19, 5.86, 5.51, 4.92, 4.26, 4.34, 4.40;
    5.27, 4.94, 4.76, 4.11, 4.11, 5.24, 4.72, 4.25, 3.73, 3.54, 3.54, 3.54;
    4.17, 4.62, 4.65, 4.45, 4.21, 5.11, 4.78, 4.41, 4.05, 4.00, 3.96, 3.96;
    5.24, 5.47, 5.54, 4.72, 4.24, 4.56, 4.96, 4.77, 4.24, 4.10, 4.53, 4.81;
    5.01, 5.06, 5.25, 4.67, 4.10, 4.62, 5.74, 4.96, 4.53, 4.36, 4.29, 4.39;
    4.76, 5.13, 5.13, 5.37, 4.61, 4.87, 5.00, 4.78, 4.24, 4.21, 4.39, 4.32
];

V_mean_All_100 = [
    5.24, 5.11, 5.21, 5.21, 4.92, 6.83, 6.47, 6.08, 5.43, 4.71, 4.79, 4.86;
    5.82, 5.45, 5.26, 4.54, 4.54, 5.78, 5.21, 4.70, 4.12, 3.91, 3.91, 3.91;
    4.60, 5.10, 5.13, 4.91, 4.65, 5.64, 5.28, 4.87, 4.47, 4.42, 4.38, 4.38;
    5.78, 6.04, 6.11, 5.21, 4.68, 5.04, 5.48, 5.27, 4.68, 4.53, 5.01, 5.31;
    5.53, 5.59, 5.79, 5.16, 4.52, 5.10, 6.34, 5.47, 5.01, 4.81, 4.74, 4.84;
    5.26, 5.67, 5.67, 5.93, 5.09, 5.38, 5.52, 5.28, 4.68, 4.65, 4.84, 4.77
];

%% 3. EXACT POWER CURVE RECONSTRUCTION (INTERPOLATION)
% Turbine 1 (50m) unique nodes
V_50_base = [3.0, 4.26, 4.34, 4.40, 4.46, 4.63, 4.72, 4.75, 4.92, 5.51, 5.86, 6.19];
P_50_base = [0.0, 26.12, 28.65, 30.62, 32.65, 38.73, 42.13, 43.29, 50.13, 77.04, 95.09, 113.35];

% Turbine 2 (100m) unique nodes
V_100_base = [4.0, 4.71, 4.79, 4.86, 4.92, 5.11, 5.21, 5.24, 5.43, 6.08, 6.47, 6.83];
P_100_base = [0.0, 115.45, 130.91, 144.91, 157.25, 198.30, 221.04, 228.00, 273.59, 445.92, 558.70, 667.13];

% Calculate power for all regions
Power_All_50  = interp1(V_50_base, P_50_base, V_mean_All_50, 'pchip', 0);
Power_All_100 = interp1(V_100_base, P_100_base, V_mean_All_100, 'pchip', 0);

% Strict physical constraint below cut-in speed
Power_All_50(V_mean_All_50 < 3) = 0;
Power_All_100(V_mean_All_100 < 4) = 0;

%% 4. MONTHLY AND ANNUAL ENERGY CALCULATION
E_wt_50m  = Power_All_50 .* horas_mes;
E_wt_100m = Power_All_100 .* horas_mes;

Annual_E_wt_50m  = sum(E_wt_50m, 2);  
Annual_E_wt_100m = sum(E_wt_100m, 2);

%% 5. CONSOLE VERIFICATION
disp('===================================================================');
disp('   MONTHLY ENERGY GENERATION (E_wt in kWh) - TURBINE 1 (50m)       ');
disp('===================================================================');
disp(E_wt_50m);

disp('===================================================================');
disp('   MONTHLY ENERGY GENERATION (E_wt in kWh) - TURBINE 2 (100m)      ');
disp('===================================================================');
disp(E_wt_100m);

disp('===================================================================');
disp('   TOTAL ANNUAL ENERGY GENERATION (E_wt in kWh)                    ');
disp('===================================================================');
for r = 1:6
    fprintf('Region %d -> Turbine 1 (50m): %10.2f kWh  |  Turbine 2 (100m): %10.2f kWh\n', ...
        r, Annual_E_wt_50m(r), Annual_E_wt_100m(r));
end
disp('===================================================================');

%% 6. EXPORT TO OVERLEAF (CHART & LATEX TABLE)
regions_labels = {'R1', 'R2', 'R3', 'R4', 'R5', 'R6'};
regions_cat = categorical(regions_labels);

% 6.1 Grouped Bar Chart
fig = figure('Name', 'Annual Energy Production', 'Color', 'w', 'Visible', 'off');
bar_data = [Annual_E_wt_50m, Annual_E_wt_100m];
b = bar(regions_cat, bar_data);

% Styling
b(1).FaceColor = [0 0.4470 0.7410]; % Blue for 50m
b(2).FaceColor = [0.8500 0.3250 0.0980]; % Orange for 100m
title('Annual Electrical Energy Production (E_{wt}) by Region', 'FontSize', 24, 'FontWeight', 'bold');
xlabel('Region', 'FontSize', 20, 'FontWeight', 'bold');
ylabel('Annual Energy Generation (kWh)', 'FontSize', 20, 'FontWeight', 'bold');
legend({'Turbine 1 (50 m)', 'Turbine 2 (100 m)'}, 'Location', 'northwest', 'FontSize', 16);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontSize', 16);

% Save to .eps (Forzando fondo blanco)
eps_filename = fullfile(output_dir, 'energia_anual_generada.eps');
exportgraphics(fig, eps_filename, 'ContentType', 'vector', 'BackgroundColor', 'w');
close(fig);

% 6.2 LaTeX Table Export
tex_filename = fullfile(output_dir, 'tabla_energia.tex');
fid = fopen(tex_filename, 'w');

fprintf(fid, '\\begin{table}[htbp]\n');
fprintf(fid, '\\centering\n');
fprintf(fid, '\\caption{Total Annual Energy Generation ($E_{wt}$) by Region}\n');
fprintf(fid, '\\vspace{0.2cm}\n');
fprintf(fid, '\\begin{tabular}{l c c}\n');
fprintf(fid, '\\hline\n');
fprintf(fid, '\\textbf{Region} & \\textbf{Turbine 1 (50m) [kWh]} & \\textbf{Turbine 2 (100m) [kWh]} \\\\\n');
fprintf(fid, '\\hline\n');
for r = 1:6
    fprintf(fid, '%s & %.2f & %.2f \\\\\n', regions_labels{r}, Annual_E_wt_50m(r), Annual_E_wt_100m(r));
end
fprintf(fid, '\\hline\n');
fprintf(fid, '\\end{tabular}\n');
fprintf(fid, '\\label{tab:annual_energy}\n');
fprintf(fid, '\\end{table}\n');

fclose(fid);

disp('===================================================================');
disp('   OVERLEAF EXPORT COMPLETE');
disp('===================================================================');
disp('Files "energia_anual_generada.eps" and "tabla_energia.tex" saved in "Resultados_Overleaf_Energia".');

% =========================================================================
% Hydrogen Production & Energy Management Algorithm
% Evaluating Turbine 1 (50m) & Turbine 2 (100m) across 6 Regions
% =========================================================================

%% 1. ALGORITHM INPUTS
vector_horas_mes = [744, 672, 744, 720, 744, 720, 744, 744, 720, 744, 720, 744];
P_elec = 39;        % Total fragmented electrolyzer capacity (kW)
C_spec = 50;        % Specific energy consumption (kWh/kgH2)

E_e_row = P_elec .* vector_horas_mes;
E_e = repmat(E_e_row, 6, 1);

%% 2. ENERGY MANAGEMENT LOGIC (Vectorized for 6x12 matrices)
% --- For Turbine 1 (50m) ---
E_elec_50m = zeros(6, 12);
E_EXC_50m  = zeros(6, 12);

mask_50m_high = E_wt_50m >= E_e;
E_elec_50m(mask_50m_high) = E_e(mask_50m_high);
E_EXC_50m(mask_50m_high)  = E_wt_50m(mask_50m_high) - E_e(mask_50m_high);

mask_50m_low = E_wt_50m < E_e;
E_elec_50m(mask_50m_low) = E_wt_50m(mask_50m_low);
E_EXC_50m(mask_50m_low)  = 0;

% --- For Turbine 2 (100m) ---
E_elec_100m = zeros(6, 12);
E_EXC_100m  = zeros(6, 12);

mask_100m_high = E_wt_100m >= E_e;
E_elec_100m(mask_100m_high) = E_e(mask_100m_high);
E_EXC_100m(mask_100m_high)  = E_wt_100m(mask_100m_high) - E_e(mask_100m_high);

mask_100m_low = E_wt_100m < E_e;
E_elec_100m(mask_100m_low) = E_wt_100m(mask_100m_low);
E_EXC_100m(mask_100m_low)  = 0;

%% 3. HYDROGEN MASS CALCULATION & ANNUAL TOTALS
m_H2_50m  = E_elec_50m / C_spec;
m_H2_100m = E_elec_100m / C_spec;

Annual_H2_50m   = sum(m_H2_50m, 2);
Annual_EXC_50m  = sum(E_EXC_50m, 2);

Annual_H2_100m  = sum(m_H2_100m, 2);
Annual_EXC_100m = sum(E_EXC_100m, 2);

%% 4. CONSOLE VERIFICATION
disp('===================================================================');
disp('   ANNUAL RESULTS: HYDROGEN PRODUCTION & SURPLUS ENERGY            ');
disp('===================================================================');
for r = 1:6
    fprintf('Region %d -> Turbine 1 (50m): %8.2f kg H2  |  %10.2f kWh Surplus\n', ...
        r, Annual_H2_50m(r), Annual_EXC_50m(r));
    fprintf('             Turbine 2 (100m): %8.2f kg H2  |  %10.2f kWh Surplus\n', ...
        Annual_H2_100m(r), Annual_EXC_100m(r));
    fprintf('-------------------------------------------------------------------\n');
end

%% 5. EXPORT TO OVERLEAF (CHART & LATEX TABLE)
output_dir = 'Resultados_Overleaf';
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

regions_labels = {'R1', 'R2', 'R3', 'R4', 'R5', 'R6'};
regions_cat = categorical(regions_labels);

% 5.1 Grouped Bar Chart for Hydrogen Production
fig2 = figure('Name', 'Annual Hydrogen Production', 'Color', 'w', 'Visible', 'off');
bar_data_h2 = [Annual_H2_50m, Annual_H2_100m];
b2 = bar(regions_cat, bar_data_h2);

% Professional Styling
b2(1).FaceColor = [0.4660 0.6740 0.1880]; % Green for H2 (50m)
b2(2).FaceColor = [0.3010 0.7450 0.9330]; % Light Blue for H2 (100m)
title('Annual Hydrogen Production by Region', 'FontSize', 24, 'FontWeight', 'bold');
xlabel('Region', 'FontSize', 20, 'FontWeight', 'bold');
ylabel('Annual Hydrogen Mass (kg H_2)', 'FontSize', 20, 'FontWeight', 'bold');
legend({'Turbine 1 (50 m)', 'Turbine 2 (100 m)'}, 'Location', 'northwest', 'FontSize', 16);
grid on;
set(gca, 'GridLineStyle', '--', 'GridAlpha', 0.5, 'FontSize', 16);

% Save to .eps (Forzando fondo blanco)
eps_filename_h2 = fullfile(output_dir, 'produccion_anual_h2.eps');
exportgraphics(fig2, eps_filename_h2, 'ContentType', 'vector', 'BackgroundColor', 'w');
close(fig2);

% 5.2 LaTeX Table Export
tex_filename_h2 = fullfile(output_dir, 'tabla_hidrogeno_excedente.tex');
fid2 = fopen(tex_filename_h2, 'w');

fprintf(fid2, '\\begin{table}[htbp]\n');
fprintf(fid2, '\\centering\n');
fprintf(fid2, '\\caption{Annual Hydrogen Production and Surplus Energy by Region}\n');
fprintf(fid2, '\\vspace{0.2cm}\n');
fprintf(fid2, '\\begin{tabular}{l c c c c}\n');
fprintf(fid2, '\\hline\n');
fprintf(fid2, '\\textbf{Region} & \\textbf{H$_2$ Prod. 50m (kg)} & \\textbf{Surplus 50m (kWh)} & \\textbf{H$_2$ Prod. 100m (kg)} & \\textbf{Surplus 100m (kWh)} \\\\\n');
fprintf(fid2, '\\hline\n');
for r = 1:6
    fprintf(fid2, '%s & %.2f & %.2f & %.2f & %.2f \\\\\n', ...
        regions_labels{r}, Annual_H2_50m(r), Annual_EXC_50m(r), Annual_H2_100m(r), Annual_EXC_100m(r));
end
fprintf(fid2, '\\hline\n');
fprintf(fid2, '\\end{tabular}\n');
fprintf(fid2, '\\label{tab:h2_surplus_results}\n');
fprintf(fid2, '\\end{table}\n');

fclose(fid2);

disp('===================================================================');
disp('   OVERLEAF EXPORT COMPLETE: HYDROGEN & SURPLUS');
disp('===================================================================');
disp('Files "produccion_anual_h2.eps" and "tabla_hidrogeno_excedente.tex" saved in "Resultados_Overleaf".');

%% 6. ANALISIS ECONOMICO (ECONOMIC ASSESSMENT)
% =========================================================================
disp('--- Iniciando Evaluación Económica ---');

% Parámetros Financieros
C_turbina_kW = 1000;        % Costo de turbina en USD/kW
C_elec_kW = 1000;           % Costo de electrolizador en USD/kW
r = 0.08;                   % Tasa de descuento en KSA (8%)
n = 25;                     % Vida útil del proyecto (años)
O_M_rate = 0.015;           % Tasa de O&M anual (1.5% del CAPEX)
C_grid = 0.03;              % Precio de venta de electricidad a la red (USD/kWh)
Consumo_H2 = 50;            % kWh requeridos para producir 1 kg de H2

% 6.1 Costos de Capital (CAPEX)
CAPEX_wt_50 = 600 * C_turbina_kW;      % Turbina 1 (600 kW)
CAPEX_wt_100 = 2300 * C_turbina_kW;    % Turbina 2 (2300 kW)
CAPEX_elec = 39 * C_elec_kW;           % Electrolizador (39 kW)

% 6.2 Factor de Recuperación de Capital (CRF)
CRF = (r * (1 + r)^n) / ((1 + r)^n - 1);

% 6.3 Costo Nivelado de la Electricidad (C_elc) en USD/kWh
C_elc_50m  = (CAPEX_wt_50 * CRF + CAPEX_wt_50 * O_M_rate) ./ Annual_E_wt_50m;
C_elc_100m = (CAPEX_wt_100 * CRF + CAPEX_wt_100 * O_M_rate) ./ Annual_E_wt_100m;

% 6.4 Costo Nivelado del Hidrógeno (C_H2) en USD/kg
E_elec_50m = Annual_H2_50m .* Consumo_H2;
E_elec_100m = Annual_H2_100m .* Consumo_H2;

Costo_Energia_H2_50m = E_elec_50m .* C_elc_50m;
Costo_Energia_H2_100m = E_elec_100m .* C_elc_100m;

Ingresos_Excedentes_50m = Annual_EXC_50m .* C_grid;
Ingresos_Excedentes_100m = Annual_EXC_100m .* C_grid;

C_H2_50m = (CAPEX_elec * CRF + CAPEX_elec * O_M_rate + Costo_Energia_H2_50m - Ingresos_Excedentes_50m) ./ Annual_H2_50m;
C_H2_100m = (CAPEX_elec * CRF + CAPEX_elec * O_M_rate + Costo_Energia_H2_100m - Ingresos_Excedentes_100m) ./ Annual_H2_100m;

disp('Cálculos económicos finalizados con éxito.');

%% 7. EXPORTACIÓN DE GRÁFICAS Y TABLAS ECONÓMICAS
% =========================================================================

% 7.1 Gráfica Comparativa de Costos de Hidrógeno (C_H2)
fig3 = figure('Name', 'Costo Nivelado del Hidrogeno', 'Position', [100, 100, 700, 500], 'Visible', 'off');
bar_data_cost = [C_H2_50m, C_H2_100m]; 
b_cost = bar(regions_cat, bar_data_cost, 'grouped');
b_cost(1).FaceColor = [0.2 0.6 0.5]; % Verde KFUPM claro
b_cost(2).FaceColor = [0.0 0.4 0.3]; % Verde KFUPM oscuro

ylabel('Hydrogen Production Cost (USD/kg)', 'FontSize', 20, 'FontWeight', 'bold');
title('Levelized Cost of Hydrogen (C_{H2}) by Region', 'FontSize', 24);
legend('Turbine 1 (50m)', 'Turbine 2 (100m)', 'Location', 'northeast', 'FontSize', 16);
grid on;
set(gca, 'GridAlpha', 0.5, 'FontSize', 16);

% Guardar la gráfica en .eps (Forzando fondo blanco)
eps_filename_cost = fullfile(output_dir, 'costo_hidrogeno.eps');
exportgraphics(fig3, eps_filename_cost, 'ContentType', 'vector', 'BackgroundColor', 'w');
close(fig3);

% 7.2 Exportar Tabla en LaTeX con C_elc y C_H2
tex_filename_eco = fullfile(output_dir, 'tabla_resultados_economicos.tex');
fid3 = fopen(tex_filename_eco, 'w');

fprintf(fid3, '\\begin{table}[htbp]\n');
fprintf(fid3, '\\centering\n');
fprintf(fid3, '\\caption{Economic Results: Levelized Cost of Electricity ($C_{elc}$) and Hydrogen ($C_{H_2}$)}\n');
fprintf(fid3, '\\label{tab:economic_results}\n');
fprintf(fid3, '\\vspace{0.2cm}\n');
fprintf(fid3, '\\renewcommand{\\arraystretch}{1.2}\n');
fprintf(fid3, '\\begin{tabular}{l c c c c}\n');
fprintf(fid3, '\\hline \\hline\n');
fprintf(fid3, '\\textbf{Region} & \\textbf{$C_{elc}$ 50m (\\$/kWh)} & \\textbf{$C_{H_2}$ 50m (\\$/kg)} & \\textbf{$C_{elc}$ 100m (\\$/kWh)} & \\textbf{$C_{H_2}$ 100m (\\$/kg)} \\\\\n');
fprintf(fid3, '\\hline\n');
for r = 1:6
    fprintf(fid3, '%s & %.3f & %.3f & %.3f & %.3f \\\\\n', ...
        regions_labels{r}, C_elc_50m(r), C_H2_50m(r), C_elc_100m(r), C_H2_100m(r));
end
fprintf(fid3, '\\hline \\hline\n');
fprintf(fid3, '\\end{tabular}\n');
fprintf(fid3, '\\end{table}\n');
fclose(fid3);

disp(['Archivos económicos exportados en la carpeta: ', output_dir]);

%% 8. GRÁFICAS ADICIONALES (EXCESO DE ENERGÍA Y GANANCIAS)
% =========================================================================

% 8.1 Gráfica de Energía Excedente (E_EX)
fig4 = figure('Name', 'Energia Excedente (E_EX)', 'Position', [150, 150, 700, 500], 'Visible', 'off');
bar_data_EX = [Annual_EXC_50m, Annual_EXC_100m]; 
b_EX = bar(regions_cat, bar_data_EX, 'grouped');
b_EX(1).FaceColor = [0.85 0.33 0.10]; % Naranja
b_EX(2).FaceColor = [0.93 0.69 0.13]; % Amarillo oscuro

ylabel('Excess Energy E_{EX} (kWh)', 'FontSize', 20, 'FontWeight', 'bold');
title('Annual Excess Energy Exported to Grid (E_{EX})', 'FontSize', 24);
legend('Turbine 1 (50m)', 'Turbine 2 (100m)', 'Location', 'northwest', 'FontSize', 16);
grid on;
set(gca, 'GridAlpha', 0.5, 'FontSize', 16);

% Guardar la gráfica (Forzando fondo blanco)
eps_filename_EX = fullfile(output_dir, 'grafica_E_EX.eps');
exportgraphics(fig4, eps_filename_EX, 'ContentType', 'vector', 'BackgroundColor', 'w');
close(fig4);

% 8.2 Gráfica de Ganancias por Excedentes (PR_EXP)
fig5 = figure('Name', 'Ganancias por Excedentes (PR_EXP)', 'Position', [200, 200, 700, 500], 'Visible', 'off');
bar_data_PREXP = [Ingresos_Excedentes_50m, Ingresos_Excedentes_100m]; 
b_PREXP = bar(regions_cat, bar_data_PREXP, 'grouped');
b_PREXP(1).FaceColor = [0.49 0.18 0.56]; % Morado
b_PREXP(2).FaceColor = [0.64 0.08 0.18]; % Rojo oscuro

ylabel('Profit from Exported Energy PR_{EXP} (USD/year)', 'FontSize', 20, 'FontWeight', 'bold');
title('Annual Profit from Exported Energy (PR_{EXP})', 'FontSize', 24);
legend('Turbine 1 (50m)', 'Turbine 2 (100m)', 'Location', 'northwest', 'FontSize', 16);
grid on;
set(gca, 'GridAlpha', 0.5, 'FontSize', 16);

% Guardar la gráfica (Forzando fondo blanco)
eps_filename_PREXP = fullfile(output_dir, 'grafica_PR_EXP.eps');
exportgraphics(fig5, eps_filename_PREXP, 'ContentType', 'vector', 'BackgroundColor', 'w');
close(fig5);

disp('Gráficas adicionales (E_EX y PR_EXP) exportadas con éxito.');