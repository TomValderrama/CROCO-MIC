 clear all
start 
addpath('D:\OneDrive\Documents\AAMagister\croco_tools-v1.1\croco_tools-v1.1\UTILITIES\m_map1.4h')
A=dlmread('A.txt'); B=dlmread('B.txt'); C=dlmread('C.txt'); D=dlmread('D.txt');
E=dlmread('M2u.txt'); E=E'; F=dlmread('M2ubar.txt'); F=F'; G=dlmread('S2u.txt'); G=G'; H=dlmread('S2ubar.txt'); H=H';
I=dlmread('M2v.txt'); I=I'; J=dlmread('M2vbar.txt'); J=J'; K=dlmread('S2v.txt'); K=K'; L=dlmread('S2vbar.txt'); L=L';
M=dlmread("M2bar.txt"); N=dlmread("M2vel.txt"); O=dlmread("S2bar.txt"); P=dlmread("S2vel.txt");

% num1 = 2 * A * B';
% den1 = A * A' + B * B';
% SIM2 = num1 / den1;
% 
% num2 = 2 * C * D';
% den2 = C * C' + D * D';
% SIS2 = num2 / den2;
% 
% 
% num3 = 2 * M * N';
% den3 = M * M' + N * N';
% SIuM2 = num3 / den3;
% 
% num4 = 2 * O * P';
% den4 = O * O' + P * P';
% SIuS2 = num4 / den4;


% num3 = 2 * E * F';
% den3 = E * E' + F * F';
% SIuM2 = num3 / den3;
% 
% num4 = 2 * G * H';
% den4 = G * G' + H * H';
% SIuS2 = num4 / den4;



% num5 = 2 * I * J';
% den5 = I * I' + J * J';
% SIvM2 = num5 / den5;
% 
% num6 = 2 * K * L';
% den6 = K * K' + L * L';
% SIvS2 = num6 / den6;


RMSEM2=rmse(A,B)%*100; % rmse en centimetros
RMSES2=rmse(C,D)%*100; % rmse en centimetros
RMSEuM2=rmse(M,N)%*100; % rmse en centimetros
RMSEuS2=rmse(O,P)%*100; % rmse en centimetros
%%
SIM2=(RMSEM2/mean(A))*100
SIS2=(RMSES2/mean(C))*100

%%
% RMSEvM2=rmse(I,J)*100; % rmse en centimetros
% RMSEvS2=rmse(K,L)*100; % rmse en centimetros


R=corrcoef(A,B);
RM2=R(1,2)%*100;
R=corrcoef(C,D);
RS2=R(1,2)%*100;
R=corrcoef(M,N);
RuM2=R(1,2)%*100;
R=corrcoef(O,P);
RuS2=R(1,2)%*100;
% R=corrcoef(I,J);
% RvM2=R(1,2)*100;
% R=corrcoef(K,L);
% RvS2=R(1,2)*100;
%%
% close all

