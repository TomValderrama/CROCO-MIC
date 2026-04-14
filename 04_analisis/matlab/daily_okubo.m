close all; clear all; clc
start

addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'dia23_exp2_inv.nc';
gridfile=hisfile;
nc = netcdf(gridfile,'r');
lon = nc{'lon_rho'}(:);
lat = nc{'lat_rho'}(:);
mask= nc{'mask_rho'}(:);
close(nc)

%%
var=[];
for i= 1:24
    [latt,lonn,mask,XI]=get_okubo(hisfile,gridfile,i,-1,1);
    var(:,:,i)=XI;
    clc
    
%     xi = cat(4,xi,XI);
    clear XI
end

daily_var=mean(var,3);

%%
close all
for i=1:1
    h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');

    m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
    m_pcolor(lon,lat,daily_var(:,:,i).*mask); shading interp
    hold on
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
    m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);
    set(gca, 'xticklabels', {});    
    caxis([-2e-9 2e-9])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')
% ylabel('Latitude °S','FontSize',40)
%     title(['\fontsize{20}' 'Okubo ' sprintf(' - hora %d del mes', i)])
%     title(['\fontsize{40}' 'Okubo, '  + string(datetime(date(i,:)))])

%     saveas(h, fullfile(FileDirHorizslice,[ jpgname vname '.jpg']));
end