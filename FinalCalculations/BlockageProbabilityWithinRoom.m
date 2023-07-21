addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% choose r1 radius
r=r1;
rwp=0;
% lamda is number of blockages
type=3;
plot_centers=0;

lamda=6;
N_Simulation=1e5;
NLED=8;

hasLosLink=zeros(Nx,Ny);
for i=1:N_Simulation
    centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);
    hasLosLink=hasLosLink+CheckLosLink(NLED,centers);
end
hasLosLink=hasLosLink/N_Simulation;
blockageProb=1-hasLosLink;

figure
surfc(x,y,hasLosLink');
rotate3d on
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(hasLosLink)) 1]);

figure
surfc(x,y,blockageProb');
rotate3d on
axis([-lx/2 lx/2 -ly/2 ly/2 0 max(max(blockageProb))]);


