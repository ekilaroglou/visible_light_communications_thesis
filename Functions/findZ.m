function outZ = findZ(A,B,x,y)
% This function finds the z coordinate of point P(x,y,z)
% that "belongs" to a straight line that intersects 
% the points A and B.


% vector parallel to the straight line
u=A-B;
a=[x y];
% http://papdes.webpages.auth.gr/portal/images/Pdf/Eutheia4.1.pdf
% straight line:
% x=A(1)+u(1)*lamda
% y=A(2)+u(2)*lamda
% z=A(3)+u(2)*lamda
for i=1:2
    % if u(1) or u(2) are not 0
    if u(i)~=0
        lamda=(a(i)-A(i))/u(i);
        outZ=A(3)+lamda*u(3);
        return
    end
end
% if u(1) and u(2) are 0 then the straight line is parallel 
% to z axis. We return the special value z=inf so we will know
% to handle and block the signal in this case
% (the beam=straight line intersects the blockage=cylinder
% from the top which means that the signal will be blocked).
outZ=inf;
end

