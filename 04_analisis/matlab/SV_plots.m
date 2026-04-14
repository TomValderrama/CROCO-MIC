%% NO PUSE LAS COORDENADAS ESPECIFICAS PARA CADA TRANSECTA

close all,clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_ver.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end


%%
% distancia=distance(-73.083,-42.15,lon,lat); [m1,n]=find(distancia==min(min(distancia))); % (1,35)
% distancia=distance(-73.083,-41.915,lon,lat); [m2,n]=find(distancia==min(min(distancia))); % (37,35)

distancia=distance(-72.85,-42.267,lon,lat); [m1,n]=find(distancia==min(min(distancia))); % 
distancia=distance(-72.85,-41.94,lon,lat); [m2,n]=find(distancia==min(min(distancia))); % 

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[m1:m2]'; lonsec_u=[n]; 

u_latsec=xi(:,m1:m2,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);


latitude_lat = [min(latsec_lat_u):0.25/3:max(latsec_lat_u)]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end



figure('Units','characters','Position',[1 1 370 76])

h_axes = axes('Position', [0.1, 0.1, 0.85, 0.88]);         % solo yticks 
pcolor(h_axes, latitude_latsec(m1:m2,:), zeta, xii(m1:m2,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
% set(h_axes, 'xtick', [])

% xlim([latitude_latsec(m1,1), latitude_latsec(m2,1)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'left');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')



%%
close all,clear all; clc,start
addpath('F:\AAMagister\PRODIGY\Week 1\m_map')
addpath('F:\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = ['F:\AAMagister\Ancud\20210102\ancud_exp4_inv.nc'];
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end


distancia=distance(-72.963,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.963,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);


% figure ('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])
% 
% h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
% pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
% shading interp
% cmocean('balance')
% caxis([-.25 .25])
% 
% xt = get(h_axes, 'xtick');
% set(h_axes, 'FontSize', 40)
% set(h_axes, 'xtick', [])
% 
% ylim([-300 0])
% ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
% set(h_axes, 'YAxisLocation', 'right');
% grid on
% set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
% % Etiqueta "South"
% text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')
% 
% % Etiqueta "North"
% text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')


figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
% ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen

% Adjusted Position to move the pcolor plot to the right
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);       % con xtick e yticks
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

latitude_lat = [-42.424205780029300:0.25/3:-41.737785339355470]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end

xlim([latitude_latsec(1), latitude_latsec(end)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

latitude_lat = [-42.424205780029300:0.25/3:-41.737785339355470]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end

xlim([latitude_latsec(1), latitude_latsec(end)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')

% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_exp2_ver.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end

%%
% distancia=distance(-72.95,-42.24,lon,lat); [m1,n]=find(distancia==min(min(distancia))); % 
% distancia=distance(-72.95,-41.89,lon,lat); [m2,n]=find(distancia==min(min(distancia))); % 
distancia=distance(-73.24,-42.27,lon,lat); [m1,n]=find(distancia==min(min(distancia))); % 
distancia=distance(-73.24,-41.94,lon,lat); [m2,n]=find(distancia==min(min(distancia))); % 

% distancia=distance(-73.085,-42.42,lon,lat); [m1,n1]=find(distancia==min(min(distancia))); % 
% distancia=distance(-73.77,-42.42,lon,lat); [m2,n2]=find(distancia==min(min(distancia))); % 
sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[m1:m2]'; lonsec_u=[n]; 

u_latsec=xi(:,m1:m2,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);

latitude_lat = [min(latsec_lat_u):0.25/3:max(latsec_lat_u)]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);
 
for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end


figure('Units','characters','Position',[1 1 370 76])

h_axes = axes('Position', [0.08, 0.1, 0.85, 0.88]);         % solo yticks 
pcolor(h_axes, latitude_latsec(m1:m2,:), zeta, xii(m1:m2,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')


hisfile = 'ancud_bench_inv.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end


distancia=distance(-72.95,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.95,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);

figure('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])

h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
% h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);       % con xtick e yticks
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')

% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'Tancud_exp5_inv.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end

distancia=distance(-72.95,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.95,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);

figure('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])

% h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);       % con xtick e yticks
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

latitude_lat = [-42.424205780029300:0.25/3:-41.737785339355470]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end

xlim([latitude_latsec(1), latitude_latsec(end)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

latitude_lat = [-42.424205780029300:0.25/3:-41.737785339355470]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end

xlim([latitude_latsec(1), latitude_latsec(end)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')

% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_exp4_ver.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end


distancia=distance(-72.82,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.82,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);


figure('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])

% h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);       % con xtick e yticks
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

latitude_lat = [-42.424205780029300:0.25/3:-41.737785339355470]';

for i = 1:length(latitude_lat)
    lat_sexagesimal(i, :) = decimalToSexagesimal(latitude_lat(i));
end

vector_cell = mat2cell(lat_sexagesimal, ones(1, 9), 2);

for i = 1:numel(vector_cell)
    vector_cell{i} = [num2str(vector_cell{i}(1)) '°' num2str(vector_cell{i}(2)) ''''];
end

xlim([latitude_latsec(1), latitude_latsec(end)])
xticks(h_axes, latitude_lat);
xticklabels(h_axes, vector_cell);

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')

% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_exp4_inv.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end


distancia=distance(-72.963,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.963,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);


figure ('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])

h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')

%%
clear all; clc,start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_exp2_inv.nc';
gridfile=hisfile;

xi=[];
for i=73:721
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end

distancia=distance(-72.95,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
distancia=distance(-72.95,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

sigma=42; %prof=-305; 

% sección N-S 
latsec_u=[1:m]'; lonsec_u=[n]; 

u_latsec=xi(:,m,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
latsec_lat_u=lat(:,n);
latsec_lon_u=lon(:,n);
velocity_latsec=squeeze(u_latsec);
longitude_latsec = repmat(latsec_lon_u,[1 42]);
latitude_latsec = repmat(latsec_lat_u,[1 42]);

z= get_depths(hisfile,hisfile,1,'r');
Z = permute(z,[2 3 1]);
zeta = Z(latsec_u,lonsec_u,:);
zeta = squeeze(zeta);

xi=nanmean(xi,4);
xii=permute(xi,[1,3,2]);


figure('Units','characters','Position',[-2.666000000000000e+02,-0.9076923076923,266,77.461538461538470])

h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

ylim([-300 0])
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.1, mean(zeta(:)) - 125])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')
% Etiqueta "South"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "North"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')