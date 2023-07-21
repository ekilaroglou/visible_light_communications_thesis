function finalCenters = SimulatePoissonProcess(type,lamda,lx,ly,r,plot,rwp)
% This function Simulates the poisson proccess and
% returns the center of the points with their associated radius
% 
% INPUTS
% type: determines the type of "lamda" input
%       1: lamda is the intensity of the parent poisson process
%       2: lamda is the blockage intensity (after thinned process)
%       3: lamda is the total number of blockages
% lx,ly: room dimensions
% r: scalar or array of uniform distributed possible radius
% plot: takes value 1 to plot the centers before and after thinning
% rwp: takes value 1 to simulate RWP instead of Poisson Process

% if rwp value is missing
if nargin == 6
    % set rwp to zero
    rwp=0;
end


% Area on receiver/transmitter plane
if length(r)==1
    V=(lx-2*r)*(ly-2*r);
else
    V=1/2*(lx-2*r(1))*(ly-2*r(1))+1/2*(lx-2*r(2))*(ly-2*r(2));
end
% Allow to simulate poisson to determine the number of points N
sim_poisson=1;

switch type
    case 1
    case 2
        k=pi*(2*r)^2;
        % if blockage intensity is higher than it's max value
        % take the max value and print the error in console
        lamda_max=1/k;
        if lamda>lamda_max
            fprintf('lamda=%i was bigger than maximum value so it was assgned as the maximumv value %i',lamda, lamda_max);
            lamda=lamda_max;         
        end
        % find the intensity of parent poisson process
        lamda=-log(1-k*lamda)/k;
    case 3
        % since we know the amount of points
        % don't simulate poisson process
        sim_poisson=0;
        % let the parent poisson process have a very big number of points
        N=10000;
        % Number of blockages
        N_blockage=lamda;
end

% simulate poisson to determine the number of points N
% for details look on 
% "Stochastic Geomety and its Applications Third Edition"
% Sung Nok Chiu, Dietrich Stoyan, Wilfrid S. Kendall, Joseph Mecke
if sim_poisson==1
    mi=lamda*V;
    epsilon=0;
    N=0;
    while(epsilon<=mi)
        u=rand(1,1);
        ep=-log(u);
        epsilon=epsilon+ep;
        N=N+1;
    end
    N=N-1;
end


% Number of different possible radius
N_radius=length(r);
% centers array to return
finalCenters=[];
% Lower and Higher limit of center coordinates (x_min,y_min,x_max,y_max)
% a=-lx/2; b=lx/2;
% a=-lx/2+r1; b=lx/2-r1;


if plot==1
    allCenters=[];
end
% For each point on parent poisson process
for i=1:N
    % if we don't simulate the poisson process and want
    % a specific number of points
    if sim_poisson==0
        % if the specific number of points is reached
        % then return the already existing centers
        if size(finalCenters,1)==N_blockage
            break
        end
    end
    % take uniform distributed random radius from vector r
    randr=rand(1,1);
    r_index=ceil(randr/(1/N_radius));
    randr=r(r_index);
    
    % if r wasn't uniform and we had a probablity p foreach r
%     randr=rand(1,1)
%     total_probability=0;
%     for p_index=1:length(p)
%         total_probability=total_probability+p(p_index);
%         if randr<=total_probability
%             randr=r(p_index);
%             break;
%         end
%     end
    
    % Take random x and y values
    if rwp==0
        a=-lx/2+randr; b=lx/2-randr;
        % take uniform distributed random x and y for the center
        randx=a+(b-a)*rand(1,1);
        randy=a+(b-a)*rand(1,1);
    else
        % take RWP distributed random x and y for the center
        randx=RandomNumberRWP(lx-2*randr);
        randy=RandomNumberRWP(ly-2*randr);
    end
    
    % Plot centers
    if plot==1
        new_point=[randx randy randr];
        allCenters=[allCenters; new_point];
    end
    
    % Check if the new disk is overlapped by any other existing disk
    tooclose=0;
    for j=1:size(finalCenters,1)
        D=sqrt((randx-finalCenters(j,1))^2+(randy-finalCenters(j,2))^2);
        if D<randr+finalCenters(j,3)
            tooclose=1;
            break
        end
    end
    
    % if it's overlapped then continue the process
    % without adding the new point
    if tooclose==1
        continue
    end
    new_point=[randx randy randr];
    finalCenters=[finalCenters; new_point];
end
% Plot centers
if plot==1
    PlotCenters(allCenters,lx,ly,'All Points before deletion');
    PlotCenters(finalCenters,lx,ly,'Final Points');
end
end

