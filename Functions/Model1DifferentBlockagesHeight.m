function [outputTotalPower,outputPowerVector] = Model1DifferentBlockagesHeight(type,lamda,simulation,centers,NLED,r,p,rwp,blockage_height)
% Get the output total Power and each led output power in outputPowerVector
% using Integrating-sphere model with Simulation or Theoretical approach

% INPUTS
% type: determines the type of "lamda" input
%       1: lamda is the intensity of the parent poisson process
%       2: lamda is the blockage intensity (after thinned process)
%       3: lamda is the total number of blockages
% lamda: intensity or number of blockages, depends on type
% simulation: use 0 for theoretical approach
% centers: array with position and radius of human-disks 
%          in x-y plane. Needed only in simulation
% NLED: Number of LEDS, in this study 4 or 8
% r: radius of humans, if it's more than one then it's an array
% p: if there's 2 types of humans (2 different radius
%    corresponding to them) then the propability of each radius
% rwp: takes value 1 for Random Waypoint Model
%      takes value 0 for Poisson Process

% check if we have maximum 2 different radius
if length(r)>2
    fprintf('too many different r for this algorithm');
    return
end

% Initiallize basic parameters
Parameters;
hB=blockage_height;

% Find LED positions
TP_all=FindLEDPositions2(x,y,NLED);
if NLED==9
    NLED=8;
end
% LED individual power
Pled=P_LED_Total/NLED;

if simulation==0
    %% Theoretical approach

    % Area on receiver/transmitter plane
    if length(r)==1
        V=(lx-2*r)*(ly-2*r);
    else
        V=p(1)*(lx-2*r(1))*(ly-2*r(1))+p(2)*(lx-2*r(2))*(ly-2*r(2));
    end
    % lamda should be blockage intensity
    lamda=FindLamdaBlockage(type,lamda,r,p,V,0);
end

% Matrix containing P for each LED
P_all=zeros(Nx,Ny,NLED);
    
% for each LED
for tr=1:NLED
% Transmitter positions
TP=[TP_all(tr,1) TP_all(tr,2) lz/2];
H0=zeros(Nx,Ny);
% For each receiver position
for ii=1:Nx
for jj=1:Ny
% Receiver Position Vector
RP=[x(ii) y(jj) -lz/2]; 
% distance from the source
D=sqrt(dot(TP-RP,TP-RP));
% dT=sqrt((TP(1)-RP(1))^2+(TP(2)-RP(2))^2);
%h=abs(TP(3)-RP(3));
% angle between transitter and receiver
cosphi=h/D;
receiver_angle=acosd(cosphi);
% Channel gain
if abs(receiver_angle)<=FOV
    % the channel DC gain for source 1
    H0(ii,jj)=(m+1)*Adet.*cosphi.^(m+1)./(2*pi.*D.^2);
    if simulation~=0
        if isBlocked(centers,TP,RP,hB)==1
            notBlock=0;
        else
            notBlock=1;
        end
    else
        notBlock=FindNonBlockageProbability(lamda,TP,RP,lx,r,hT,hB,rwp);
    end
    H0(ii,jj)=H0(ii,jj)*notBlock;
end
end
end
% received power from source
%P=Pled*(H0+2*(lz*ly+lz*lx)*H_DIFF);
P=Pled.*H0.*Ts.*G_Con;
P_all(:,:,tr)=P;
end
outputTotalPower=sum(P_all,3);
outputPowerVector=P_all;
end