h=figure('Units','characters','Position',[1 1 370 100]);
subplot(121),
scatter(A,B,60,"filled",MarkerFaceColor='b',MarkerEdgeColor='m'),hold on
xlim([0 3]), ylim([0 3])
plot([0 3],[0 3],'DisplayName','Diagonal','LineWidth',2); 
set(gca,'YColor',[0 0 0],'FontWeight','bold','FontSize',16); % Set RGB value to what you want
xlabel({'Observed amplitudes', 'of elevations (m)'},FontSize=30,FontWeight='bold')
ylabel({'Modeleded amplitudes' ,'of elevations (m)'},FontSize=30,FontWeight='bold')
% text(0.25,2.7,{strcat('RMSE = ', num2str( round(RMSEM2,2).'), ' m'), strcat('r = ', num2str( round(RM2,2).')), strcat('SI = ', num2str( round(SIM2,2).'))},"FontSize",	16,FontWeight="bold")
text(0.2,2.8,'(a) M2',"FontSize", 20,FontWeight="bold")
text(1.9,.4,{strcat('RMSE = ', num2str( round(RMSEM2,2).'), ' m'), strcat('r = ', num2str( round(RM2,2).')), strcat('SI = ', num2str( round(SIM2,2).'),'%')},"FontSize",	16,FontWeight="bold")

box on;
subplot(122),
scatter(C,D,60,"filled",MarkerFaceColor='b',MarkerEdgeColor='m'),hold on
xlim([0 1]), ylim([0 1])
plot([0 1],[0 1],'DisplayName','Diagonal','LineWidth',2); 
set(gca,'YTick',[])
yyaxis right
set(gca,'YColor',[0 0 0],'FontWeight','bold','FontSize',16); % Set RGB value to what you want
ytickangle(0)
xlabel({'Observed amplitudes', 'of elevations (m)'},FontSize=30,FontWeight='bold')
label_h=ylabel({'Modeleded amplitudes' ,'of elevations (m)'},FontSize=30,FontWeight='bold')
label_h.Position(1) = 1.21 % change horizontal position of ylabel
label_h.Position(2) = .5; % change vertical position of ylabel
hYLabel = get(gca,'YLabel');
set(hYLabel,'rotation',-90,'VerticalAlignment','middle')
% text(0.1,0.9,{strcat('RMSE = ', num2str( round(RMSES2,2).'), ' m'), strcat('r = ', num2str( round(RS2,2).')), strcat('SI = ', num2str( round(SIS2,2).'))},"FontSize",	16,FontWeight="bold")
text(0.63,0.13,{strcat('RMSE = ', num2str( round(RMSES2,2).'), ' m'), strcat('r = ', num2str( round(RS2,2).')), strcat('SI = ', num2str( round(SIS2,2).'),'%')},"FontSize",	16,FontWeight="bold")
text(0.06,0.93,'(b) S2',"FontSize", 20,FontWeight="bold")

box on;
%%
cd 20210102\
tided='mosa_BGQ_his_M1_1h_WD_20210102.nc';  
ex_tide='USIPA_BGQ';


nc=netcdf(tided,'nowrite'); 
lon=nc{'lon_rho'}(:); 
lat=nc{'lat_rho'}(:);
 
zeta=nc{'zeta'}(:); 
mask=nc{'mask_rho'}(:); 
mask(find(mask==0))=nan;
 
tim=nc{'time'}(:);
tim=tim-tim(1);

staBGQ=['Ancud       ';'Puerto_Montt';'Castro      ';'Melinka     ';'Chacabuco   ';'CHACA       ';'DARWI       ';'ERRAZ       ';'ERRAZ_darwin';'GAVIO       ';'MENIN       ';'PESUR       ';'PULEL       ';'SNAME       ';'VICUN       '];
% lonBGQ=[-73.8171,-72.9268,-73.6981,-73.7188,-72.8457,-73.4887 -74.0819, -73.8121, -73.7192, -73.4183,-73.6753, -73.7950, -73.4921, -73.8544, -74.1281];
lonBGQ=[-73.8171,-72.9268,-73.6981,-73.7188,-72.8457,-73.4887 -74.0819, -73.8121, -73.7192, -73.4183,-73.6753, -73.7950, -73.8544, -74.1281, -73.4921];
% latBGQ=[-41.8564,-41.4998,-42.5821,-43.8396,-45.4215,-41.8702,-45.4060, -45.5968, -45.3967, -44.9287, -45.2407,-44.7430, -41.8533, -44.0142, -45.6527];
latBGQ=[-41.8564,-41.4998,-42.5821,-43.8396,-45.4215,-41.8702,-45.4060, -45.5968, -45.3967, -44.9287, -45.2407,-44.7430, -44.0142, -45.6527, -41.8533];


zetalvl=zeta(541,:,:);
zetalvl=reshape(zetalvl,621,321);
zetalvl=mask.*zetalvl;
cd .. 

%%
% zeta=permute(zeta,[2,3,1]);
% close all
ax=figure('Units','characters','Position',[-175.4000   -0.9231  174.8000   77.4615])

m_proj('miller','long',[-78 -72],'lat',[-46.9 -41]);
m_pcolor(lon,lat,zetalvl); shading interp; colormap([m_colmap('blues',64)])
hold on

% m_gshhs_f('color',[.9 .9 .9]);

m_grid('box','fancy','tickdir','in','backcolor',[0.8 0.8 0.8],'xtick',4,'ytick',6,'fontsize',30);


for i=1:4
        m_line(lonBGQ(i),latBGQ(i),'marker','d','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);
end

 m_line(lonBGQ(5),latBGQ(5),'marker','d','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);

 m_line(lonBGQ(6)+0.05,latBGQ(6)-0.06,'marker','o','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]); 

 for i=7:length(lonBGQ)
        m_line(lonBGQ(i),latBGQ(i),'marker','o','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]); 
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:5
    m_text(lonBGQ(i)+0.05,latBGQ(i),{num2str(i)},'FontSize',12,'FontWeight',	'bold')
end


m_text(lonBGQ(6)+0.1,latBGQ(6)-0.06,{num2str(6)},'FontSize',12,'FontWeight',	'bold')

for i=7:9
    m_text(lonBGQ(i)+0.05,latBGQ(i),{num2str(i)},'FontSize',12,'FontWeight',	'bold')
end

for i=10:14
        m_text(lonBGQ(i)+0.05,latBGQ(i),{num2str(i)},'FontSize',12,'FontWeight',	'bold')     
end

m_text(lonBGQ(15),latBGQ(15)+0.06,{num2str(15)},'FontSize',12,'FontWeight',	'bold')




 m_line(-73,-46.7,'marker','o','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);
  m_text(-72.8,-46.7,{'ADCP'},'FontSize',12,'FontWeight',	'bold')

  m_line(-73,-46.5,'marker','d','color',[0.4196 0.1137 0.0706],'linewi',1.5,...
          'linest','none','markersize',6,'markerfacecolor',[1 0.6902 0.0706]);
  m_text(-72.8,-46.5,{'Sea level'},'FontSize',12,'FontWeight',	'bold')


 m_text(-77.8, -41.2,{'1. Ancud'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -41.45,{'2. Puerto Montt'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -41.7,{'3. Castro'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -41.95,{'4. Melinka'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -42.2,{'5. Chacabuco'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -42.45,{'6. Manao'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -42.7,{'7. Quemada island'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -42.95,{'8. Luz island'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -43.2,{'9. Mitahues island'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -43.45,{'10. Puerto Gaviota'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -43.7,{'11. Playas Blancas'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -43.95,{'12. Jesus island'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -44.2,{'13. Sin Nombre islets'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -44.45,{'14. Humos island'},'FontSize',16,'FontWeight',	'bold')
 m_text(-77.8, -44.7,{'15. Chacao channel'},'FontSize',16,'FontWeight',	'bold')

hcb = colorbar;
hcb.Title
hcb.Title.String = "[m]";

hcb.Label.FontSize=16;
hcb.Label.FontWeight="bold";
hcb.LineWidth=1.5;
hcb.FontSize=20;

    set(gca,'color',[.0 .0 1]);     % Trick is to set this *before* the patch call.

%%
% REEVISAR ESTO
% figure
%   m_proj('miller','lat',[-75 75]);
%     
%     set(gca,'color',[.0 .0 1]);     % Trick is to set this *before* the patch call.
%     
%     m_coast('patch',[.7 1 .7],'edgecolor','none');
%     m_grid('box','fancy','linestyle','none');
%        
%     cities={'Cairo','Washington','Buenos Aires'};
%     lons=[ 30+2/60  -77-2/60   -58-22/60];
%     lats=[ 31+21/60  38+53/60  -34-45/60];
%     
%     for k=1:3,
%       [range,ln,lt]=m_lldist([-123-6/60 lons(k)],[49+13/60  lats(k)],40);
%       m_line(ln,lt,'color','r','linewi',2);
%       m_text(ln(end),lt(end),sprintf('%s - %d km',cities{k},round(range)));
%     end;
%       
%     title('Great Circle Routes','fontsize',14,'fontweight','bold');