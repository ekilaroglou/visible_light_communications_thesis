addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% choose r1 radius
r=r2;
p=1;
NLED=4;
rwp=1;
% lamda is number of blockages
type=3;
plot_centers=0;


N_Simulation=20;
lamdavalues=0:10:50;
for j=1:length(lamdavalues)
    lamda=lamdavalues(j);
    fprintf('lamda is %d\n',lamda);
    simulation=0;
    centers=0;

%     [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
%     P4T(j)=10*log10(mean2(outputTotalPower));
%     [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
%     P8T(j)=10*log10(mean2(outputTotalPower));
    
    simulation=1;
    Simulation_Power_4LED=zeros(1,N_Simulation);
    Simulation_Power_8LED=zeros(1,N_Simulation);
    
    for i=1:N_Simulation
    centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);
    
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
    Simulation_Power_4LED(i)=10*log10(mean2(outputTotalPower));
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
    Simulation_Power_8LED(i)=10*log10(mean2(outputTotalPower));
    end
    P4S(j)=mean(Simulation_Power_4LED);
    P8S(j)=mean(Simulation_Power_8LED);
    
end

figure
hold on
% plot(lamdavalues,P4T,"y","linewidth",2);
plot(lamdavalues,P4S,"m","linewidth",2);
% plot(lamdavalues,P8T,"g","linewidth",2);
plot(lamdavalues,P8S,"c","linewidth",2);

xlabel('Blockage density')
ylabel('Received Power in dBm')
% legend('4-LED','8-LED')

legend('4-LED Theoretical','4-LED Simulation','8-LED Theoretical','8-LED Simulation')
