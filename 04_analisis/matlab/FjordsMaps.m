% Plot a circular orbit
close all
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\data_sets\github_repo\')
addpath('D:\OneDrive\Documents\AAMagister\PRODIGY\Week 1\m_map\')
start
%%
close all
h=figure('Units','characters','Position',[1 1 370 100])%('Position', get(0, 'Screensize'))

m_proj('miller','lat',82)
m_coast('color',[0 0 0]);
m_gshhs_f('patch',[.8 .8 .8]);
 
[range,ln30,lt30]=m_lldist([-180 180],[-30 -30],40); 
m_line(ln30,lt30,'linewi',3,'color','r');
[range,ln45,lt45]=m_lldist([-180 180],[45 45],40); 
m_line(ln45,lt45,'linewi',3,'color','r');
% m_grid('linestyle','none','box','fancy','tickdir','out');   
m_grid('box','fancy','tickdir','in','backcolor',[1 1 1],'xtick',7,'ytick',6,'fontsize',30);

th=m_annotation('textarrow',[-160 -127],[92 70],'String','Canada','color','b','fontsize',30,'fontweight','bold')
h=m_text(-175,42,' Northem Fjord Belt','vertical','top','color','r','fontsize',15,'fontweight','bold');
h=m_text(-175,-33,' Southem Fjord Belt','vertical','top','color','r','fontsize',15,'fontweight','bold');
th=m_annotation('textarrow',[-90 -72],[-75 -60],'String','Chile','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[-35 -50],[-60 -70],'String','Antartic','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[145 152],[-60 -54],'String','New Zealand','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[-9 10],[93 88],'String','Svalbard','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[-100 -7],[94 67],'String','Scotland','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[40 8],[94 71],'String','Norway','color','b','fontsize',30,'fontweight','bold')
th=m_annotation('textarrow',[100 17],[94 69],'String','Sweden','color','b','fontsize',30,'fontweight','bold')
