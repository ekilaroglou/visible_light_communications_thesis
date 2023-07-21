addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% choose r1 radius
r=r1;
p=1;
rwp=0;
% lamda is number of blockages
type=3;
plot_centers=0;
simulation=1;
N_Simulation=1e4;
lamdavalues=0:1:15;

P_avg_LED_4_Blockages_2=zeros(1,N_Simulation);
P_avg_LED_4_Blockages_6=zeros(1,N_Simulation);
P_avg_LED_4_Blockages_12=zeros(1,N_Simulation);
P_avg_LED_8_Blockages_2=zeros(1,N_Simulation);
P_avg_LED_8_Blockages_6=zeros(1,N_Simulation);
P_avg_LED_8_Blockages_12=zeros(1,N_Simulation);
for i=1:N_Simulation
NLED=4;
lamda=2;
centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
P_avg_LED_4_Blockages_2(i)=10*log10(mean2(outputTotalPower));
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
P_avg_LED_8_Blockages_2(i)=10*log10(mean2(outputTotalPower));
lamda=6;
centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
P_avg_LED_4_Blockages_6(i)=10*log10(mean2(outputTotalPower));
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
P_avg_LED_8_Blockages_6(i)=10*log10(mean2(outputTotalPower));
lamda=12;
centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers);
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
P_avg_LED_4_Blockages_12(i)=10*log10(mean2(outputTotalPower));
[outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
P_avg_LED_8_Blockages_12(i)=10*log10(mean2(outputTotalPower));
end

A=[P_avg_LED_4_Blockages_2;P_avg_LED_8_Blockages_2;
    P_avg_LED_4_Blockages_6;P_avg_LED_8_Blockages_6;
    P_avg_LED_4_Blockages_12;P_avg_LED_8_Blockages_12;];

min_value=min(min(min(A)));
max_value=max(max(max(A)));

values=min_value:0.005:max_value;

Total_LED_4_Blockages_2=zeros(1,length(values));
Total_LED_8_Blockages_2=zeros(1,length(values));
Total_LED_4_Blockages_6=zeros(1,length(values));
Total_LED_8_Blockages_6=zeros(1,length(values));
Total_LED_4_Blockages_12=zeros(1,length(values));
Total_LED_8_Blockages_12=zeros(1,length(values));

for i=1:length(values)
    Total_LED_4_Blockages_2(i) = sum(P_avg_LED_4_Blockages_2>=values(i));
    Total_LED_8_Blockages_2(i) = sum(P_avg_LED_8_Blockages_2>=values(i));
    Total_LED_4_Blockages_6(i) = sum(P_avg_LED_4_Blockages_6>=values(i));
    Total_LED_8_Blockages_6(i) = sum(P_avg_LED_8_Blockages_6>=values(i));
    Total_LED_4_Blockages_12(i) = sum(P_avg_LED_4_Blockages_12>=values(i));
    Total_LED_8_Blockages_12(i) = sum(P_avg_LED_8_Blockages_12>=values(i));
end

Total_LED_4_Blockages_2=Total_LED_4_Blockages_2/N_Simulation;
Total_LED_8_Blockages_2=Total_LED_8_Blockages_2/N_Simulation;
Total_LED_4_Blockages_6=Total_LED_4_Blockages_6/N_Simulation;
Total_LED_8_Blockages_6=Total_LED_8_Blockages_6/N_Simulation;
Total_LED_4_Blockages_12=Total_LED_4_Blockages_12/N_Simulation;
Total_LED_8_Blockages_12=Total_LED_8_Blockages_12/N_Simulation;

figure
hold on
grid on
plot(values,Total_LED_4_Blockages_2,'-s','MarkerFaceColor','b')
plot(values,Total_LED_4_Blockages_6,'-s','MarkerFaceColor','r')
plot(values,Total_LED_4_Blockages_12,'-s','MarkerFaceColor','k')
plot(values,Total_LED_8_Blockages_2,'-s','MarkerFaceColor','y')
plot(values,Total_LED_8_Blockages_6,'-s','MarkerFaceColor','c')
plot(values,Total_LED_8_Blockages_12,'-s','MarkerFaceColor','g')
xlabel('Received Power')
ylabel('CDF')
axis([-0.6 1.5 0 1])
legend('Prx-4LED-2B','Prx-4LED-6B','Prx-4LED-12B','Prx-8LED-2B','Prx-8LED-6B','Prx-8LED-12B')
