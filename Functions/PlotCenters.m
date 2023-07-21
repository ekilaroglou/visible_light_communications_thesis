function PlotCenters(centers,lx,ly,name)
% This function plots blockages as circles in the 2D xy space
%
% INPUTS
% centers: a Nx3 array containing N blockages.The first two 
%          columns correspond to the x and y coordinates. The
%          third column corresponds to the blockages radius
% lx: room dimension in x axis
% ly: room dimension in y axis
% name: the title of the plot

% if there's no blockages to plot, return
% and don't plot an empty figure
if size(centers,1)==0
    return
end

% Create figure
figure
% For each blockage
for i=1:size(centers,1)
    % Get x,y coordinates and the radius r
    x=centers(i,1);
    y=centers(i,2);
    r=centers(i,3);
    % plot blockage
    th = 0:pi/50:2*pi;
    xunit = r * cos(th) + x;
    yunit = r * sin(th) + y;
    plot(xunit, yunit);
    hold on
end
% axis limits
axis([-lx/2 lx/2 -ly/2 ly/2]);
% figure title
title(name);
hold off
end

