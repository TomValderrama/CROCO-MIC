% === Configuración ===
close all; clear; clc
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

file = 'ancud_bench_inv.nc';

varU = 'u';
varV = 'v';
varT = 'time';

% === Leer datos ===
time = ncread(file,varT);    % típicamente en días o segundos, según config
u = ncread(file,varU);       % [xi_u, eta_u, s_rho, time] = [55 38 42 721]
v = ncread(file,varV);       % [xi_v, eta_v, s_rho, time] = [56 37 42 721]

nt = length(time);
KE = zeros(nt,1);

% === Calcular energía cinética media del dominio ===
for t = 1:nt
    u_t = squeeze(double(u(:,:,:,t)));
    v_t = squeeze(double(v(:,:,:,t)));

    % Interpolar a la grilla rho
    u_rho = 0.5 * (u_t(1:end-1,:,:,:) + u_t(2:end,:,:,:));  % [54 38 42]
    v_rho = 0.5 * (v_t(:,1:end-1,:,:) + v_t(:,2:end,:,:,:));% [56 36 42]

    % Recortar para coincidir en extensión
    u_rho = u_rho(1:54,1:36,:);
    v_rho = v_rho(1:54,1:36,:);

    % Energía cinética instantánea
    ke_inst = 0.5 * (u_rho.^2 + v_rho.^2);

    KE(t) = mean(ke_inst(:), 'omitnan');
end

% === Crear vector de tiempo real ===
duracion_horas = nt; % 721 pasos → 721 horas
fecha_inicio = datetime('2021-01-01 00:00:00','Format','yyyy-MM-dd HH:mm:ss');
vector_tiempo = fecha_inicio + hours(0:duracion_horas-1);

% === INPUTS asumidos ya en workspace ===
% KE (nt x 1)   : serie horaria de energía cinética (o la métrica que uses)
% vector_tiempo : datetime vector (nt x 1)
% nt             = length(KE)

% --- Parámetros (ajustables) ---
dt_hours = hours(vector_tiempo(2) - vector_tiempo(1)); % paso en horas (debería ser 1)
Fs = 1 / dt_hours; % muestreo en ciclos/hora

cutoff_hours = 72;      % filtro low-pass: elimina variabilidad < ~cutoff_hours
butter_order = 4;
umbral_rel = 0.01;      % 1% umbral relativo para cambio en envolvente
ventana_dias = 3;       % consideramos estabilidad si cumple por ventana_dias
ventana_pts = ventana_dias * round(24/dt_hours); % en puntos

% --- Pre-procesado: eliminar NaNs y baseline ---
KE = KE(:);
valid = ~isnan(KE);
if sum(valid) < length(KE)
    % interpola pequeños huecos (si existen)
    KE = fillmissing(KE,'linear');
end

% --- Filtro low-pass (Butterworth, cero-fase) ---
fc = 1 / cutoff_hours;         % cutoff en ciclos/hora
Wn = fc / (Fs/2);              % normalizado
if Wn <= 0 || Wn >= 1
    error('Wn fuera de rango: revisa dt_hours y cutoff_hours');
end
[b,a] = butter(butter_order, Wn, 'low');
KE_filt = filtfilt(b,a,KE);    % mantiene fase

% --- Envolvente (amplitud) usando Hilbert ---
KE_detrend = KE_filt - mean(KE_filt); % eliminar offset para la env
KE_env = abs(hilbert(KE_detrend));

% --- Derivada relativa de la envolvente y suavizado ---
dEnv = abs(diff(KE_env)) ./ (KE_env(2:end) + eps); % cambio relativo
dEnv_smooth = movmean(dEnv, round(24/dt_hours));  % suavizado diario

% --- Criterio de fin de spin-up: ventana sostenida bajo umbral ---
% tomamos media móvil de la derivada suavizada sobre ventana_pts
d_running = movmean(dEnv_smooth, ventana_pts);

