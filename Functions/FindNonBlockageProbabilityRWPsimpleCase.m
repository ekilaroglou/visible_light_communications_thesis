function notBlock = FindNonBlockageProbabilityRWPsimpleCase(lamda,TP,RP,lx,r,dT,hT,hB)
% This function finds the Non-Blockage Probability between 
% a transmitter and a receiver with a gived blockage intensity
% using Random Waypoint Model in the simplest case of 1 possible
% blockage radius
% 
% INPUTS
% lamda: lamda is the blockage intensity (after thinned process)
% TP: Transmitter Position
% RP: Receiver Position
% lx: room dimension in a lx*lx room (ly=lx)
% r: scalar or array of uniform distributed possible radius
% dT: Horizontal distance between Transmitter and Receiver
%     in the receiver's plane
% hT: Height of Transmitter with respect to receiver
% hB: Height of Blockage with respect to receiver

% Rotation Value to consider if we solve the problem with axis
% rotation which have more complicated matehmatical formula 
% but it's easier in intuitively understanding
rotation=1;
% Room length and width:
% Since Blockages have radius r, a blockage can exist in
% [-lx/2+r lx/2-r] which have length lx-2*r
a=lx-2*r;

if rotation==1
    % rotate x and y axis
    % find angle between our original axis and TP-RP line
    if TP(1)==RP(1)
        theta=90;
    else
        theta=atand((TP(2)-RP(2))/(TP(1)-RP(1)));
    end
    % Rotation matrix
    rotation_matrix=[cosd(theta) sind(theta); -sind(theta) cosd(theta)];
    % Transmitter and Receiver position in the new coordinate system
    TP2=rotation_matrix*TP(1:2)';
    RP2=rotation_matrix*RP(1:2)';

    % min and max value of y
    yMax=RP2(2)+r;
    yMin=RP2(2)-r;
    % min and max value of x
    if RP2(1)==TP2(1)
        xMin=RP2(1);
        xMax=RP2(1);
    elseif RP2(1)>TP2(1)
        xMin=RP2(1)-dT*(hB/hT);
        xMax=RP2(1);
    else
        xMin=RP2(1);
        xMax=RP2(1)+dT*(hB/hT);
    end

    % Deg to Rad conversion
    theta=theta*pi/180;
    % Consider x1 and y1 the coordinates in the new system
    % x=x1*cos(theta)-y1*sin(theta)
    % y=x1*sin(theta)+y1*cos(theta)
    % lamda(x1,y1) within the room
    fun=@(x1,y1) (36/a^6)*a^2*lamda*((x1*cos(theta)-y1*sin(theta)).^2-(a/2)^2).*((x1*sin(theta)+y1*cos(theta)).^2-(a/2)^2);
    % get Ë(Â) in the orthogonal area
    lamda_beta(1)=integral2(fun,xMin,xMax,yMin,yMax);

    % get Ë(Â) in the two half circle areas
    % min and max rho value
    rhoMin=0;
    rhoMax=r;
    % min and max phi value of first half-circle
    phiMin=-pi/2;
    phiMax=pi/2;
    % lamda(rho,phi) in the first half-circle area
    % the right half-circle so we take x1=xMax+rho*cos(phi)
    % and y1=RP2(2)+rho*sin(phi)
    fun=@(rho,phi) (36/a^6)*a^2*lamda*(((xMax+rho.*cos(phi))*cos(theta)-(RP2(2)+rho.*sin(phi))*sin(theta)).^2-(a/2)^2).*(((xMax+rho.*cos(phi))*sin(theta)+(RP2(2)+rho.*sin(phi))*cos(theta)).^2-(a/2)^2).*rho;
    lamda_beta(2)=integral2(fun,rhoMin,rhoMax,phiMin,phiMax);
    % min and max phi value of second half-circle
    phiMin=pi/2;
    phiMax=3*pi/2;
    % lamda(rho,phi) in the second half-circle area
    % the right half-circle so we take x1=xMin+rho*cos(phi)
    % and y1=RP2(2)+rho*sin(phi)
    fun=@(rho,phi) (36/a^6)*a^2*lamda*(((xMin+rho.*cos(phi))*cos(theta)-(RP2(2)+rho.*sin(phi))*sin(theta)).^2-(a/2)^2).*(((xMin+rho.*cos(phi))*sin(theta)+(RP2(2)+rho.*sin(phi))*cos(theta)).^2-(a/2)^2).*rho;
    lamda_beta(3)=integral2(fun,rhoMin,rhoMax,phiMin,phiMax);

    % Take the total lamda_beta and find the non-blockage probability
    lamda_beta=sum(lamda_beta);
    notBlock=exp(-lamda_beta);
else
    xth=(RP(1)-TP(1))*(hB/hT);
    yth=(RP(2)-TP(2))*(hB/hT);
    P1=[RP(1) RP(2)];
    P2=[RP(1)-xth RP(2)-yth];
    Points=[P1;P2];

    % TO DO
    %     xMin=min(RP(1),RP(1)-xth);
    %     xMax=max(RP(1),RP(1)-xth);
    %     yMin=min(RP(2),RP(2)-yth);
    %     yMax=max(RP(2),RP(2)-yth);
    %     fun=@(x,y) (36/a^6)*a^2*lamda*(x.^2-(a/2)^2).*(y.^2-(a/2)^2);
    %     lamda_beta(1)=integral2(fun,xMin,xMax,yMin,yMax);


    if TP(1)==RP(1)
    theta=90;
    % if theta = 90 deg then the right point is the up one
    Right_Point=Points(find(Points(:,2)==max(Points(:,2))),:);
    Left_Point=Points(find(Points(:,2)==min(Points(:,2))),:);
    else
    theta=atand((TP(2)-RP(2))/(TP(1)-RP(1)));
    Right_Point=Points(find(Points(:,1)==max(Points(:,1))),:);
    Left_Point=Points(find(Points(:,1)==min(Points(:,1))),:);
    end

    rhoMin=0;
    rhoMax=r;

    % For left point
    xPos=Left_Point(1);
    yPos=Left_Point(2);
    fun=@(rho,phi) (36/a^6)*a^2*lamda*((xPos+rho.*cos(phi)).^2-(a/2)^2).*((yPos+rho.*sin(phi)).^2-(a/2)^2).*rho;
    phiMin=theta+90;
    phiMax=phiMin+180;
    lamda_beta(2)=integral2(fun,rhoMin,rhoMax,phiMin*pi/180,phiMax*pi/180);

    % For right point
    xPos=Right_Point(1);
    yPos=Right_Point(2);
    fun=@(rho,phi) (36/a^6)*a^2*lamda*((xPos+rho.*cos(phi)).^2-(a/2)^2).*((yPos+rho.*sin(phi)).^2-(a/2)^2).*rho;
    phiMin=theta-90;
    phiMax=theta+90;
    lamda_beta(3)=integral2(fun,rhoMin,rhoMax,phiMin*pi/180,phiMax*pi/180);

    % All
    lamda_beta_sum=sum(lamda_beta);
    notBlock=exp(-lamda_beta_sum);
end
end

