function TP_all = FindLEDPositions2(x,y,NLED)
if NLED==1
    TP_all=[0 0];
elseif NLED==4
    % x dimension
    % NLED=2
    xNLED=2;
    TPx_values=linspace(min(x),max(x),2*xNLED+1);
    TPx_values=TPx_values(2:2:end-1);
    % y dimension
    % NLED=2
    yNLED=2;
    TPy_values=linspace(min(y),max(y),2*yNLED+1);
    TPy_values=TPy_values(2:2:end-1);
    % Take all possible combinations of TPx_values and TPy_values
    % https://www.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
    [TPx,TPy] = meshgrid(TPx_values,TPy_values);
    TPxy=cat(2,TPx',TPy');
    TP_all=reshape(TPxy,[],2);
elseif NLED==8
    NLED=4;
    TPx_values=linspace(min(x),max(x),NLED/2+3);
    % keep only the NLED/2 (exclude the wall and the middle point)
    TPx_values=TPx_values(2:2:end-1);
    % y takes the same values for both LED configurations
    % these are the same values as x for NLED=4
    ly=max(y)-min(y);
    TPy_values=[-ly/4 ly/4];

    % Take all possible combinations of TPx_values and TPy_values
    % https://www.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
    [TPx,TPy] = meshgrid(TPx_values,TPy_values);
    TPxy=cat(2,TPx',TPy');
    TP_first4=reshape(TPxy,[],2);
    TP_more=[0 -ly/4;0 ly/4;ly/4 0;-ly/4 0];
    TP_all=[TP_first4;TP_more];
elseif NLED==8
    % x dimension
    % NLED=3
    xNLED=3;
    TPx_values=linspace(min(x),max(x),2*xNLED+1);
    TPx_values=TPx_values(2:2:end-1);
    % y dimension
    % NLED=3
    yNLED=3;
    TPy_values=linspace(min(y),max(y),2*yNLED+1);
    TPy_values=TPy_values(2:2:end-1);
    % Take all possible combinations of TPx_values and TPy_values
    % https://www.mathworks.com/matlabcentral/answers/98191-how-can-i-obtain-all-possible-combinations-of-given-vectors-in-matlab
    [TPx,TPy] = meshgrid(TPx_values,TPy_values);
    TPxy=cat(2,TPx',TPy');
    TP_all=reshape(TPxy,[],2);
    mean=(length(TP_all)+1)/2;
    TP_all=[TP_all(1:mean-1,:); TP_all(mean+1:end,:)];
elseif NLED==16
    % x dimension
    % NLED=4
    xNLED=4;
    TPx_values=linspace(min(x),max(x),2*xNLED+1);
    TPx_values=TPx_values(2:2:end-1);
    % y dimension
    % NLED=4
    yNLED=4;
    TPy_values=linspace(min(y),max(y),2*yNLED+1);
    TPy_values=TPy_values(2:2:end-1);
    
    [TPx,TPy] = meshgrid(TPx_values,TPy_values);
    TPxy=cat(2,TPx',TPy');
    TP_all=reshape(TPxy,[],2);
end
end

