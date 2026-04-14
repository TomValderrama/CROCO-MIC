close all;
clear all; clc
addpath('F:\AAMagister\PRODIGY\Week 1\m_map')
addpath('F:\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = ['F:\AAMagister\Ancud\20210102\ancud_exp4_ver.nc'];
gridfile=hisfile;

for i=73:721
    [lat1,lon1,mask,var1]=get_var(hisfile,[],['zeta'],i,-1,1,[0 0 0 0]); %   USAR ESTA EXTRACCIÓN DE VARIABLES
    zeta(:,:,i)=var1;
    [~,~,~,var2]=get_var(hisfile,[],['u'],i,-10,1,[0 0 0 0]); 
    u(:,:,i)=var2;
    [~,~,~,var3]=get_var(hisfile,[],['v'],i,-10,1,[0 0 0 0]); 
    v(:,:,i)=var3;
end

[u_r]=u2rho_3d(permute(u,[3,1,2]));
u_rho=permute(u_r,[2,3,1]);
[v_r]=v2rho_3d(permute(v,[3,1,2]));
v_rho=permute(v_r,[2,3,1]);


mean1=nanmean(zeta(13:38,8:35,541),2);
mean2=nanmean(mean1,1);
sla541=zeta(:,:,541)-mean2;

% slaDM=nanmean(zeta(:,:,529:553),3)-nanmean(nanmean(nanmean(zeta(13:38,8:35,529:553),3),2),1);
% u_rhoDM=nanmean(u_rho(:,:,529:553),3);
% v_rhoDM=nanmean(v_rho(:,:,529:553),3);

slaMM=nanmean(zeta(:,:,73:721),3)-nanmean(nanmean(nanmean(zeta(13:38,8:35,73:721),3),2),1);
u_rhoMM=nanmean(u_rho(:,:,73:721),3);
v_rhoMM=nanmean(v_rho(:,:,73:721),3);


%%
% 
% 
% h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');
% m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
% m_pcolor(lon1,lat1,sla541); shading interp
% hold on
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
% 
% set(gca, 'xticklabels', {});    
% caxis([-0.065 0.065])
% m_gshhs_f('patch',[.8 .8 .8]);
% cmocean('balance',26)
% [hpv5, htv5]=m_vec(.5,lon1(31,47),lat1(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
%       'key',{'25 [cm/s]'});
% set(htv5,'FontSize',12,'FontWeight','bold');
% m_vec(.5,lon1(1:end,1:end),lat1(1:end,1:end),u_rho(1:end,1:end,541),v_rho(1:end,1:end,541),'k',...
%            'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');


%%
% h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');
% m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
% m_pcolor(lon1,lat1,slaDM); shading interp
% hold on
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% % m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
% 
% set(gca, 'xticklabels', {});    
% caxis([-0.065 0.065])
% m_gshhs_f('patch',[.8 .8 .8]);
% cmocean('balance',27)
% [hpv5, htv5]=m_vec(.5,lon1(31,47),lat1(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
%       'key',{'25 [cm/s]'});
% set(htv5,'FontSize',12,'FontWeight','bold');
% m_vec(.5,lon1(1:end,1:end),lat1(1:end,1:end),u_rhoDM(1:end,1:end),v_rhoDM(1:end,1:end),'k',...
%            'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');

%%
 close all
% get(gcf,'Position')   % [left bottom width height] de la ventana
% get(gca,'Position')   % [left bottom width height] de los ejes dentro de la figura
figure('Units','pixels','Position',[-2559         126        1373         954]);  % figura cuadrada
ax = axes('Position',[0.095 0.075 0.8 0.9]);              % ejes grandes, poco margen



m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon1,lat1,slaMM); shading interp
hold on
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-0.065 0.065])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance',27)


m_gshhs_f('patch',[.8 .8 .8]);

% %% Subsampling factor and vector scale
skip = 2;       % reduce la densidad de flechas
scale = 0.2;   % tamaño relativo de flechas

% %% Plot velocity vectors
m_vec(scale, lon1(1:skip:end,1:skip:end), lat1(1:skip:end,1:skip:end), ...
      u_rhoMM(1:skip:end,1:skip:end), v_rhoMM(1:skip:end,1:skip:end), ...
      'k', 'centered','yes','shaftwidth',4,'headlength',12,'edgeclip','on','EdgeColor','w');

% %% Add coastline
m_gshhs_f('patch',[.8 .8 .8]);

% %% Add map grid
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

% %% Reference arrow
ref_speed = 0.1; % velocidad de referencia en m/s (25 cm/s)
[hpv5, htv5] = m_vec(scale, max(lon1(:)) - 0.15*(max(lon1(:)) - min(lon1(:))), ...
           max(lat1(:)) - 0.2*(max(lat1(:)) - min(lat1(:))), ...
           ref_speed, 0,'k','key',{'10 cm/s'}, ...
           'centered','yes','shaftwidth',4,'headlength',12,'edgeclip','on','EdgeColor','w');
set(htv5,'FontSize',16,'FontWeight','bold');

%%
line_color = [22/255, 112/255, 6/255]; % [R, G, B]
lat_line = [-42.4242 ,-41.7378];
% lon_line = [-72.963, -72.963];
% lon_line = [-72.85 ,-72.85];
% lon_line = [-72.82 ,-72.82];
lon_line = [-72.95, -72.95];
m_line(lon_line, lat_line, 'Color', line_color, 'LineWidth', 4);

%% colorbar

% h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
% hold on
% % caxis([-0.065 0.065])
% colormap(cmocean('balance',27))
% c=colorbar('north')
% set(c,'Position',[0.2 0.7 0.6 0.03])
% c.Label.String = 'meters [m]';
% c.Label.FontSize=16;
% c.Label.FontWeight="bold";
% c.LineWidth=1.5;
% c.FontSize=30;

