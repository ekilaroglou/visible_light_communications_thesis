addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% theoretical
simulation=0;

% choose r1 radius
r=r1;

% lamda is number of blockages
type=3;
% number of blockages
lamda=0;

centers=0;
%centers = SimulatePoissonProcess(type,lamda,lx,ly,r,0);
NLED=4;
% follow the paper
paper=0;

[outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,1,paper);

% P=outputTotalPower;
% sigma=2*e*R*P*Bs+2*e*I_bg*I2*Bs;
% SNR=(P./sigma).^2;
% outputTotalPower=SNR;

P__dB=10*log10(outputTotalPower);
figure
surfc(x,y,P__dB');
rotate3d on
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P__dB')) max(max(P__dB'))]);
% axis([-lx/2 lx/2 -ly/2 ly/2 -9 max(max(P__dB))]);