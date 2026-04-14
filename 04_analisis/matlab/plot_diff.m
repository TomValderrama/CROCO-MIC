close all; clear all;% clc
start

addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'diff_ver_541.nc';
gridfile=hisfile;
nc = netcdf(gridfile,'r');
lon = nc{'lon_rho'}(:);
lat = nc{'lat_rho'}(:);
mask= nc{'mask_rho'}(:);
var = nc{'salt'}(:);
close(nc)

var2=permute(var,[2,3,1]);
% var2=permute(var,[3,4,2,1]);


% % min(min(var2(:,:,42)))
% % max(max(var2(:,:,42)))
% % 
% % meanvar=mean(var2,4);
% % 
% % min(min(min(meanvar(:,:,42))))
% % max(max(max(meanvar(:,:,42))))
%%
close all

    h=figure('Units','characters','Position',[ -149.8000   -0.9231  149.2000   77.4615])%('Position', get(0, 'Screensize'))%,'Visible','off');

%     m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_proj('mercator','long',[-80 -72],'lat',[-50 -38.9959]);

    m_pcolor(lon,lat,var2(:,:,42)); shading interp
    hold on
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
%     m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
    m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',5,'ytick',6,'fontsize',20);
    set(gca, 'xticklabels', {});    
    caxis([-0.0214 0.0214])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance','pivot',0)
cb=colorbar('fontsize',15);

% ylabel('Latitude °S','FontSize',40)
%     title(['\fontsize{20}' 'Okubo ' sprintf(' - hora %d del mes', i)])
%     title(['\fontsize{40}' 'Okubo, '  + string(datetime(date(i,:)))])

%     saveas(h, fullfile(FileDirHorizslice,[ jpgname vname '.jpg']));