idx = find(d_running < umbral_rel, 1, 'first');
if ~isempty(idx)
    idx_spin_end_env = idx + 1; % compensar diff -> shift de 1
    fecha_spin_end_env = vector_tiempo(idx_spin_end_env);
    detected_env = true;
else
    detected_env = false;
end

% --- Método alternativo: ajuste exponencial (tau) ---
% Sólo usar en la parte inicial (evitar ajustar sobre oscilaciones)
x = (1:nt)';
try
    f_exp = fittype('a + b*exp(-x/c)', 'independent','x','coefficients',{'a','b','c'});
    opts = fitoptions(f_exp);
    opts.StartPoint = [min(KE_filt), max(KE_filt)-min(KE_filt), 50];
    fit_res = fit(x, KE_filt, f_exp, opts);
    tau = fit_res.c; % en unidades de puntos (horas si dt=1h)
    % tomar 3*tau como aproximación a estar en ~95%
    spin_hours_exp = 3 * tau * dt_hours;
    idx_spin_end_exp = min(nt, round(3 * tau)); % índice aproximado
    fecha_spin_end_exp = vector_tiempo(idx_spin_end_exp);
    detected_exp = true;
catch
    detected_exp = false;
end



%%
close all
% --- Mostrar resultados y graficar ---
figure('Units','normalized','Position',[0.1 0.1 0.7 0.6]);
subplot(2,1,1)
plot(vector_tiempo, KE, 'Color',[0.8 0.8 0.8]); hold on
plot(vector_tiempo, KE_filt, 'k-', 'LineWidth', 1.6);
plot(vector_tiempo, KE_env, 'r--', 'LineWidth', 1.2);
ylabel('KE');
% title('KE original (gris), KE filt (negra) y envolvente (roja)');
% grid on
axis tight
legend('KE raw','KE lowpass','Envolvente','Location','best');

if detected_env
    xline(fecha_spin_end_env, '--b', 'LineWidth',2, 'Label','Spin-end (env)','LabelOrientation','horizontal');
    txt = sprintf('Spin-end env: %s', datestr(fecha_spin_end_env));
    disp(txt);
else
    disp('No se detectó fin de spin-up con el criterio de envolvente. Considera bajar el umbral o aumentar cutoff.');
end

if detected_exp
    xline(fecha_spin_end_exp, '--g', 'LineWidth',2, 'Label','Spin-end (exp)','LabelOrientation','horizontal');
    txt2 = sprintf('Spin-end exp (3*tau): %s  (tau=%.1f h)', datestr(fecha_spin_end_exp), tau*dt_hours);
    disp(txt2);
end

% Quitar etiquetas y marcas del eje X en el subplot superior
set(gca, 'XTickLabel', [], 'XTick', []);
xlabel(''); % elimina cualquier etiqueta de eje x

% ===== Subplot 2: cambios relativos =====
subplot(2,1,2)
plot(vector_tiempo(2:end), dEnv_smooth, 'k-'); hold on
plot(vector_tiempo(2:end), d_running, 'b-','LineWidth',1.2);
yline(umbral_rel, '--r', 'Umbral');
xlabel('Date (dd/mm)', 'Interpreter', 'none','FontSize',20);
set(gca, 'FontSize', 20, 'FontWeight', 'bold');
% title('Cambios relativos de la envolvente (suavizados) y corrida');
axis tight

% Cambiar el tamaño de fuente de las marcas del eje x
set(gca, 'FontSize', 20, 'FontWeight', 'bold'); % Ajusta el tamaño de la fuente según tus necesidades


% Finalmente, agregar la etiqueta al eje x
xlabel('Date (mm/dd)', 'Interpreter', 'none','FontSize',20);

% title('Cambios relativos de la envolvente (suavizados) y corrida');
% grid on

% Mensaje final con prioridad al método de envolvente
if detected_env
    fprintf('\n=> Recomendado: fin de spin-up aproximadamente: %s (criterio envolvente).\n', datestr(fecha_spin_end_env));
elseif detected_exp
    fprintf('\n=> Método exp: fin de spin-up aproximado: %s (3*tau).\n', datestr(fecha_spin_end_exp));
