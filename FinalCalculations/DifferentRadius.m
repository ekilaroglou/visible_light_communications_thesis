addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

% lamda is number of blockages
type=3;
% follow the paper
plot_centers=0;

%% Parameters to change
NLED=4;
simulation=1;
N_Simulation=100;

%% Script
lamdavalues=0:1:15;
L=length(lamdavalues);
P_r1_Poisson=zeros(1,L);
P_r2_Poisson=zeros(1,L);
P_r1r2_Poisson=zeros(1,L);
P_r1_RWP=zeros(1,L);
P_r2_RWP=zeros(1,L);
P_r1r2_RWP=zeros(1,L);

for j=1:length(lamdavalues)
    lamda=lamdavalues(j);
    fprintf('lamda is %d\n',lamda);
    if simulation==0
        centers=0;
        %%
        rwp=0;
        r=r1;
        p=1;
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
        P_r1_Poisson(j)=10*log10(mean2(outputTotalPower));

        r=r2;
        p=1;
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
        P_r2_Poisson(j)=10*log10(mean2(outputTotalPower));

        r=[r1 r2];
        p=[1/2 1/2];
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
        P_r1r2_Poisson(j)=10*log10(mean2(outputTotalPower));
        %%
        rwp=1;
        r=r1;
        p=1;
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
        P_r1_RWP(j)=10*log10(mean2(outputTotalPower));

        r=r2;
        p=1;
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
        P_r2_RWP(j)=10*log10(mean2(outputTotalPower));

        r=[r1 r2];
        p=[1/2 1/2];
        [outputTotalPower,~] = Model1(type,lamda,simulation,centers,2*NLED,r,p,rwp);
        P_r1r2_RWP(j)=10*log10(mean2(outputTotalPower));
    else
        Simulation_Power_r1_Poisson=zeros(1,N_Simulation);
        Simulation_Power_r2_Poisson=zeros(1,N_Simulation);
        Simulation_Power_r1r2_Poisson=zeros(1,N_Simulation);
        Simulation_Power_r1_RWP=zeros(1,N_Simulation);
        Simulation_Power_r2_RWP=zeros(1,N_Simulation);
        Simulation_Power_r1r2_RWP=zeros(1,N_Simulation);
        for i=1:N_Simulation
            %%
            rwp=0;
            r=r1;
            p=1;
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r1_Poisson(i)=10*log10(mean2(outputTotalPower));

            r=r2;
            p=1;
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r2_Poisson(i)=10*log10(mean2(outputTotalPower));

            r=[r1 r2];
            p=[1/2 1/2];
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r1r2_Poisson(i)=10*log10(mean2(outputTotalPower));
            %%
            rwp=1;
            r=r1;
            p=1;
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r1_RWP(i)=10*log10(mean2(outputTotalPower));

            r=r2;
            p=1;
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r2_RWP(i)=10*log10(mean2(outputTotalPower));

            r=[r1 r2];
            p=[1/2 1/2];
            centers = SimulatePoissonProcess(type,lamda,lx,ly,r,plot_centers,rwp);
            [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
            Simulation_Power_r1r2_RWP(i)=10*log10(mean2(outputTotalPower));
        end
        P_r1_Poisson(j)=mean(Simulation_Power_r1_Poisson);
        P_r2_Poisson(j)=mean(Simulation_Power_r2_Poisson);
        P_r1r2_Poisson(j)=mean(Simulation_Power_r1r2_Poisson);
        P_r1_RWP(j)=mean(Simulation_Power_r1_RWP);
        P_r2_RWP(j)=mean(Simulation_Power_r2_RWP);
        P_r1r2_RWP(j)=mean(Simulation_Power_r1r2_RWP);
    end
end

figure
hold on
grid on
plot(lamdavalues,P_r1_RWP,"b","linewidth",2);
plot(lamdavalues,P_r1r2_RWP,"r","linewidth",2);
plot(lamdavalues,P_r2_RWP,"y","linewidth",2);
plot(lamdavalues,P_r1_Poisson,"m","linewidth",2);
plot(lamdavalues,P_r1r2_Poisson,"g","linewidth",2);
plot(lamdavalues,P_r2_Poisson,"c","linewidth",2);
xlabel('Blockage density')
ylabel('Received Power in dBm')
axis([0 15 -3 1.5])
legend('4-LED Blockage-RWP (r1)','4-LED Blockage-RWP (r1 & r2)','4-LED Blockage-RWP (r2)','4-LED Blockage-MHCP (r1)','4-LED Blockage-MHCP (r1 & r2)','4-LED Blockage-MHCP (r2)')
%legend('8-LED Blockage-RWP (r1)','8-LED Blockage-RWP (r1 & r2)','8-LED Blockage-RWP (r2)','8-LED Blockage-MHCP (r1)','8-LED Blockage-MHCP (r1 & r2)','8-LED Blockage-MHCP (r2)')

% figure
% hold on
% plot(lamdavalues,P_r1_Poisson,"b","linewidth",2);
% plot(lamdavalues,P_r1r2_Poisson,"r","linewidth",2);
% plot(lamdavalues,P_r2_Poisson,"y","linewidth",2);
% xlabel('Blockage density')
% ylabel('Received Power in dBm')
% legend('4-LED Blockage-MHCP (r1)','4-LED Blockage-MHCP (r1 & r2)','4-LED Blockage-MHCP (r2)')
% 
% figure
% hold on
% plot(lamdavalues,P_r1_RWP,"b","linewidth",2);
% plot(lamdavalues,P_r1r2_RWP,"r","linewidth",2);
% plot(lamdavalues,P_r2_RWP,"y","linewidth",2);
% xlabel('Blockage density')
% ylabel('Received Power in dBm')
% legend('4-LED Blockage-RWP (r1)','4-LED Blockage-RWP (r1 & r2)','4-LED Blockage-RWP (r2)')
% 
% 
