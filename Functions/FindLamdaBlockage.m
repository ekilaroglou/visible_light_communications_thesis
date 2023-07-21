function lamda_blockage = FindLamdaBlockage(type,lamda,r,p,V,paper)
% This function finds the blockage intensity based on
% parent intensity/total blockage intensity/number of blockages

% INPUTS
% type: determines the type of "lamda" input
%       1: lamda is the intensity of the parent poisson process
%       2: lamda is the blockage intensity (after thinned process)
%       3: lamda is the total number of blockages
% lamda: intensity or number of blockages, depends on type
% r: radius of humans, if it's more than one then it's an array
% p: if there's 2 types of humans (2 different radius
%    corresponding to them) then the propability of each radius
% V: the area on which the blockages exist
% paper: takes value 1 for paper formula
%        takes value 0 for "my" formula

switch type
    case 1
        if length(r)==1
            % if lamda it's parent intensity then find blockage intensity
            k=pi*(2*r)^2;
            lamda_blockage=(1-exp(-lamda*k))/k;
        else
            % if lamda it's parent intensity then find blockage intensities
            p1=p(1);
            p2=p(2);
            if paper==1
                C=p1*(4*p1+9*p2)^-1+p2*(9*p1+16*p2)^-1;
                gr1=p2*(9*p1+16*p2)/C;
                gr2=p1*(4*p1+9*p2)/C;
                % should be lamda * p1 * gr1 but the paper
                % doesn't have the "p1"
                lamda_blockage(1)=lamda*gr1;
                lamda_blockage(2)=lamda*gr2;
            else
                r1=r(1);
                r2=r(2);
                A=lamda*pi*((2*r1)^2*p1+(r1+r2)^2*p2);
                gr1=(1-exp(-A))/A;
                B=lamda*pi*((r1+r2)^2*p1+(2*r2)^2*p2);
                gr2=(1-exp(-B))/B;
                lamda_blockage(1)=gr1*lamda*p1;
                lamda_blockage(2)=gr2*lamda*p2;
            end
        end
    case 2
        if length(r)==1
            k=pi*(2*r)^2;
            % if blockage intensity is higher than it's max value
            % take the max value and print the error in console
            lamda_max=1/k;
            if lamda>lamda_max
                fprintf('lamda=%i was bigger than maximum value so it was assgned as the maximumv value %i',lamda, lamda_max);
                lamda_blockage=lamda_max;
                return;
            end
            lamda_blockage=lamda;
        elseif length(r)==2 && length(lamda)==1
            % find lamda_p, the intensity of the parent point
            % process, to use it to find the intensity of
            % processes for each r
            p1=p(1);
            p2=p(2);
            if paper==1
                C=p1*(4*p1+9*p2)^-1+p2*(9*p1+16*p2)^-1;
                gr1=p2*(9*p1+16*p2)/C;
                gr2=p1*(4*p1+9*p2)/C;
                % lamda_blockage=lamda_p*(g(r1)*p1+g(r2)*p2)
                lamda_p=lamda/(gr1*p1+gr2*p2);
                lamda_blockage(1)=lamda_p*gr1*p1;
                lamda_blockage(2)=lamda_p*gr2*p2;
            else
                % based on RANDOM PATTERNS OF NONOVERLAPPING CONVEX GRAINS:
                % lamda_blockage=lamda_p*(g(r1)*p1+g(r2)*p2)
                % lamda_p*g(r1)=(1-exp(-lamda_p*A))/A
                % lamda_p*g(r2)=(1-exp(-lamda_p*B))/B
                % A=pi*((2*r1)^2*p1+(r1+r2)^2*p2);
                % B=pi*((r1+r2)^2*p1+(2*r2)^2*p2);
                r1=r(1);
                r2=r(2);
                A=pi*((2*r1)^2*p1+(r1+r2)^2*p2);
                B=pi*((r1+r2)^2*p1+(2*r2)^2*p2);
                lamda_max=p1/A+p2/B;
                if lambda>lamda_max
                    fprintf('lamda=%i was bigger than maximum value so it was assgned as the maximumv value %i',lamda, lamda_max);
                    lamda_blockage=lamda_max;         
                end
                % After making the math
                %lamda_p=solve(lamda_blockage==p1/A*(1-exp(-A*n))+p2/B*(1-exp(-B*n)),n);
                syms lamda_var
                eqn=p1/A*(1-exp(-A*lamda_var))+p2/B*(1-exp(-B*lamda_var))-lambda==0;
                lamda_p=vpasolve(eqn);
                %lamda_p=abs((log(p1/A)+log(p2/B)-log(p1/A+p2/B-lamda_blockage))/(A+B));
                lamda_blockage(1)=p1*(1-exp(-lamda_p*A))/A;
                lamda_blockage(2)=p2*(1-exp(-lamda_p*B))/B;
            end
        elseif length(r)==2
            % if length(lamda)!=1 then we assume that it's 2
            % so we already know the lamda(1) and lamda(2) intensities
            lamda_blockage(1)=lamda(1);
            lamda_blockage(2)=lamda(2);
        end
    case 3
        if length(r)==1
            % if it's number of blockages(humans) then approximate 
            % the point process (of blockages after thinning)
            % as Poisson Point Process and find the intensity
            % that will be the blockage intensity
            lamda_blockage=lamda/V;
        elseif length(r)==2 && length(lamda)==1
            % if it's number of blockages(humans) then approximate 
            % the point process (of blockages after thinning)
            % as Poisson Point Process and find the intensity
            % that will be the blockage intensity
            lamda_blockage=lamda/V;
            
            % find lamda_p, the intensity of the parent point
            % process, to use it to find the intensity of
            % processes for each r
            p1=p(1);
            p2=p(2);
            if paper==1
                C=p1*(4*p1+9*p2)^-1+p2*(9*p1+16*p2)^-1;
                gr1=p2*(9*p1+16*p2)/C;
                gr2=p1*(4*p1+9*p2)/C;
                % lamda_blockage=lamda_p*(g(r1)*p1+g(r2)*p2)
                lamda_p=lamda/(gr1*p1+gr2*p2);
                lamda_blockage(1)=lamda_p*gr1*p1;
                lamda_blockage(2)=lamda_p*gr2*p2;
            else
                % based on RANDOM PATTERNS OF NONOVERLAPPING CONVEX GRAINS:
                % lamda_blockage=lamda_p*(g(r1)*p1+g(r2)*p2)
                % lamda_p*g(r1)=(1-exp(-lamda_p*A))/A
                % lamda_p*g(r2)=(1-exp(-lamda_p*B))/B
                % A=pi*((2*r1)^2*p1+(r1+r2)^2*p2);
                % B=pi*((r1+r2)^2*p1+(2*r2)^2*p2);
                r1=r(1);
                r2=r(2);
                A=pi*((2*r1)^2*p1+(r1+r2)^2*p2);
                B=pi*((r1+r2)^2*p1+(2*r2)^2*p2);
                lamda_max=p1/A+p2/B;
                if lamda_blockage>lamda_max
                    fprintf('lamda=%i was bigger than maximum value so it was assgned as the maximumv value %i',lamda, lamda_max);
                    lamda_blockage=lamda_max;         
                end
                % After making the math
                %lamda_p=solve(lamda_blockage==p1/A*(1-exp(-A*n))+p2/B*(1-exp(-B*n)),n);
                syms lamda_var
                eqn=p1/A*(1-exp(-A*lamda_var))+p2/B*(1-exp(-B*lamda_var))-lamda_blockage==0;
                lamda_p=vpasolve(eqn);
                %lamda_p=abs((log(p1/A)+log(p2/B)-log(p1/A+p2/B-lamda_blockage))/(A+B));
                lamda_blockage(1)=p1*(1-exp(-lamda_p*A))/A;
                lamda_blockage(2)=p2*(1-exp(-lamda_p*B))/B;
            end
        elseif length(r)==2
            % if length(lamda)!=1 then we assume that it's 2
            % so like case with length(r)==1
            lamda_blockage(1)=lamda(1)/V;
            lamda_blockage(2)=lamda(2)/V;
        end
end
end

