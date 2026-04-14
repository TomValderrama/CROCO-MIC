% %% Settings
% close all; clear all; clc
% % addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
% % addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
% % start
% 
% addpath('F:\AAMagister\Ancud\20210102\');
% addpath('F:\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
% addpath('F:\AAMagister\PRODIGY\Week 1\m_map')
% start
% hisfile = 'ancud_bench_ver.nc';
% tstep = 541;        % el timestep que quieres mostrar (ejemplo: 541)
% % variables de CROCO/ROMS típicas: 'ubar','vbar' (barotropic velocities)
% % 'lon','lat' deben leerse del fichero (en puntos rho)
% 
% %% Read lon/lat (rho points) and barotropic velocities
% lon = ncread(hisfile,'lon_rho');   % o el nombre que tenga tu archivo
% lat = ncread(hisfile,'lat_rho');
% 
% % ubar/vbar suelen estar en archivos his o avg; asegúrate del nombre y tiempo
% ubar = ncread(hisfile,'ubar');     % dimensiones: (xi_u, eta_u, time) OR (nx_u, ny_u, nt)
% vbar = ncread(hisfile,'vbar');     % dimensiones: (xi_v, eta_v, time)
% 
% % Ajustar índices de tiempo según cómo esté guardado (ver ncread)
% % Ejemplo si la dim time es la 3:
% ubar_t = double(ubar(:,:,tstep));   % ubar en m/s en puntos U
% vbar_t = double(vbar(:,:,tstep));   % vbar en puntos V
% 
% %% Interpolar ubar/vbar a puntos rho
% % Si tienes funciones u2rho/v2rho (comunes en toolboxes ROMS/CROCO)
% if exist('u2rho_','file') && exist('v2rho_','file')
%     u_rho = u2rho_(ubar_t);   % transforma de U-grid a rho-grid
%     v_rho = v2rho_(vbar_t);   % transforma de V-grid a rho-grid
% else
%     % SIMPLE INTERPOLATION fallback (assume arrays are shifted by half cell)
%     % Nota: esto es muy básico y depende de cómo estén organizadas tus matrices.
%     u_rho = NaN(size(lon));
%     v_rho = NaN(size(lon));
%     % Interp u (xi_u x eta_u) -> rho (xi_rho x eta_rho)
%     % Shift u one index to the east (example)
%     u_rho(1:end-1, :) = 0.5*(ubar_t + ubar_t([2:end end], :));
%     v_rho(:,1:end-1)  = 0.5*(vbar_t + vbar_t(:, [2:end end]));
%     % Esta es una aproximación. Si tu grid es curvilíneo usa las funciones oficiales.
% end
% 
% %% Magnitud y conversión a cm/s si quieres
% Uabs = sqrt(u_rho.^2 + v_rho.^2);  % m/s
% Uabs_cm = Uabs*100;                % cm/s (opcional)
% 
% 
% %%
% % close all
% skip = 2;
% scale = 0.15;
% % Subsample de vectores
% lon_sub = lon(1:skip:end,1:skip:end);
% lat_sub = lat(1:skip:end,1:skip:end);
% u_sub   = u_rho(1:skip:end,1:skip:end);
% v_sub   = v_rho(1:skip:end,1:skip:end);
% 
% % Calcular magnitud
% Umag = sqrt(u_sub.^2 + v_sub.^2);
% 
% % Definir umbral máximo (por ejemplo 0.2 m/s)
% umbral = 0.3;
% 
% % Crear máscara para vectores válidos
% mask = Umag <= umbral;
% 
% % Aplicar máscara
% lon_f = lon_sub(mask);
% lat_f = lat_sub(mask);
% u_f   = u_sub(mask);
% v_f   = v_sub(mask);
% 
% figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
% m_proj('mercator', 'long',[min(lon(:)) max(lon(:))], 'lat',[min(lat(:)) max(lat(:))]);
% m_pcolor(lon, lat, Uabs); shading interp; hold on;
% cmocean('speed'); colorbar;
% caxis([0 3.9758]);
% % title(sprintf('Instantaneous tidal velocity (timestep %d) — |U| (cm/s)', tstep));
% 
% % Submuestreo de vectores (para que no se saturen)
% m_gshhs_f('patch',[.8 .8 .8]);
% 
% % Flechas de velocidad
% % m_vec(scale, lon(1:skip:end,1:skip:end), lat(1:skip:end,1:skip:end), ...
% %       u_rho(1:skip:end,1:skip:end), v_rho(1:skip:end,1:skip:end), ...
% %       'k','centered','yes','shaftwidth',4,'headlength',12,'edgeclip', ...
% %       'on', 'EdgeColor', 'w');
% 
% m_vec(scale, lon_f, lat_f, u_f, v_f, 'k', 'centered','yes', ...
%       'shaftwidth',4,'headlength',12,'edgeclip','on','EdgeColor','w');
% 
% m_gshhs_f('patch',[.8 .8 .8]);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
% 
% % Flecha de referencia
% ref_speed = 0.1; % m/s
% m_vec(scale, max(lon(:)) - 0.23*(max(lon(:)) - min(lon(:))), ...
%            max(lat(:)) - 0.28*(max(lat(:)) - min(lat(:))), ...
%            ref_speed, 0, 'k', 'key', sprintf('%0.1f m/s', ref_speed), ...
%            'centered','yes','shaftwidth',4,'headlength',12, ...
%            'edgeclip', 'on', 'EdgeColor', 'w');
% 
% %%
% 
% % figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
% figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
% ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen
% hold on
% caxis([0 3.9758]);
% cmocean('speed', 27);
% c=colorbar('north')
% set(c,'Position',[0.2 0.7 0.6 0.03])
% c.Label.String = '[m/s]';
% c.Label.FontSize=16;
% c.Label.FontWeight="bold";
% c.LineWidth=1.5;
% c.FontSize=30;

%% Tidal Velocity Map (M2 + S2) - RMS
close all; clear all; clc

% --- Paths ---
addpath('F:\AAMagister\PRODIGY\Week 1\m_map')
addpath('F:\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
start

hisfile = 'ancud_bench_inv.nc';

% Read lon/lat (rho points)
lon = ncread(hisfile,'lon_rho');
lat = ncread(hisfile,'lat_rho');

% Read barotropic velocities
ubar = ncread(hisfile,'ubar');  % xi_u x eta_rho x time
vbar = ncread(hisfile,'vbar');  % xi_rho x eta_v x time

% Time vector (asumimos dt = 1 h, ajustar si es distinto)
Nt = size(ubar,3);
t = (0:Nt-1)';  % tiempo en horas

% Frecuencias M2 y S2 (rad/hora)
omega_M2 = 2*pi/12.42;   % M2
omega_S2 = 2*pi/12;      % S2

% Prealocate arrays
u_tide = zeros(size(ubar));
v_tide = zeros(size(vbar));

% Fit armónico M2 + S2
% Para ubar
for i = 1:size(ubar,1)      % xi_u
    for j = 1:size(ubar,2)  % eta_rho
        u_series = squeeze(ubar(i,j,:));
        X = [cos(omega_M2*t), sin(omega_M2*t), cos(omega_S2*t), sin(omega_S2*t)];
        coef_u = X\u_series;
        u_tide(i,j,:) = X*coef_u;
    end
end

% Para vbar
for i = 1:size(vbar,1)      % xi_rho
    for j = 1:size(vbar,2)  % eta_v
        v_series = squeeze(vbar(i,j,:));
        X = [cos(omega_M2*t), sin(omega_M2*t), cos(omega_S2*t), sin(omega_S2*t)];
        coef_v = X\v_series;
        v_tide(i,j,:) = X*coef_v;
    end
end

%% Interpolate to rho points
if exist('u2rho_','file') && exist('v2rho_','file')
    u_rho = u2rho_(u_tide(:,:,1));  % solo un ejemplo, luego puedes hacer promedio RMS
    v_rho = v2rho_(v_tide(:,:,1));
else
    % Interpolación manual
    u_rho = NaN(size(lon));
    v_rho = NaN(size(lon));
    u_rho(1:end-1, :) = 0.5*(u_tide(:,:,1) + u_tide([2:end end], :,1));
    v_rho(:,1:end-1)  = 0.5*(v_tide(:, :,1) + v_tide(:, [2:end end],1));
end

%% RMS over tidal cycle
U_rms = sqrt(mean(u_rho.^2 + v_rho.^2, 3));  % magnitud RMS

skip = 2;
scale = 0.15;
% Subsample de vectores
lon_sub = lon(1:skip:end,1:skip:end);
lat_sub = lat(1:skip:end,1:skip:end);
u_sub   = u_rho(1:skip:end,1:skip:end);
v_sub   = v_rho(1:skip:end,1:skip:end);
U_sub   = U_rms(1:skip:end,1:skip:end);  % submuestreo de RMS también

% Definir umbral máximo
umbral = 0.5;

% Crear máscara para vectores válidos en la submatriz
mask = U_sub <= umbral;

% Aplicar máscara
lon_f = lon_sub(mask);
lat_f = lat_sub(mask);
u_f   = u_sub(mask);
v_f   = v_sub(mask);

%% Plot RMS tidal velocity
close all
figure('Units','pixels','Position',[-2559         126        1589         954]);  % figura cuadrada
ax = axes('Position',[0.095    0.075    0.8    0.9]);              % ejes grandes, poco margen

m_proj('mercator','long',[min(lon(:)) max(lon(:))],'lat',[min(lat(:)) max(lat(:))]);
m_pcolor(lon,lat,U_rms); shading interp; hold on;
cmocean('speed'); 
caxis([0 4.1491]);  % ajustar según magnitudes

% Subsample vectors para plot
skip = 2;
scale = 0.25;
% m_vec(scale, lon(1:skip:end,1:skip:end), lat(1:skip:end,1:skip:end), ...
%       u_rho(1:skip:end,1:skip:end), v_rho(1:skip:end,1:skip:end), ...
%       'k','centered','yes','shaftwidth',4,'headlength',12,'edgeclip', 'on', 'EdgeColor', 'w');

m_vec(scale, lon_f, lat_f, u_f, v_f, 'k', 'centered','yes', ...
      'shaftwidth',4,'headlength',12,'edgeclip','on','EdgeColor','w');

m_gshhs_f('patch',[.8 .8 .8]);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'fontsize',40);

% Reference vector
ref_speed = 0.25;  % m/s
[hpv5, htv5] = m_vec(scale, max(lon(:)) - 0.2*(max(lon(:)) - min(lon(:))), ...
           max(lat(:)) - 0.25*(max(lat(:)) - min(lat(:))), ...
           ref_speed, 0,'k','key',sprintf('%.2f m/s',ref_speed), ...
           'centered','yes','shaftwidth',4,'headlength',12,'edgeclip', 'on', 'EdgeColor', 'w');

set(htv5,'FontSize',16,'FontWeight','bold');

% title('RMS Tidal Velocity (M2 + S2) [m/s]');
%%

% figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen
hold on
caxis([0 4.1491]);
cmocean('speed', 27);
c=colorbar('north')
set(c,'Position',[0.2 0.7 0.6 0.03])
c.Label.String = '[m/s]';
c.Label.FontSize=16;
c.Label.FontWeight="bold";
c.LineWidth=1.5;
c.FontSize=30;
