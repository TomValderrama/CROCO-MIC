close all
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
start_v11

% make_coast('croco_grd.nc','coast_f.mat'); % con esto se hace una linea de costa full resolucion
hisfile = ['mosa_BGQ_his_M1_1h_WD_20210102.nc'];

nc = netcdf(hisfile,'r');
lon = nc{'lon_rho'}(:);
lat = nc{'lat_rho'}(:);
zeta = nc{'zeta'}(:);
mask= nc{'mask_rho'}(:);

[lat,lon,mask,var]=get_var(hisfile,[],['h'],1,-1,1,[0 0 0 0]);

%%
close all; 
h=figure('Units','characters','Position',[1 1 370 75])%('Units','characters','Position',[-3.666000000000000e+02,-0.923076923076923,366,77.461538461538470])%('Position', get(0, 'Screensize'))% ,'Visible','off');

ax1=axes('position',[0.1130    -0.0100    0.3347    0.8150]);
m_proj('mercator','long',[-76 -72],'lat',[-46 -41]);
caxis(ax1,[-6000 3000]);       
m_pcolor(lon,lat,-var); shading interp
hold on
m_grid('box','fancy','tickdir','in','backcolor',[.6 .6 .6],'xtick',6,'ytick',6,'fontsize',20);
set(findobj('tag','m_grid_color'),'facecolor',[.6 .6 .6]);

b=colorbar('westoutside','FontSize',17);
b_pos = get(b, 'pos');
b_width = b_pos(3);
b_height = b_pos(4);
new_pos = b_pos + [-.1 .12 -.005 -1.3];
new_width = max(b_width + new_pos(3), 0);
new_height = max(b_height + new_pos(4), 0);
set(b, 'pos', [new_pos(1:2) new_width new_height+0.5], 'tickdir', 'out','FontWeight','bold');
caxis([-3500 0])
colormap(ax1, cmocean('topo', 'pivot', -1750));

zoom_left_bottom = [-73.55, -42.4611];
zoom_right_top = [-72.4250, -41.7191];

% Dibujar un rectángulo con cuatro líneas en el gráfico de la izquierda
m_line([zoom_left_bottom(1), zoom_left_bottom(1)], [zoom_left_bottom(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 4);
m_line([zoom_right_top(1), zoom_right_top(1)], [zoom_left_bottom(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 4);
m_line([zoom_left_bottom(1), zoom_right_top(1)], [zoom_left_bottom(2), zoom_left_bottom(2)], 'Color', 'r', 'LineWidth', 4);
m_line([zoom_left_bottom(1), zoom_right_top(1)], [zoom_right_top(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 4);

m_gshhs_f('patch',[.8 .8 .8]);

ax2=axes('position',[0.4403 0.1100 0.5 0.8150]);
m_proj('mercator','long',[-74 -72],'lat',[-42.75 -41.33]);
m_pcolor(lon,lat,-var); shading interp
hold on
m_grid('box','fancy','tickdir','in','backcolor',[.6 .6 .6],'xtick',6,'ytick',6,'fontsize',20, 'yaxisloc','right');
set(findobj('tag','m_grid_color'),'facecolor',[.6 .6 .6]);
b2=colorbar
b2=colorbar("eastoutside",'FontSize',17);
b2_pos = get(b2, 'pos');
b2_width = b2_pos(3);
b2_height = b2_pos(4);
new_pos2 = b2_pos + [.01 .0 -.0057 -0.83];
new_width2 = max(b2_width + new_pos2(3), 0);
new_height2 = max(b2_height + new_pos2(4), 0);
set(b2, 'pos', [new_pos2(1:2) new_width2 new_height2], 'tickdir', 'out','FontWeight','bold');
m_gshhs_f('patch',[.8 .8 .8]);

colormap(ax2,[m_colmap('blues',240)]);

% Mover los yticks a la derecha en el subplot ax1
set(ax2, 'YAxisLocation', 'right');
m_line([zoom_left_bottom(1), zoom_left_bottom(1)], [zoom_left_bottom(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 8);
m_line([zoom_right_top(1), zoom_right_top(1)], [zoom_left_bottom(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 8);
m_line([zoom_left_bottom(1), zoom_right_top(1)], [zoom_left_bottom(2), zoom_left_bottom(2)], 'Color', 'r', 'LineWidth', 8);
m_line([zoom_left_bottom(1), zoom_right_top(1)], [zoom_right_top(2), zoom_right_top(2)], 'Color', 'r', 'LineWidth', 8);


 % Asegúrate de que las posiciones de los ejes (ax1 y ax2) estén configuradas correctamente
ax1.Position = [0.100 0.1100 0.3347-0.02 0.8150];
ax2.Position = [0.3903+0.05 0.1100 0.5-0.09 0.8150];
offset_vertical = 0.225;  % Puedes ajustar este valor según sea necesario
offset_horizontal = -0.06;  % Puedes ajustar este valor según sea necesario

% Dibujar una línea que conecta el centro del subplot ax1 con el ax2
line_x = [ax1.Position(1) + ax1.Position(3) + offset_horizontal, ax2.Position(1) + 0.09];
line_y = [ax1.Position(2) + ax1.Position(4)/ 2 + offset_vertical, ax2.Position(2) + ax2.Position(4) / 2];% + offset_vertical];
annotation('line', line_x, line_y, 'Color', 'r', 'LineWidth', 4);


annotation('textbox',[.64 .62 .075 .12],'margin',1,'FitBoxToText','on','BackgroundColor',[1 1 1],'string','Reloncaví Sound', ...
   'HorizontalAlignment','center','color','k', 'fontsize',18,'fontweight','bold')
annotation('textbox',[.60 .43 .075 .12],'margin',1,'FitBoxToText','on','BackgroundColor',[1 1 1],'string','Gulf of Ancud', ...
    'HorizontalAlignment','center','color','k', 'fontsize',18,'fontweight','bold')
annotation('textbox',[.75 .35 .075 .12], 'Rotation', 270, 'margin',1,'FitBoxToText','on','BackgroundColor',[1 1 1],'string','Comau Fjord', ...
   'HorizontalAlignment','center','color','k', 'fontsize',18,'fontweight','bold')
annotation('textbox',[.28 .53 .075 .12],'margin',1,'FitBoxToText','on',...
'BackgroundColor',[1 1 1],'String',sprintf('Gulf of\nCorcovado'), ...
'HorizontalAlignment','center','Color','k','FontSize',15,'FontWeight','bold');   
annotation('textbox',[.28 .5 .075 .12],'margin',1,'FitBoxToText','on','BackgroundColor',[1 1 1],'string','Chiloe Island', ...
    'HorizontalAlignment','center', 'Rotation', 90,'color','k', 'fontsize',18,'fontweight','bold')