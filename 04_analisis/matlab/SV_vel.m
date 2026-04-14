%% SECCIÓN N-S VELOCIDADES U
close all,clear all; clc,start
addpath('F:\AAMagister\PRODIGY\Week 1\m_map')
addpath('F:\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = ['F:\AAMagister\Ancud\20210102\ancud_exp4_ver.nc'];
gridfile=hisfile;

% xi=[];
% for c=1:42
%     [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',541,c,1,[0 0 0 0]);
% end
% xi = cat(4,xi,XI);
% clear XI
% 
% distancia=distance(-72.9166666667,-42.4166666667,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (1,35)
% distancia=distance(-72.9166666667,-41.75,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (37,35)
% 
% sigma=42; %prof=-305; 
% 
% % sección N-S 
% latsec_u=[1:37]'; lonsec_u=[35]; 
% 
% u_latsec=xi(:,35,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
% latsec_lat_u=lat(:,35);
% latsec_lon_u=lon(:,35);
% velocity_latsec=squeeze(u_latsec);
% longitude_latsec = repmat(latsec_lon_u,[1 42]);
% latitude_latsec = repmat(latsec_lat_u,[1 42]);
% 
% z= get_depths(hisfile,hisfile,1,'r');
% Z = permute(z,[2 3 1]);
% zeta = Z(latsec_u,lonsec_u,:);
% zeta = squeeze(zeta);
% 
% xii=permute(xi,[1,3,2]);
% %%
% figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
% pcolor(latitude_latsec(1:37,:),zeta,xii(1:37,:,35))
% shading interp, 
% cmocean('balance')
% caxis([-0.25 0.25])
% xt = get(gca, 'xtick');
% set(gca, 'FontSize', 40)
% % set(gca, 'xtick', [])
% xlabel('Latitude',FontSize=40,FontWeight='bold')
% % set(gca, 'ytick', [])
% xticks(-42.4:0.078:-41.8)
% 
% ylabel('Depth [m]',FontSize=40,FontWeight='bold')
% grid on
% set(gca, 'YGrid', 'on', 'XGrid', 'on','Layer','top')
% %% DAILY MEAN
% xi=[];
% for i=1:24
%     for c=1:42
%         [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',528+i,c,1,[0 0 0 0]);
%     end
% 
% xi = cat(4,xi,XI);
% clear XI
% end
% 
% distancia=distance(-72.9166666667,-42.4166666667,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (1,35)
% distancia=distance(-72.9166666667,-41.75,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (37,35)
% 
% sigma=42; %prof=-305; 
% 
% % sección N-S 
% latsec_u=[1:37]'; lonsec_u=[35]; 
% 
% u_latsec=xi(:,35,:,:); % (lat,lon,sigma,dias) %find(abs(lon(1,:)--73.05)<0.0125) ans = 16
% latsec_lat_u=lat(:,35);
% latsec_lon_u=lon(:,35);
% velocity_latsec=squeeze(u_latsec);
% longitude_latsec = repmat(latsec_lon_u,[1 42]);
% latitude_latsec = repmat(latsec_lat_u,[1 42]);
% 
% z= get_depths(hisfile,hisfile,1,'r');
% Z = permute(z,[2 3 1]);
% zeta = Z(latsec_u,lonsec_u,:);
% zeta = squeeze(zeta);
% 
% xi=mean(xi,4);
% xii=permute(xi,[1,3,2]);
% %%
% figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
% pcolor(latitude_latsec(1:37,:),zeta,xii(1:37,:,35))
% shading interp, 
% cmocean('balance')
% caxis([-0.25 0.25])
% xt = get(gca, 'xtick');
% set(gca, 'FontSize', 40)
% % set(gca, 'xtick', [])
% xlabel('Latitude',FontSize=40,FontWeight='bold')
% xticks(-42.4:0.078:-41.8)
% 
% % set(gca, 'ytick', [])
% ylabel('Depth [m]',FontSize=40,FontWeight='bold')
% grid on
% set(gca, 'YGrid', 'on', 'XGrid', 'on','Layer','top')
%% MONTHLY MEAN

xi=[];
for i=73:97
    for c=1:42
        [lat,lon,mask,XI(:,:,c)]=get_var(hisfile,[],'u',i,c,1,[0 0 0 0]);
    end

xi = cat(4,xi,XI);
clear XI
end

%%
% % distancia=distance(-72.9166666667,-42.4166666667,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (1,35)
% distancia=distance(-72.84,-42.4166666667,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (1,35)
% % distancia=distance(-72.9166666667,-41.75,lon,lat); [i,j]=find(distancia==min(min(distancia))); % (37,35)
% distancia=distance(-72.84,-41.75,lon,lat); [m,n]=find(distancia==min(min(distancia))); % (37,35)

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


%%
figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
% ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen

% Adjusted Position to move the pcolor plot to the right
h_axes = axes('Position', [0.1, 0.22, 0.75, 0.75]);       % con xtick e yticks
% h_axes = axes('Position', [0.02, 0.08, 0.79, 0.9]);         % solo yticks 
pcolor(h_axes, latitude_latsec(1:m,:), zeta, xii(1:m,:,n))
shading interp
cmocean('balance')
caxis([-.25 .25])

xt = get(h_axes, 'xtick');
set(h_axes, 'FontSize', 40)
set(h_axes, 'xtick', [])

% 
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
ylabel(h_axes, 'Depth [m]', 'FontSize', 40, 'FontWeight', 'bold', 'Rotation', -90, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle', 'Position', [max(latitude_latsec(:)) + 0.12, mean(zeta(:)) - 150])
set(h_axes, 'YAxisLocation', 'right');
grid on
set(h_axes, 'YGrid', 'on', 'XGrid', 'on', 'Layer', 'top')

% Etiqueta "Sur"
text(h_axes, min(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'South', 'FontSize', 40, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom')

% Etiqueta "Norte"
text(h_axes, max(get(h_axes, 'XLim')), min(get(h_axes, 'YLim')), 'North', 'FontSize', 40, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom')
%% colorbar

% h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
% hold on
% caxis([-0.25 0.25])
% colormap(cmocean('balance','pivot',0))
% c=colorbar('north')
% set(c,'Position',[0.2 0.7 0.6 0.03])
% c.Label.String = '[m/s]';
% c.Label.FontSize=16;
% c.Label.FontWeight="bold";
% c.LineWidth=1.5;
% c.FontSize=30;
% caxis([-0.25 0.25])