function [outputTotalPowerLoS,outputPowerVectorLoS,outputTotalPowerNLoS,outputPowerVectorNLoS] = Model3(type,lamda,simulation,centers,NLED,r,p,rwp)
% Get the output total Power and each led output power in outputPowerVector
% using Visible light communication channel model propose by Lee et al.
% with Simulation or Theoretical approach

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

% Find LED positions
TP_all=FindLEDPositions2(x,y,NLED);
% LED individual power
Pled=P_LED_Total/NLED;

if simulation==0
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
P_all_los=zeros(Nx,Ny,NLED);
P_all_nlos=zeros(Nx,Ny,NLED);

% for each LED
for tr=1:NLED
% Transmitter positions
TP=[TP_all(tr,1) TP_all(tr,2) lz/2];
Hlos=zeros(Nx,Ny);
Hnlos=zeros(Nx,Ny);
% For each receiver position
for ii=1:Nx
for jj=1:Ny
% Receiver Position Vector
RP=[x(ii) y(jj) -lz/2]; 

%% LOS LINK
% distance from the source
D=sqrt(dot(TP-RP,TP-RP));
%h=abs(TP(3)-RP(3));
% angle between transitter and receiver
cosphi= h/D;
receiver_angle=acosd(cosphi);
% channel gain is 0 for angles greater than FOV
if abs(receiver_angle)<=FOV
    % Channel gain
    h_toAdd=(m+1)*Adet*cosphi^(m+1)/(2*pi.*D.^2);
    % on simulation check if the signal is blocked
    if simulation~=0
        if isBlocked(centers,TP,RP,hB)==1
            notBlock=0;
        else
            notBlock=1;
        end
    else
        notBlock=FindNonBlockageProbability(lamda,TP,RP,lx,r,hT,hB,rwp);
    end
    % multiply the channel gain with the non-block probability
    h_toAdd=h_toAdd*notBlock;
    Hlos(ii,jj)=Hlos(ii,jj)+h_toAdd;
end

%% DIFFUSE LINK
% Wall point values
WP_all=[-lx/2 lx/2 -ly/2 ly/2];

for wp=1:length(WP_all)
% find dimension
% dim=1 means wall point on y-z axis (x=-lx/2 or x=lx/2)
% dim=2 means wall point on x-z axis
if wp/2<=1
    dim=1;
    Nxy=Ny;
else
    dim=2;
    Nxy=Nx;
end

% wall point value
WP_value=WP_all(wp);
    
for kk=1:Nxy
for ll=1:Nz
    % Wall point
    if dim==1
        WP=[WP_value y(kk) z(ll)];
    else
        WP=[x(kk) WP_value z(ll)];
    end
    % distance between source and wall point
    D1=sqrt(dot(TP-WP,TP-WP));
    % transmitance angle between transitter and wall point
    cos_phi= abs(WP(3)-TP(3))/D1;
    % receiver angle between transitter and wall point
    cos_alpha = abs(TP(dim)-WP(dim))/D1;
    % distance between wall point and receiver
    D2=sqrt(dot(WP-RP,WP-RP));
    % transmitance angle between wall point and receiver
    cos_beta=abs(WP(dim)-RP(dim))/D2;
    % receiver angle between wall point and receiver
    cos_psi=abs(WP(3)-RP(3))/D2;
    
    % channel gain is 0 for angles greater than FOV
    if abs(acosd(cos_psi))<=FOV
        % Channel gain
        h_toAdd=(m+1)*Adet*rho*dA*...
        cos_phi^m*cos_alpha*cos_beta*cos_psi/(2*pi^2*D1^2*D2^2);
        hWP=WP(3)-RP(3);
        % on simulation check if the signal is blocked
        if simulation~=0
            if hWP>hB
                if isBlocked(centers,WP,RP,hB)==1
                    notBlock=0;
                else
                    notBlock=1;
                end
            else
                if isBlocked(centers,TP,WP,hB-hWP)==1 || isBlocked(centers,WP,RP,hWP)==1
                    notBlock=0;
                else
                    notBlock=1;
                end
            end
        else
            % on theoretical approach calculate the propability
            % of the signal to be blocked
            if hWP>hB
                notBlock=FindNonBlockageProbability(lamda,WP,RP,lx,r,hWP,hB,rwp);
            else
                notBlock_1=FindNonBlockageProbability(lamda,TP,WP,lx,r,hT-hWP,hB-hWP,rwp);
                notBlock_2=FindNonBlockageProbability(lamda,WP,RP,lx,r,hWP,hB,rwp);
                notBlock=notBlock_1*notBlock_2;
            end
        end
        % multiply the channel gain with that probability
        h_toAdd=h_toAdd*notBlock;
        Hnlos(ii,jj)=Hnlos(ii,jj)+h_toAdd;
    end
end
end
end

% end each receiver position
end
end

% received power from source
Plos=Pled.*Hlos.*Ts.*G_Con;
Pnlos=Pled.*Hnlos.*Ts.*G_Con;
P_all_los(:,:,tr)=Plos;
P_all_nlos(:,:,tr)=Pnlos;
end
outputTotalPowerLoS=sum(P_all_los,3);
outputPowerVectorLoS=P_all_los;
outputTotalPowerNLoS=sum(P_all_nlos,3);
outputPowerVectorNLoS=P_all_nlos;
end

