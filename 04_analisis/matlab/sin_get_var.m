% close all;
clear all; clc
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'out2.nc';
gridfile=hisfile;
nc = netcdf(hisfile,'r');
lon = nc{'lon_rho'}(:);
lat = nc{'lat_rho'}(:);
mask= nc{'mask_rho'}(:);
zeta = nc{'zeta'}(:);
u= nc{'u'}(:);
v= nc{'v'}(:);
close(nc)

u=permute(u,[3,4,1,2]);
u=u(:,:,541,42);
v=permute(v,[3,4,1,2]);
v=v(:,:,541,42);
zeta=permute(zeta,[2,3,1]);
zeta=zeta(:,:,541,1);
%%
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
caxis([-0.03 0.03])
% caxis([0 1.0499])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')
[hpv5, htv5]=m_vec(.5,lon(31,47),lat(31,47),-.25,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'25 [cm/s]'});
colorbar
set(htv5,'FontSize',12,'FontWeight','bold');
m_vec(.5,lon(1:end,1:2:end),lat(1:end,1:2:end),u_rho(1:end,1:2:end),v_rho(1:end,1:2:end),'k',...
           'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');


