% close all;
clear all; clc
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_ver.nc';
gridfile=hisfile;


[lat,lon,mask,zeta]=get_var(hisfile,[],['zeta'],541,-1,1,[0 0 0 0]); %   USAR ESTA EXTRACCIÓN DE VARIABLES
[~,~,~,u]=get_var(hisfile,[],['u'],541,-10,1,[0 0 0 0]); 
[~,~,~,v]=get_var(hisfile,[],['v'],541,-10,1,[0 0 0 0]); 

[u_rho]=u2rho_2d(u(:,:));
[v_rho]=v2rho_2d(v(:,:));

sla=zeta-nanmean(zeta);

h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,sla); shading interp
hold on
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-0.1 0.1])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')
[hpv5, htv5]=m_vec(.5,lon(31,47),lat(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'25 [cm/s]'});
set(htv5,'FontSize',12,'FontWeight','bold');
m_vec(.5,lon(1:end,1:end),lat(1:end,1:end),u_rho(1:end,1:end),v_rho(1:end,1:end),'k',...
           'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');


%% MEDIA DIARIA

for i=1:24
    [lat,lon,mask,var1]=get_var(hisfile,[],['zeta'],528+i,-1,1,[0 0 0 0]); %   USAR ESTA EXTRACCIÓN DE VARIABLES
    zeta(:,:,i)=var1;
    [~,~,~,var2]=get_var(hisfile,[],['u'],528+i,-10,1,[0 0 0 0]); 
    u(:,:,i)=var2;
    [~,~,~,var3]=get_var(hisfile,[],['v'],528+i,-10,1,[0 0 0 0]); 
    v(:,:,i)=var3;
end

zetaM=mean(zeta,3);
uM=mean(u,3);
vM=mean(v,3);

[u_rho]=u2rho_2d(uM(:,:));
[v_rho]=v2rho_2d(vM(:,:));

sla=zetaM-nanmean(zetaM);

h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,sla); shading interp
hold on
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-0.03 0.03])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')
[hpv5, htv5]=m_vec(.5,lon(31,47),lat(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'25 [cm/s]'});
set(htv5,'FontSize',12,'FontWeight','bold');
m_vec(.5,lon(1:end,1:end),lat(1:end,1:end),u_rho(1:end,1:end),v_rho(1:end,1:end),'k',...
           'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');

%% MEDIA MENSUAL

for i=73:721
    [lat,lon,mask,var1]=get_var(hisfile,[],['zeta'],i,-1,1,[0 0 0 0]); %   USAR ESTA EXTRACCIÓN DE VARIABLES
    zeta(:,:,i)=var1;
    [~,~,~,var2]=get_var(hisfile,[],['u'],i,-10,1,[0 0 0 0]); 
    u(:,:,i)=var2;
    [~,~,~,var3]=get_var(hisfile,[],['v'],i,-10,1,[0 0 0 0]); 
    v(:,:,i)=var3;
end

zetaM=mean(zeta,3);
uM=mean(u,3);
vM=mean(v,3);

[u_rho]=u2rho_2d(uM(:,:));
[v_rho]=v2rho_2d(vM(:,:));

sla=zetaM-nanmean(zetaM);

%%
h=figure('Units','characters','Position',[1 1 370 100]);
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,sla); shading interp
hold on
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);


set(gca, 'xticklabels', {});    
% caxis([-0.03 0.03])
caxis([-0.065 0.065])

m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')
[hpv5, htv5]=m_vec(.5,lon(31,47),lat(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'25 [cm/s]'});
set(htv5,'FontSize',12,'FontWeight','bold');
m_vec(.5,lon(1:end,1:end),lat(1:end,1:end),u_rho(1:end,1:end),v_rho(1:end,1:end),'k',...
           'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');

%% colorbar

% h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
% hold on
% caxis([-0.03 0.03])
% colormap(cmocean('balance','pivot',0))
% c=colorbar('north')
% set(c,'Position',[0.2 0.7 0.6 0.03])
% c.Label.String = 'meters [m]';
% c.Label.FontSize=16;
% c.Label.FontWeight="bold";
% c.LineWidth=1.5;
% c.FontSize=30;
