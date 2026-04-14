close all; clear all; clc
start

addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')

hisfile = 'ancud_bench_ver.nc';
gridfile=hisfile;
var=[];

%%
[lat,lon,mask,okubo]=get_okubo(hisfile,gridfile,541,1,1);
%%
h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])
m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,okubo.*mask); shading interp
hold on

% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-2e-9 2e-9])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')

%% MEDIAS DIARIAS
for i= 1:24
    [lat,lon,mask,XI]=get_okubo(hisfile,gridfile,528+i,1,1);
    var(:,:,i)=XI;
    clear XI
end

okuboDM=mean(var,3);
%%
h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');

m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,okuboDM.*mask); shading interp
hold on

m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-2e-9 2e-9])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')

%% MEDIAS MENSUALES
for i= 1:649
    [lat,lon,mask,XI]=get_okubo(hisfile,gridfile,72+i,1,1);
    var(:,:,i)=XI;
    clear XI
end

okuboMM=nanmean(var,3);
%%
h=figure('Units','characters','Position',[-2.666000000000000e+02,-0.923076923076923,266,77.461538461538470])%('Position', get(0, 'Screensize'))%,'Visible','off');

m_proj('miller','long',[-73.55 -72.4250],'lat',[-42.4611 -41.7191]);
m_pcolor(lon,lat,okuboMM.*mask); shading interp
hold on

% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'fontsize',50);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'yticklabel',[],'fontsize',50);
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'xticklabel',[],'yticklabel',[],'fontsize',40);
% m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',8,'ytick',10,'fontsize',40);

set(gca, 'xticklabels', {});    
caxis([-2e-9 2e-9])
m_gshhs_f('patch',[.8 .8 .8]);
cmocean('balance')

%% colorbar
% 
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
