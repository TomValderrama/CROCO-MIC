%% Residual Tidal Velocity Map
close all; clear all; clc
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_ver.nc';

%% Read lon/lat (rho points)
lon = ncread(hisfile,'lon_rho');
lat = ncread(hisfile,'lat_rho');

%% Read barotropic velocities
ubar = ncread(hisfile,'ubar');  % dimensiones (xi_u, eta_u, time)
vbar = ncread(hisfile,'vbar');

%% Compute residual (time-averaged) velocities
% u_res = mean(ubar,3,'omitnan');   % promedio en el tiempo
% v_res = mean(vbar,3,'omitnan');

u_res = mean(ubar(:,:,73:end),3,'omitnan');   % promedio en el tiempo, omitiendo primeras 72h
v_res = mean(vbar(:,:,73:end),3,'omitnan');
%% Interpolate to rho points
if exist('u2rho_','file') && exist('v2rho_','file')
    u_rho = u2rho_(u_res);
    v_rho = v2rho_(v_res);
else
    u_rho = NaN(size(lon));
    v_rho = NaN(size(lon));
    u_rho(1:end-1, :) = 0.5*(u_res + u_res([2:end end], :));
    v_rho(:,1:end-1)  = 0.5*(v_res + v_res(:, [2:end end]));
end

%% Magnitude of residual velocity
Uabs = sqrt(u_rho.^2 + v_rho.^2);  % m/s

%% Plot residual currents
close all
% figure('Units','characters','Position',[-300 -5 370 100]);
figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
m_proj('mercator','long',[min(lon(:)) max(lon(:))],'lat',[min(lat(:)) max(lat(:))]);
m_pcolor(lon,lat,Uabs); shading interp; hold on;
cmocean('speed'); colorbar;
% title('Residual Tidal Velocity |U| (m/s)');
caxis([0 0.5801]);
% Subsample vectors
skip = 2;
scale = 0.15;
m_vec(scale, lon(1:skip:end,1:skip:end), lat(1:skip:end,1:skip:end), ...
      u_rho(1:skip:end,1:skip:end), v_rho(1:skip:end,1:skip:end), ...
      'k','centered','yes','shaftwidth',4,'headlength',12,'edgeclip', 'on', 'EdgeColor', 'w');

m_gshhs_f('patch',[.8 .8 .8]);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

% Reference arrow
ref_speed = 0.1; % ajustar según valores típicos de corrientes residuales
m_vec(scale, max(lon(:)) - 0.25*(max(lon(:)) - min(lon(:))), ...
           max(lat(:)) - 0.3*(max(lat(:)) - min(lat(:))), ...
           ref_speed, 0,'k','key',sprintf('%.1f m/s',ref_speed), ...
           'centered','yes','shaftwidth',4,'headlength',12, ...
           'edgeclip', 'on', 'EdgeColor', 'w');

%%

% figure('Units','normalized','Position',[0.05 0.05 0.9 0.8]);
figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen
hold on
caxis([0 0.5801]);
cmocean('speed', 27);
c=colorbar('north')
set(c,'Position',[0.2 0.7 0.6 0.03])
c.Label.String = '[m/s]';
c.Label.FontSize=16;
c.Label.FontWeight="bold";
c.LineWidth=1.5;
c.FontSize=30;