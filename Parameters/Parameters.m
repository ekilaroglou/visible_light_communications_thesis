%% Parameters
% clear
% clc
theta=60;
% the semi-angle at half power
m=-log10(2)/log10(cosd(theta));
% Lambertian order of emission
P_LED_Total=219e3;
% LED Transmitted Power
n=1.5;
% Refractive Index
Ts=1;
% Optical Filter Gain
rho=0.8;
% Wall Reflection
phi=60;
% LED Irradiance Angle
hR=0.85;
% Receiver plane above the floor
Adet=1e-4;
% Receiver Active Area
FOV=60;
% Field Of View of Receiver
r1=0.2;
r2=0.4;
% Blockage Radius
hB=1.8;
% Height of the Blockage
hT=3;
% Height of the Transmitter/Room
R=0.5;
% Photodetector Responsivity
Bs=10e6;
% Signal Bandwith
I2=0.562;
% Noise Bandwith Factor
Ibg=100e-6;
% Background Current
G_Con=(n^2)/(sind(FOV).^2);
% NLED=4;
% Pled=P_all/NLED;

%% Room size and spacing
lx=5; ly=5; lz=hT-hR;
h=lz;
% Transmitter and Blockage height with respect to receiver
hT=hT-hR;
hB=hB-hR;
% the room dimensions all in meter
resolution=5;
Nx=lx*resolution; Ny=ly*resolution; Nz=round(lz*resolution); 
% the number of grid in each surface
dA=lz*ly/((Ny)*(Nz));
% calculating the grid area
x=linspace(-lx/2,lx/2,Nx);
y=linspace(-ly/2,ly/2,Ny);
z=linspace(-lz/2,lz/2,Nz);