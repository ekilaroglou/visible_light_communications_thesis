function value = RandomNumberRWP(a)
% This function gets a random number in [-a/2 a/2]
% based on the Random Waypoint Model Probability Distribution 
% 
% INPUTS
% a: the limits of the random value

% Take a random number from [0 1]
randValue=rand(1,1);
% Knofing the pdf f(X) of the RWP we find the cdf F(X) of it
% If we take a random number from [0 1] and set F(X)=random_number
% Then if we solve for X we get a random X value from the wanted
% distribution
% Doing the above we get the following Polyonym
p=[-2/a^3 0 3/(2*a) 1/2-randValue];
% We find the roots of it
r=roots(p);
% Since in (-a/2 a/2) all roots are real (checked it in paper)
% We don't need to check for real values
% But we check to be in [-a/2 a/2] area
% We get a threshold because we are dealing with float numbers
thr=1e-6;
r=r(real(r)<=a/2+thr);
r=r(real(r)>=-a/2-thr);
% If we are on the limits 0 or 1 then return the desired value
% (That's needed because we are dealing with float numbers)
switch randValue
    case 0 
        value=-a/2;
    case 1 
        value=a/2;
    otherwise
        value=r;
end
end

