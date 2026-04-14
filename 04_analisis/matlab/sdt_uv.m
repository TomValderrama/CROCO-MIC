close all;
clear all; clc
start
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
addpath('D:\OneDrive\Documents\AAMagister\croco_tools-v1.1\croco_tools-v1.1\UTILITIES\m_map1.4h')


hisfile = 'ancud_bench_inv.nc';
gridfile=hisfile;

c=0;
for i=73:721
    c=c+1;
    [latu,lonu,masku,var1]=get_var(hisfile,[],['u'],i,-10,1,[0 0 0 0]); 
    u(:,:,c)=var1;
    [latv,lonv,maskv,var2]=get_var(hisfile,[],['v'],i,-10,1,[0 0 0 0]); 
    v(:,:,c)=var2;
end
[lat,lon,mask,zeta]=get_var(hisfile,[],['zeta'],543,-10,1,[0 0 0 0]); 
    

%%

[u_r]=u2rho_3d(permute(u,[3,1,2]));
u_rho=permute(u_r,[2,3,1]);
[v_r]=v2rho_3d(permute(v,[3,1,2]));
v_rho=permute(v_r,[2,3,1]);


u_rhoMM=nanmean(u_rho(:,:,1:649),3);
v_rhoMM=nanmean(v_rho(:,:,1:649),3);
%%
close all
ax=figure('Units','characters','Position',[-349.2000 3.1538 348.6000 73.3846])

m_proj('miller','long',[-73.7750 -72.4],'lat',[-42.4242 -41.7378]);
m_pcolor(lon,lat,zeta); shading interp; colormap([m_colmap('blues',64)])
m_quiver(lon,lat,u_rhoMM,v_rhoMM)
hold on
m_gshhs_f('patch',[.8 .8 .8]);

[hpv5, htv5]=m_vec(.5,lon,lat,-.25,0,'k','shaftwidth',2,'headlength',6,...
      'key',{'25 [cm/s]'});
set(htv5,'FontSize',12,'FontWeight','bold');
m_vec(.5,lon, lat,u_rho,v_rho,'k',...
           'centered','yes','shaftwidth',2,'headlength',6,'edgeclip','on','EdgeColor','w');


m_grid('box','fancy','tickdir','in','backcolor',[1. 1. 1.],'xtick',4,'ytick',6,'fontsize',30);
 


m_line(-73,-42,'marker','d','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);

%%
m_line(lonBGQ(5),latBGQ(5),'marker','d','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);

 m_line(lonBGQ(6)+0.05,latBGQ(6)-0.06,'marker','o','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]); 

 for i=7:length(lonBGQ)
        m_line(lonBGQ(i),latBGQ(i),'marker','o','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]); 
end
