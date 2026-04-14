close all;
clear all;
clc; start

% addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102\');
addpath('F:\AAMagister\Ancud\20210102\');

addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_ver.nc';

% Crear una matriz para almacenar las alturas del nivel del mar
zeta = NaN(38, 56, 651); % Preasignación de memoria

for i = 73:723
    k = i - 72;
    [lat, lon, ~, var1] = get_var(hisfile, [], 'zeta', i, -1, 1, [0 0 0 0]);
    zeta(:,:,k) = var1;
end


% Ejemplo de definición de coordenadas x e y (ajusta según tus datos)
x = 1:size(zeta, 2);  % Puedes usar la dimensión de tus datos
y = 1:size(zeta, 1);

[dx, dy] = gradient(zeta);  % Calcula gradientes en x e y
velocidad_x = -dx;  % Ajusta la relación entre el gradiente y la velocidad
velocidad_y = -dy;

% % Ejemplo de visualización con quiver
% figure;
% quiver(x, y, velocidad_x, velocidad_y);
% xlabel('Eje X');
% ylabel('Eje Y');
% title('Velocidades de corriente');

%%
close all

% Crear figura y proyección del mapa
h=figure('Units','characters','Position',[1 1 370 100]);
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);

% Visualización de los datos
m_pcolor(lon, lat, zeta(:,:,541));
shading interp; 
hold on;

% Configuración de la malla y bordes del mapa
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
m_gshhs_f('patch',[.8 .8 .8]);

% Configuración de la escala de colores y barra de color
caxis([-1.6 0]);
cmocean('deep', 27);

% Visualización de vectores de velocidad
m_vec(0.04, lon, lat, velocidad_x(:,:,541), velocidad_y(:,:,541), 'k', ...
    'centered', 'yes', 'shaftwidth', 2, 'headlength', 6, 'edgeclip', 'on', 'EdgeColor', 'w');

[hpv5, htv5]=m_vec(0.04,lon(31,47),lat(31,47),0.02,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'2 [cm/s]'});

%%

h=figure('Units','characters','Position',[1 1 370 100]);
hold on
caxis([-1.6 0]);
cmocean('deep', 27);
c=colorbar('north')
set(c,'Position',[0.2 0.7 0.6 0.03])
c.Label.String = 'meters [m]';
c.Label.FontSize=16;
c.Label.FontWeight="bold";
c.LineWidth=1.5;
c.FontSize=30;


