close all, clear all; clc, start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_inv.nc';
gridfile = hisfile;

k=0;
for i=73:721
    k=k+1;
    [X,Z,temp(:,:,k)]=get_section(hisfile,hisfile, [-73.95 -72.95],[-41.45 -42.25], 'temp',i);
    [X,Z,rho(:,:,k)]=get_section(hisfile,hisfile, [-73.95 -72.95],[-41.45 -42.25], 'rho',i);
end

%% Plot temp

% Plot de las direcciones
figure('Units', 'characters', 'Position', [-2.666000000000000e+02, -0.9076923076923, 266, 77.461538461538470])
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);
% Plot de la magnitud de las velocidades
pcolor(h_axes, X, Z, nanmean(temp,3))
shading interp
% cmocean('thermal')
colormap('jet')
caxis([min(min(min(temp))) max(max(max(temp)))])
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
quiver(X, Z, nanmean(u,3), nanmean(v,3), 'k', 'LineWidth', 1.5, 'MaxHeadSize', 0.02);
% Mostrar el gráfico
hold off

%% Plot rho

% Plot de las direcciones
figure('Units', 'characters', 'Position', [-2.666000000000000e+02, -0.9076923076923, 266, 77.461538461538470])
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);
% Plot de la magnitud de las velocidades
pcolor(h_axes, X, Z, nanmean(rho,3))
shading interp
cmocean('dense')
caxis([min(min(min(rho))) max(max(max(rho)))])
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
quiver(X, Z, nanmean(u,3), nanmean(v,3), 'k', 'LineWidth', 1.5, 'MaxHeadSize', 0.02);
% Mostrar el gráfico
hold off