start
clear all
addpath('D:\OneDrive\Documents\AAMagister\Ancud\20210102');

  tided='ancud_bench_ver.nc'; 
hisfile='mosa_BGQ_his_M1_1h_WD_20210102.nc'; 

ex_tide='USIPA_BGQ';

for i=1:649
    [lat,lon,mask,zeta(:,:,i)]=get_var(hisfile,[],['zeta'],i+72,-1,1,[0 0 0 0]); %   USAR ESTA EXTRACCIÓN DE VARIABLES
%     [~,~,~,v(:,:,i)]=get_var(hisfile,[],['vbar'],i+72,-1,1,[0 0 0 0]); 
%     [~,~,~,u(:,:,i)]=get_var(hisfile,[],['ubar'],i+72,-1,1,[0 0 0 0]); 

end  

% [lat,lon,mask,zeta(:,:,i)]=get_var(hisfile,[],['zeta'],1,-1,1,[0 0 0 0]); %   para tener el lat_rho y lon_rho

% for i=1:size(u,3)
%     ubar(:,:,i)=u2rho_2d(u(:,:,i));
%     vbar(:,:,i)=v2rho_2d(v(:,:,i));
% end

staBGQ=['Ancud       ';'Puerto_Montt';'Castro      ';'Melinka     ';'CHACA       ';'DARWI       ';'ERRAZ       ';'ERRAZ_darwin';...
    'GAVIO       ';'MENIN       ';'PESUR       ';'PULEL       ';'SNAME       ';'VICUN       ';'Chacabuco   '];
lonBGQ=[-73.8171,-72.9268,-73.6981,-73.7188,-73.4887, -74.0819, -73.8121, -73.7192, -73.4183,-73.6753, -73.7950, -73.4921, -73.8544, -74.1281, -72.8457];
latBGQ=[-41.8564,-41.4998,-42.5821,-43.8396,-41.8702, -45.4060, -45.5968, -45.3967, -44.9287, -45.2407,-44.7430, -41.8533, -44.0142, -45.6527, -45.4215];

%%
load('sl_ancu.mat');

nvl = reshape(depth(2:end), 60, []);
sla = mean(nvl);

skipindx=1;

for i=1:1

        ininm=1;
	for nm=skipindx:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end
end

[pos1,a,TIDECON1,b]=t_tide(sla,'output','none'); % M2 fila 11, S2 fila 12
[pos2,c,TIDECON2,d]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('sl_pmon.mat')

nvl = reshape(depth(2:end), 60, []);
sla = mean(nvl);

for i=2:2%size(lonBGQ,2)

        ininm=1;
	for nm=skipindx:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos3,e,TIDECON3,f]=t_tide(sla,'output','none'); % M2 fila 11, S2 fila 12
[pos4,g,TIDECON4,h]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('sl_cast.mat')

nvl = reshape(depth(2:end), 60, []);
sla = mean(nvl);

for i=3:3%size(lonBGQ,2)

        ininm=1;
	for nm=skipindx:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos5,i,TIDECON5,j]=t_tide(sla,'output','none'); % M2 fila 11, S2 fila 12
[pos6,k,TIDECON6,k]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('sl_pmel.mat')

nvl = reshape(depth(2:end), 60, []);
sla = mean(nvl);

for i=4:4%size(lonBGQ,2)

        ininm=1;
	for nm=skipindx:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos7,l,TIDECON7,m]=t_tide(sla,'output','none'); % M2 fila 11, S2 fila 12
[pos8,n,TIDECON8,o]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5

% 
load('CHACA000.mat')
p=adcp_pro.pressure;
p2=p(3:end-2)-mean(p(3:end-2));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=5:5%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos9,p,TIDECON9,q]=t_tide(sla,'output','none'); % M2 fila 4, S2 5
[pos10,r,TIDECON10,s]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('DARWI000.mat')
p=adcp_pro.pressure;
p2=p(3:end-2)-mean(p(3:end-2));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=6:6%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end   
end

[pos11,t,TIDECON11,u]=t_tide(sla,'output','none'); % M2 fila 15, S2 fila 17
[pos12,v,TIDECON12,w]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('ERRAZ000.mat')

