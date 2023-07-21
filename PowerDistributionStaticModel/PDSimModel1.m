addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
Parameters;

% simulation
simulation=1;

% choose r1 radius
r=r1;
p=1;
rwp=0;
% lamda is number of blockages
type=3;
% number of blockages
lamda=6;
NLED=4;
centers = SimulatePoissonProcess(type,lamda,lx,ly,r,0);


[outputTotalPower,outputPowerVector] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);

P_dB=10*log10(outputTotalPower);
figure
figfin=surfc(x,y,P_dB');
rotate3d on
axis([-lx/2 lx/2 -ly/2 ly/2 -5 max(max(P_dB))]);
% get(figfin);
% set(h,'linestyle','none','facecolor',[0 .7 0]);

[outputTotalPower,outputPowerVector] = Model2(type,lamda,simulation,centers,NLED,r,p,rwp);
figure
surfc(x,y,outputTotalPower)
rotate3d on

P_dB=10*log10(outputTotalPower);
figure
figfin=surfc(x,y,P_dB');
rotate3d on
axis([-lx/2 lx/2 -ly/2 ly/2 -5 max(max(P_dB))]);
% get(figfin);
% set(h,'linestyle','none','facecolor',[0 .7 0]);

% x=0:0.1:1;
% d=pi*(2*r1)^2;
% y=(1-exp(-x*d))/d;
% figure
% plot(x,y);