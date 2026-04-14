% [ARCLEN, AZ] = distance(LAT1,LON1,LAT2,LON2clear all; 
close all; 
clc;
start

cd 20210102\
tided='mosa_BGQ_his_M1_1h_WD_20210102.nc';  
ex_tide='USIPA_BGQ';


nc=netcdf(tided,'nowrite'); 
lon=nc{'lon_rho'}(:); 
lat=nc{'lat_rho'}(:);
 
zeta=nc{'zeta'}(:); 
mask=nc{'mask_rho'}(:); 
mask(find(mask==0))=nan;
%%zeta_m=nc{'zeta'}.scale_factor(:);
%%zeta_n=nc{'zeta'}.add_offset(:);
%%zeta = zeta*zeta_m + zeta_n;

%tim=nc{'scrum_time'}(:);
 
tim=nc{'time'}(:);
tim=tim-tim(1);




% Extraer senal de marea en la posicion,
%        
%            1               2             3            4              5       
%
staBGQ=['Ancud       ';'Puerto_Montt';'Castro      ';'Melinka     ';'Chacabuco   ';'CHACA       '];
% staBGQ=['CHACA       ';'DARWI       ';'ERRAZ       ';'ERRAZ_darwin';'GARAO       ';...
%     'GAVIO       ';'MENIN       ';'PESUR       ';'PULEL       ';'SNAME       ';...
%     'VICUN       '];
lonBGQ=[-73.8171,-72.9268,-73.6981,-73.7188,-72.8457,-73.4887];
% lonBGQ=[-73.4887, -74.0819, -73.8121, -73.7192, -73.7882, -73.4183,...
%     -73.6753, -73.7950, -73.4921, -73.8544, -74.1281];
latBGQ=[-41.8564,-41.4998,-42.5821,-43.8396,-45.4215,-41.8702];
% latBGQ=[-41.8702, -45.4060, -45.5968, -45.3967, -44.3873, -44.9287, -45.2407,...
%     -44.7430, -41.8533, -44.0142, -45.6527];


%%
distancud=distance(-73.833057,	-41.867399,lon,lat);
[i j]=find(distancud==min(min(distancud)))
%%

data_hourly = reshape(depth(1:43200), 60, []);
hourly_mean = mean(data_hourly, 1)';
%%
hancud=prs-mean(prs);

figure
subplot(211)
plot(1:721,zeta(:,471,248),LineWidth=2)
hold on
plot(1:721,hancud(1:60:43260),LineWidth=2)
legend('modelo','datos ioc')
title('ancud')
subplot(212)
plot(1:721,zeta(:,471,248),LineWidth=2)
hold on
plot(1:720,hourly_mean,LineWidth=2)
legend('modelo','datos usipa')
