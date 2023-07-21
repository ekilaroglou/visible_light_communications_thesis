addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% theoretical
simulation=1;
rwp=0;
% choose r1 radius
r=r1;
% lamda is number of blockages
type=3;
% number of blockages
lamda=50;

% centers=0;
plot_centers=1;
centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);

if plot_centers==1
    figure()
    hold on
    grid on
    rotate3d on
    view(3)
    for i=1:size(centers,1)
        cnt=[centers(i,1), centers(i,2)];
        r=centers(i,3);
        height=hB;
        nSides=100;
        color = [1 0 0];
        plotCylinder(r,cnt,height,nSides,color,-lz/2);
    end
    axis([-lx/2 lx/2 -ly/2 ly/2 -lz/2 lz/2]);
end

NLED=8;


[outputTotalPower,~] = Model2(type,lamda,simulation,centers,NLED,r,1,rwp);

P__dB=10*log10(outputTotalPower);
figure
surfc(x,y,P__dB');
rotate3d on
ylabel('length (m)')
xlabel('width (m)')
zlabel('Received Power (dBm)')
% axis([-lx/2 lx/2 -ly/2 ly/2 min(min(P__dB)) max(max(P__dB))]);
axis([-lx/2 lx/2 -ly/2 ly/2 -4.345 max(max(P__dB))]);

figure
surfc(x,y,outputTotalPower');
rotate3d on
ylabel('length (m)')
xlabel('width (m)')
zlabel('Received Power (mW)')
axis([-lx/2 lx/2 -ly/2 ly/2 min(min(outputTotalPower)) max(max(outputTotalPower))]);

function [h1, h2, h3] = plotCylinder(r,cnt,height,nSides,color,z0)
[X,Y,Z] = cylinder(r,nSides);
X = X + cnt(1); 
Y = Y + cnt(2); 
Z = Z * height+z0; 
h1 = surf(X,Y,Z,'facecolor',color,'LineStyle','none');
h2 = fill3(X(1,:),Y(1,:),Z(1,:),color);
h3 = fill3(X(2,:),Y(2,:),Z(2,:),color);
end  