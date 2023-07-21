function notBlock = FindNonBlockageProbability(lamda,TP,RP,lx,r,hT,hB,rwp)
% This function finds the Non-Blockage Probability between 
% a transmitter and a receiver with a gived blockage intensity
% 
% INPUTS
% lamda: lamda is the blockage intensity (after thinned process)
% TP: Transmitter Position
% RP: Receiver Position
% lx: room dimension in a lx*lx room (ly=lx)
% r: scalar or array of uniform distributed possible radius
% hT: Height of Transmitter with respect to receiver
% hB: Height of Blockage with respect to receiver
% rwp: takes value 1 for RWP and 0 for Poisson Process

% Find the horizontal distance between Transmitter and Receiver
% in the receiver's plane
dT=sqrt((TP(1)-RP(1))^2+(TP(2)-RP(2))^2);


% Poisson Process Case
if rwp==0
    % Calculate V_Block which is the Volume in receiver's plane (Area)
    % on which if a blockage exists the signal will be blocked
    % Calculate not-blockage probability based on it and on
    % poisson process void probabilities
    
    % One size blockages
    if length(r)==1
        V_block=2*r*dT*(hB/hT)+pi*r^2;
        notBlock=exp(-lamda*V_block);
        
        % using binomial point process:
        % lamda should be the number of blockagews
%         Vroom=(lx-2*r)*(lx-2*r);
%         notBlock=(Vroom-V_block)^lamda/Vroom^lamda;
        
    % Blockages with 2 different size
    else
        V_block_1=2*r(1)*dT*(hB/hT)+pi*r(1)^2;
        V_block_2=2*r(2)*dT*(hB/hT)+pi*r(2)^2;
        notBlock=exp(-lamda(1)*V_block_1).*exp(-lamda(2)*V_block_2);
    end
    
% Random Waypoint Model Case
else
    % One size blockages
    if length(r)==1
        notBlock=FindNonBlockageProbabilityRWPsimpleCase(lamda,TP,RP,lx,r,dT,hT,hB);
        
    % Blockages with 2 different size
    else
        notBlock_1=FindNonBlockageProbabilityRWPsimpleCase(lamda(1),TP,RP,lx,r(1),dT,hT,hB);
        notBlock_2=FindNonBlockageProbabilityRWPsimpleCase(lamda(2),TP,RP,lx,r(2),dT,hT,hB);
        notBlock=notBlock_1.*notBlock_2;
    end
end

