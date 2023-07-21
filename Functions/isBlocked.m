function out = isBlocked(centers,TP,RP,hB)
% This function checks if the signal transmitted from TP to RP
% is blocked by humans represented by cylinders
% centers(i,1) and centers(i,2) are the coordinates of cylinder center
% on centers(i,3) is the radius and hB is the height

%for each disk
for i=1:size(centers,1)
%     if i==37
%         in=1;
%     end
    if i==size(centers,1)
        if i==1
        end
    end
    if TP(1)==RP(1)
        % straight line from TP and RP on x,y plane:
        % x=a
        a=TP(1);
        % circle (x-c)^2+(y-d)^2=r^2
        c=centers(i,1);
        d=centers(i,2);
        r=centers(i,3);
        % find intersection points
        % y^2 - 2*d*y + (d^2+(a-c)^2-r^2)=0
        alpha=1;
        beta=-2*d;
        gamma=d^2+(a-c)^2-r^2;
        % Delta=beta^2-4*alpha*gamma
        delta=beta^2-4*alpha*gamma;
        % if delta>=0 then there's an intersection between
        % TP and RP line and the corresponding disk.
        % We need to check if the straight line on 3D
        % on the intersection points
        % is above of the cylinder level or not
        if delta>=0
            y1=(-beta+sqrt(delta))/(2*alpha);
            y2=(-beta-sqrt(delta))/(2*alpha);
            x1=a;
            x2=a;
            z1=findZ(TP,RP,x1,y1);
            z2=findZ(TP,RP,x2,y2);
            % if on either point, coordinate z value, is between 
            % receiver's z and receiver_z+height of the blockage
            % then the straight line intersects the cylinder
            % in the 3D space and the signal is blocked
            between_limits=(RP(3)<=z1 &&  z1<=hB+RP(3)) || (RP(3)<=z2 &&  z2<=hB+RP(3));
            % if on either point, coordinate z is equal to inf
            % then that's a special value that's assigned in
            % findZ function to show that the straight line is
            % parallel to z axis, which means that the straight
            % line intersects the cylinder in the 3D space from
            % the top and the signal is blocked
            parallel_to_z=(z1==inf) || (z2==inf);
            % if a case that the signal is blocked is occured
            % then return 1
            if between_limits || parallel_to_z
                out=1;
                return
            end
        end
    else
        % straight line from TP and RP on x,y plane:
        % y=ax+b
        a=(TP(2)-RP(2))/(TP(1)-RP(1));
        b=TP(2)-a*TP(1);
        % circle (x-c)^2+(y-d)^2=r^2
        c=centers(i,1);
        d=centers(i,2);
        r=centers(i,3);
        % find intersection points
        % (a^2+1)*x^2 + 2*(a*b-a*d-c)*x + (c^2+(b-d)^2-r^2)=0
        alpha=a^2+1;
        beta=2*(a*b-a*d-c);
        gamma=c^2+(b-d)^2-r^2;
        % Delta=beta^2-4*alpha*gamma
        delta=beta^2-4*alpha*gamma;
        % if delta>=0 then there's an intersection between
        % TP and RP line and the corresponding disk.
        % We need to check if the straight line on 3D
        % on the intersection points
        % is above of the cylinder level or not
        if delta>=0
            x1=(-beta+sqrt(delta))/(2*alpha);
            x2=(-beta-sqrt(delta))/(2*alpha);
            y1=a*x1+b;
            y2=a*x2+b;
            z1=findZ(TP,RP,x1,y1);
            z2=findZ(TP,RP,x2,y2);
            
            % [xout, yout]=linecirc(a,b,c,d,r);
            
            % if on either point, coordinate z value, is between 
            % receiver's z and receiver_z+height of the blockage
            % then the straight line intersects the cylinder
            % in the 3D space and the signal is blocked
            between_limits=(RP(3)<=z1 &&  z1<=hB+RP(3)) || (RP(3)<=z2 &&  z2<=hB+RP(3));
            % if on either point, coordinate z is equal to inf
            % then that's a special value that's assigned in
            % findZ function to show that the straight line is
            % parallel to z axis, which means that the straight
            % line intersects the cylinder in the 3D space from
            % the top and the signal is blocked
            parallel_to_z=(z1==inf) || (z2==inf);
            % if a case that the signal is blocked is occured
            % then return 1
            if between_limits || parallel_to_z
                out=1;
                return
            end
        end
    end
end
out=0;
end
