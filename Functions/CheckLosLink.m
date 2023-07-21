function [hasLoS] = CheckLosLink(NLED,centers)

% Initiallize basic parameters
Parameters;
% Find LED positions
TP_all=FindLEDPositions2(x,y,NLED);

hasLoS=zeros(Nx,Ny);

% for each LED
for tr=1:NLED
    % Transmitter positions
    TP=[TP_all(tr,1) TP_all(tr,2) lz/2];
    % For each receiver position
    for ii=1:Nx
        for jj=1:Ny
            % Receiver Position Vector
            RP=[x(ii) y(jj) -lz/2]; 
            % distance from the source
            D=sqrt(dot(TP-RP,TP-RP));
            % angle between transitter and receiver
            cosphi=h/D;
            receiver_angle=acosd(cosphi);
            % Channel gain
            if abs(receiver_angle)<=FOV
                if isBlocked(centers,TP,RP,hB)==0
                    hasLoS(ii,jj)=1;
                end
            end
        end
    end
end
end