p=adcp_pro.pressure;
p2=p(6:end-8)-mean(p(6:end-8));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=7:7%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos13,x,TIDECON13,y]=t_tide(sla,'output','none'); % M2 fila 15, S2 17
[pos14,z,TIDECON14,a1]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('ERRAZ_darwin000.mat')

p=adcp_pro.pressure;
p2=p(4:end)-mean(p(4:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=8:8%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos15,b1,TIDECON15,c1]=t_tide(sla,'output','none'); % M2 fila 11, S2 12
[pos16,d1,TIDECON16,e1]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('GAVIO000.mat')

p=adcp_pro.pressure;
p2=p(2:end)-mean(p(2:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=9:9%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos19,j1,TIDECON19,k1]=t_tide(sla,'output','none'); % M2 fila 15, S2 17
[pos20,l1,TIDECON20,m1]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('MENIN000.mat')

p=adcp_pro.pressure;
p2=p(1:end)-mean(p(1:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=10:10%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos21,n1,TIDECON21,o1]=t_tide(sla,'output','none'); % M2 fila 11, S2 12
[pos22,p1,TIDECON22,q1]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('PESUR000.mat')

p=adcp_pro.pressure;
p2=p(6:end)-mean(p(6:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=11:11%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos23,r1,TIDECON23,s1]=t_tide(sla,'output','none'); % M2 fila 15, S2 17
[pos24,t1,TIDECON24,u1]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('PULEL000.mat')

p=adcp_pro.pressure;
p2=p(3:end)-mean(p(3:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

[pos25,v1,TIDECON25,w1]=t_tide(sla,'output','none'); % M2 fila 4, S2 5
[pos26,x1,TIDECON26,y1]=t_tide(zeta(470,261,:),'output','none'); % M2 fila 4, S2 fila 5
%
load('SNAME000.mat')

p=adcp_pro.pressure;
p2=p(4:end)-mean(p(4:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=13:13%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos27,z1,TIDECON27,a2]=t_tide(sla,'output','none'); % M2 fila 15, S2 17
[pos28,b2,TIDECON28,c2]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('VICUN000.mat')

p=adcp_pro.pressure;
p2=p(2:end)-mean(p(2:end));
depth=p2/1013.25;

nvl = reshape(depth(1:end), 6, []);
sla = mean(nvl);

for i=14:14%size(lonBGQ,2)

        ininm=1;
	for nm=1:size(zeta,3)
	    ssh(ininm)=griddata(lon,lat,squeeze(zeta(:,:,nm)),lonBGQ(i),latBGQ(i));
        ininm=ininm+1;
    end 
end

[pos29,d2,TIDECON29,e2]=t_tide(sla,'output','none'); % M2 fila 15, S2 17
[pos30,f2,TIDECON30,g2]=t_tide(ssh,'output','none'); % M2 fila 4, S2 fila 5
% 
load('sl_pcha.mat')
nvl = reshape(depth(56:end), 60, []);
sla = mean(nvl);

[pos31,h2,TIDECON31,i2]=t_tide(sla,'output','none'); % M2 fila 11, S2 fila 12
[pos32,j2,TIDECON32,k2]=t_tide(zeta(274,287,:),'output','none'); % M2 fila 4, S2 fila 5


A=[TIDECON1(11,1),TIDECON3(11,1),TIDECON5(11,1),TIDECON7(11,1),TIDECON9(4,1),TIDECON11(15,1),TIDECON13(15,1),TIDECON15(11,1),TIDECON19(15,1),TIDECON21(11,1),TIDECON23(15,1),TIDECON25(4,1),TIDECON27(15,1),TIDECON29(15,1),TIDECON31(11,1)];
% DATO
B=[TIDECON2(4,1),TIDECON4(4,1),TIDECON6(4,1),TIDECON8(4,1),TIDECON10(4,1),TIDECON12(4,1),TIDECON14(4,1),TIDECON16(4,1),TIDECON20(4,1),TIDECON22(4,1),TIDECON24(4,1),TIDECON26(4,1),TIDECON28(4,1),TIDECON30(4,1),TIDECON32(4,1)];
% MODELO
C=[TIDECON1(12,1),TIDECON3(12,1),TIDECON5(12,1),TIDECON7(12,1),TIDECON9(5,1),TIDECON11(17,1),TIDECON13(17,1),TIDECON15(12,1),TIDECON19(17,1),TIDECON21(12,1),TIDECON23(17,1),TIDECON25(5,1),TIDECON27(17,1),TIDECON29(17,1),TIDECON31(12,1)];
% DATO
D=[TIDECON2(5,1),TIDECON4(5,1),TIDECON6(5,1),TIDECON8(5,1),TIDECON10(5,1),TIDECON12(5,1),TIDECON14(5,1),TIDECON16(5,1),TIDECON20(5,1),TIDECON22(5,1),TIDECON24(5,1),TIDECON26(5,1),TIDECON28(5,1),TIDECON30(5,1),TIDECON32(5,1)];
% MODELO

dlmwrite('A.txt', A, ' ');
dlmwrite('B.txt', B, ' ');
dlmwrite('C.txt', C, ' ');
dlmwrite('D.txt', D, ' ');
%% Velocidades

% load('PULEL000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(3:end), 6, []);
% sla = mean(nvl);
% [Au,~,Bu,~]=t_tide(ubar(470,261,:),'output','none'); 
% [Cu,~,Du,~]=t_tide(sla,'output','none'); 
%%
% load('CHACA000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(5:end), 6, []);
% sla = mean(nvl);
% % 
% % for i=5:5
% % 
% %         ininm=1;
% % 	for nm=1:size(ubar,3)
% % 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
% %         ininm=ininm+1;
% %     end 
% % end
% 
% [Eu,~,Fu,~]=t_tide(ubar(470,262,:),'output','none'); % t_tide(ssh,'output','none'); 
% [Gu,~,Hu,~]=t_tide(sla,'output','none'); 

% load('DARWI000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(5:end), 6, []);
% sla = mean(nvl);
% % 
% % for i=6:6
% % 
% %         ininm=1;
% % 	for nm=1:size(ubar,3)
% % 	    ssh(ininm)=griddata(lonu,latu,squeeze(u(:,:,nm)),lonBGQ(i),latBGQ(i));
% %         ininm=ininm+1;
% %     end   
% % end
% 
% [Iu,~,Ju,~]=t_tide(ubar(274,237,:),'output','none'); 
% [Ku,~,Lu,~]=t_tide(sla,'output','none'); 
%%
% load('ERRAZ000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% % 
% % for i=7:7
% % 
% %         ininm=1;
% % 	for nm=1:size(ubar,3)
% % 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
% %         ininm=ininm+1;
% %     end 
% % end
% 
% % [Mu,~,Nu,~]=t_tide(ssh,'output','none'); 
% [Mu,~,Nu,~]=t_tide(ubar(263,248,:),'output','none');
% [Ou,~,Pu,~]=t_tide(sla,'output','none'); 
%%
% load('ERRAZ_darwin000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=8:8
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [Qu,~,Ru,~]=t_tide(ssh,'output','none'); 
% [Su,~,Tu,~]=t_tide(sla,'output','none'); 

%%
% load('GAVIO000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% 
%  for i=9:9
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
%  end
% 
% [Uu,~,Vu,~]=t_tide(ssh,'output','none'); 
% [Wu,~,Xu,~]=t_tide(sla,'output','none'); 

%%
% load('MENIN000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(1:end), 6, []);
% sla = mean(nvl);
% 
% for i=10:10
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% % [Yu,~,Zu,~]=t_tide(ssh,'output','none'); 
% [Yu,~,Zu,~]=t_tide(ubar(284,254,:),'output','none'); 
% [AAu,~,BBu,~]=t_tide(sla,'output','none'); 
% 

%%
% load('PESUR000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(6:end), 6, []);
% sla = mean(nvl);
% 
% for i=11:11
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [CCu,~,DDu,~]=t_tide(ssh,'output','none'); 
% [EEu,~,FFu,~]=t_tide(sla,'output','none'); 
% 

% load('SNAME000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=13:13
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [GGu,~,HHu,~]=t_tide(ssh,'output','none'); 
% [IIu,~,JJu,~]=t_tide(sla,'output','none'); 

% load('VICUN000.mat')
% UI=mean(adcp_pro.ui);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% 
% for i=14:14
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(ubar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [KKu,~,LLu,~]=t_tide(ssh,'output','none'); 
% [MMu,~,NNu,~]=t_tide(sla,'output','none'); 
% 
% 
% 
% M2u   =[Du(4,1); Hu(4,1); Lu(15,1); Pu(15,1); Tu(11,1); Xu(15:1); BBu(11,1); FFu(15,1); JJu(15,1); NNu(15,1)];
% M2ubar=[Bu(4,1); Fu(4,1); Ju(4,1);  Nu(4,1);  Ru(4,1);  Vu(4:1);  Zu(4,1);   DDu(4,1);  HHu(4,1);  LLu(4,1)];
% S2u   =[Du(5,1); Hu(5,1); Lu(17,1); Pu(17,1); Tu(12,1); Xu(17:1); BBu(12,1); FFu(17,1); JJu(17,1); NNu(17,1)];
% S2ubar=[Bu(5,1); Fu(5,1); Ju(5,1);  Nu(5,1);  Ru(5,1);  Vu(5:1);  Zu(5,1);   DDu(5,1);  HHu(5,1);  LLu(5,1)];



%%
% load('PULEL000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(3:end), 6, []);
% sla = mean(nvl);
% [Av,~,Bv,~]=t_tide(vbar(471,262,:),'output','none'); 
% [Cv,~,Dv,~]=t_tide(sla,'output','none'); 
% %%
% load('CHACA000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(5:end), 6, []);
% sla = mean(nvl);
% 
% % for i=5:5
% %         ininm=1;
% % 	for nm=1:size(vbar,3)
% % 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
% %         ininm=ininm+1;
% %     end 
% % end
% 
% [Ev,~,Fv,~]=t_tide(vbar(470,262,:),'output','none'); % t_tide(ssh,'output','none'); 
% [Gv,~,Hv,~]=t_tide(sla,'output','none'); 
% 
% %%
% load('DARWI000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(5:end), 6, []);
% sla = mean(nvl);
% 
% % for i=6:6
% % 
% %         ininm=1;
% % 	for nm=1:size(vbar,3)
% % 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
% %         ininm=ininm+1;
% %     end   
% % end
% 
% [Iv,~,Jv,~]=t_tide(vbar(274,238,:),'output','none'); 
% [Kv,~,Lv,~]=t_tide(sla,'output','none'); 
% %%
% load('ERRAZ000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% 
% for i=7:7
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [Mv,~,Nv,~]=t_tide(ssh,'output','none'); 
% [Ov,~,Pv,~]=t_tide(sla,'output','none'); 
% 
% load('ERRAZ_darwin000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=8:8
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [Qv,~,Rv,~]=t_tide(ssh,'output','none'); 
% [Sv,~,Tv,~]=t_tide(sla,'output','none'); 
% 
% load('GAVIO000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% 
%  for i=9:9
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
%  end
% 
% [Uv,~,Vv,~]=t_tide(ssh,'output','none'); 
% [Wv,~,Xv,~]=t_tide(sla,'output','none'); 
% 
% load('MENIN000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(1:end), 6, []);
% sla = mean(nvl);
% 
% for i=10:10
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [Yv,~,Zv,~]=t_tide(ssh,'output','none'); 
% [AAv,~,BBv,~]=t_tide(sla,'output','none'); 
%   
% load('PESUR000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(6:end), 6, []);
% sla = mean(nvl);
% 
% for i=11:11
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [CCv,~,DDv,~]=t_tide(ssh,'output','none'); 
% [EEv,~,FFv,~]=t_tide(sla,'output','none'); 
% 
% load('SNAME000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=13:13
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [GGv,~,HHv,~]=t_tide(ssh,'output','none'); 
% [IIv,~,JJv,~]=t_tide(sla,'output','none'); 
% 
% load('VICUN000.mat')
% UI=mean(adcp_pro.vi);
% nvl = reshape(UI(2:end), 6, []);
% sla = mean(nvl);
% 
% for i=14:14
% 
%         ininm=1;
% 	for nm=1:size(vbar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vbar(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [KKv,~,LLv,~]=t_tide(ssh,'output','none'); 
% [MMv,~,NNv,~]=t_tide(sla,'output','none'); 

%% VELOCIDADES CON SQRT
% vel=sqrt(ubar.^2+vbar.^2);
% 
% load('CHACA000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(5:end), 6, []);
% sla = mean(nvl);
% 
% [pos1,~,A,~]=t_tide(vel(470,262,:),'output','none'); % t_tide(ssh,'output','none'); 
% [pos2,~,B,~]=t_tide(sla,'output','none');  
% 
% load('DARWI000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(5:end), 6, []);
% sla = mean(nvl);
% 
% [pos3,~,C,~]=t_tide(vel(274,237,:),'output','none'); 
% [pos4,~,D,~]=t_tide(sla,'output','none'); 
% 
% load('ERRAZ000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(2:end), 6, []);
% sla = mean(nvl);
% 
% [pos5,~,E,~]=t_tide(vel(263,248,:),'output','none');
% [pos6,~,F,~]=t_tide(sla,'output','none'); 
% 
% load('ERRAZ_darwin000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=8:8
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vel(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [pos7,~,G,~]=t_tide(ssh,'output','none'); 
% [pos8,~,H,~]=t_tide(sla,'output','none'); 
% 
% load('GAVIO000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(2:end), 6, []);
% sla = mean(nvl);
% 
%  for i=9:9
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vel(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
%  end
% 
% [pos9,~,I,~]=t_tide(ssh,'output','none'); 
% [pos10,~,J,~]=t_tide(sla,'output','none'); 
% 
% load('MENIN000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(1:end), 6, []);
% sla = mean(nvl);
% [pos11,~,K,~]=t_tide(vel(284,254,:),'output','none'); 
% [pos12,~,L,~]=t_tide(sla,'output','none'); 
% 
% load('PESUR000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(6:end), 6, []);
% sla = mean(nvl);
% 
% for i=11:11
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vel(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [pos13,~,M,~]=t_tide(ssh,'output','none'); 
% [pos14,~,N,~]=t_tide(sla,'output','none'); 
% 
% load('PULEL000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(3:end), 6, []);
% sla = mean(nvl);
% %%
% [pos15,~,O,~]=t_tide(vel(470,262,:),'output','none'); 
% [pos16,~,P,~]=t_tide(sla,'output','none'); 
% 
% load('SNAME000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(4:end), 6, []);
% sla = mean(nvl);
% 
% for i=13:13
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vel(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% [pos17,~,Q,~]=t_tide(ssh,'output','none'); 
% [pos18,~,R,~]=t_tide(sla,'output','none'); 
% 
% %%
% 
% load('VICUN000.mat')
% UI=mean(adcp_pro.ui);
% VI=mean(adcp_pro.vi);
% VEL=sqrt(UI.^2+VI.^2);
% nvl = reshape(VEL(2:end), 6, []);
% sla = mean(nvl);
% 
% for i=14:14
% 
%         ininm=1;
% 	for nm=1:size(ubar,3)
% 	    ssh(ininm)=griddata(lon,lat,squeeze(vel(:,:,nm)),lonBGQ(i),latBGQ(i));
%         ininm=ininm+1;
%     end 
% end
% 
% [pos19,~,T,~]=t_tide(ssh,'output','none'); 
% [pos20,~,U,~]=t_tide(sla,'output','none'); 
% 
% %%
% 
% M2bar=[A(4,1), C(4,1), E(4,1), G(4,1), I(4,1), K(4,1), M(4,1), O(4,1), Q(4,1), T(4,1)];
% S2bar=[A(5,1), C(5,1), E(5,1), G(5,1), I(5,1), K(5,1), M(5,1), O(5,1), Q(5,1), T(5,1)];
% 
% M2vel=[B(4,1), D(15,1),F(15,1),H(11,1),J(15,1),L(11,1),N(15,1),P(4,1), R(15,1),U(15,1)];
% S2vel=[B(5,1), D(17,1),F(17,1),H(12,1),J(17,1),L(12,1),N(17,1),P(5,1), R(17,1),U(17,1)];