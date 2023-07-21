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
rwp=0;

% Number of LEDS
NLED=8;

[outputTotalPowerLoS,~,outputTotalPowerNLoS,~] = Model3(type,lamda,simulation,centers,NLED,r,1,rwp);
outputTotalPower=outputTotalPowerLoS+outputTotalPowerNLoS;


dB=0;

if dB==1
    P_dB_all=10*log10(outputTotalPower);
    P_dB_LoS=10*log10(outputTotalPowerLoS);
    P_dB_NLoS=10*log10(outputTotalPowerNLoS);

    figure
    surfc(x,y,P_dB_all');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P_dB_all)) max(max(P_dB_all))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('Total Received Power (dBm)')

    figure
    surfc(x,y,P_dB_LoS');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P_dB_LoS)) max(max(P_dB_LoS))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('LoS Received Power (dBm)')

    figure
    surfc(x,y,P_dB_NLoS');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P_dB_NLoS)) max(max(P_dB_NLoS))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('NLoS Received Power (dBm)')
else
    figure
    surfc(x,y,outputTotalPower');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(outputTotalPower)) max(max(outputTotalPower))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('Total Received Power (mW)')

    figure
    surfc(x,y,outputTotalPowerLoS');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(outputTotalPowerLoS)) max(max(outputTotalPowerLoS))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('LoS Received Power (mW)')

    figure
    surfc(x,y,outputTotalPowerNLoS');
    rotate3d on
    axis([-lx/2 lx/2 -ly/2 ly/2 min(min(outputTotalPowerNLoS)) max(max(outputTotalPowerNLoS))]);
    ylabel('length (m)')
    xlabel('width (m)')
    zlabel('NLoS Received Power (mW)')
end