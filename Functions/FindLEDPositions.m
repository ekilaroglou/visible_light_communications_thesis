function TP_all = FindLEDPositions(x,y,NLED)
% This Code works for 4 or 8 LED configuration
% Divide x space in NLED/2 (even number)
% + the middle of the room (x=0)
% + the bounds (x=-lx/2 and x=lx/2)
% = NLED/2+3 equal spaced points
TPx_values=linspace(min(x),max(x),NLED/2+3);
% keep only the NLED/2 (exclude the wall and the middle point)
TPx_values=[TPx_values(1,2:(length(TPx_values)+1)/2-1) TPx_values(1,(length(TPx_values)+1)/2+1:length(TPx_values)-1)];
% y takes the same values for both LED configurations
% these are the same values as x for NLED=4
ly=max(y)-min(y);
TPy_values=[-ly/4 ly/4];

% Take all possible combinations of TPx_values and TPy_values
% https://www.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
[TPx,TPy] = meshgrid(TPx_values,TPy_values);
TPxy=cat(2,TPx',TPy');
TP_all=reshape(TPxy,[],2);

end