else
    fprintf('\n=> No se detectó fin con los criterios actuales. Revisa cutoff_hours, umbral_rel o inspecciona la envolvente manualmente.\n');
end



%%

% close all
% --- Plot results ---
figure('Units','normalized','Position',[ -1.3302    0.1324    1.3057    0.8648]);

% Convert time vector to elapsed days since start
time_days = hours(vector_tiempo - vector_tiempo(1)) / 24;

% ===== Subplot 1: Kinetic Energy =====
% subplot(2,1,1)
ax1 = subplot(2,1,1);
set(ax1, 'Position', [0.08 0.55 0.88 0.40]);  % [left bottom width height]
plot(time_days, KE, 'Color',[0.8 0.8 0.8]); hold on
plot(time_days, KE_filt, 'k-', 'LineWidth', 2);
plot(time_days, KE_env, 'r--', 'LineWidth', 2);
ylabel('Kinetic Energy (KE)', 'FontSize',20);
axis tight
set(gca, 'FontSize', 30, 'FontWeight', 'bold');
legend('KE (raw)','KE (low-pass)','Envelope','Location','best', 'fontsize', 20);

if detected_env
    vThr = xline(hours(fecha_spin_end_env - vector_tiempo(1))/24, '--b', 'LineWidth',2.5, ...
        'Label','Spin-up end (env)', 'LabelOrientation','horizontal');
    vThr.FontSize = 16;
    vThr.LabelVerticalAlignment = 'bottom';
    vThr.FontWeight = 'bold';
    txt = sprintf('Spin-up end (envelope): %s', datestr(fecha_spin_end_env));
    disp(txt);
else
    disp('No spin-up end detected with envelope criterion. Consider lowering threshold or increasing cutoff.');
end

if detected_exp
    vThr2 = xline(hours(fecha_spin_end_exp - vector_tiempo(1))/24, '--g', 'LineWidth',2.5, ...
        'Label',sprintf('Spin-up end\n(exp)'), 'LabelOrientation','horizontal');
    vThr2.FontSize = 16;
    vThr2.FontWeight = 'bold';
    txt2 = sprintf('Spin-up end (exp, 3*tau): %s  (tau = %.1f h)', ...
        datestr(fecha_spin_end_exp), tau*dt_hours);
    disp(txt2);
end

% Remove x-axis labels and ticks from top subplot
set(gca, 'XTickLabel', [], 'XTick', []);
xlabel('');

% ===== Subplot 2: Relative changes =====
% subplot(2,1,2)
ax2 = subplot(2,1,2);
set(ax2, 'Position',[0.08 0.08 0.88 0.40]);  % [left bottom width height]
plot(time_days(2:end), dEnv_smooth, 'k-','LineWidth',2); hold on
plot(time_days(2:end), d_running, 'b-', 'LineWidth',2);
hThr = yline(umbral_rel, '--r', 'Threshold','LineWidth',2);
hThr.FontSize = 16;
hThr.FontWeight = 'bold';
xlabel('Elapsed time (days)', 'FontSize',20);
ylabel('Relative change');
% set(gca, 'FontSize', 30, 'FontWeight', 'bold');
% axis tight
set(ax2, 'Position',[0.08 0.12 0.88 0.36]);  % aumenta el 'bottom' (de 0.08 a 0.12)
set(gca, 'XTickLabel', get(gca, 'XTickLabel'), 'FontSize', 30, 'FontWeight', 'bold')


% Print final message prioritizing envelope method
if detected_env
    fprintf('\n=> Recommended spin-up end: %.1f days since start (envelope criterion).\n', ...
        hours(fecha_spin_end_env - vector_tiempo(1))/24);
elseif detected_exp
    fprintf('\n=> Exponential method: spin-up end ≈ %.1f days since start (3*tau).\n', ...
        hours(fecha_spin_end_exp - vector_tiempo(1))/24);
else
    fprintf('\n=> No spin-up end detected with current criteria. Review cutoff_hours, umbral_rel, or inspect envelope manually.\n');
end
