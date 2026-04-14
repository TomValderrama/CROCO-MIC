close all, clear all; clc, start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_exp4_ver.nc';
gridfile = hisfile;

k=0;
for i=73:721
    k=k+1;
    [X,Z,u(:,:,k)]=get_section(hisfile,hisfile, [-73.12 ,-72.83],[-42.21 ,-42.02],'u',i);

    [X,Z,v(:,:,k)]=get_section(hisfile,hisfile, [-73.12 ,-72.83],[-42.21 ,-42.02],'v',i);
end

var=sqrt(u.^2+v.^2);

vel=nanmean(var,3);

%% QUIVER

% Calcular la dirección de las velocidades
theta = atan2(v, u);
% Convertir de radianes a grados
theta_deg = rad2deg(theta);
%%
% Plot de las direcciones
figure('Units', 'characters', 'Position', [-2.666000000000000e+02, -0.9076923076923, 266, 77.461538461538470])
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);
% Plot de la magnitud de las velocidades
pcolor(h_axes, X, Z, vel)
shading interp
cmocean('speed')
caxis([0. max(max(vel))])
xlabel('Position along the section [km]')

ylabel(h_axes, 'Depth [m]', 'FontSize', 60, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(X(:)) + 7., mean(Z(:)) - 120])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
ylim([-305 0])

set(h_axes, 'FontSize', 30,'FontWeight','bold'); % Puedes ajustar el tamaño de la fuente según tus necesidades

h_colorbar = colorbar('location', 'westoutside');
% Agregar flechas para indicar las direcciones de las velocidades
hold on
quiver(X, Z, nanmean(u,3), nanmean(v,3),'filled', 'k', 'LineWidth', 1.5, 'MaxHeadSize', 1.1, 'MarkerEdgeColor', 'w');
% Mostrar el gráfico
hold off

%% LINEAS DE CORRIENTE

% Convertir de radianes a grados
theta_deg = rad2deg(theta);
% Plot de la magnitud de las velocidades
figure('Units', 'characters', 'Position', [-2.666000000000000e+02, -0.9076923076923, 266, 77.461538461538470])
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);
pcolor(h_axes, X, Z, vel)
shading interp
cmocean(['speed'])
caxis([0. max(max(vel))])
xlabel('Position along the section [km]')

ylabel(h_axes, 'Depth [m]', 'FontSize', 60, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(X(:)) + 7., mean(Z(:)) - 120])

set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
ylim([-305 0])
set(h_axes, 'FontSize', 30,'FontWeight','bold'); % Puedes ajustar el tamaño de la fuente según tus necesidades

h_colorbar = colorbar('location', 'westoutside');
% Agregar líneas de corriente para indicar las direcciones de las velocidades
hold on
streamslice(X, Z, nanmean(u,3), nanmean(v,3), 'k')
% Mostrar el gráfico
hold off


