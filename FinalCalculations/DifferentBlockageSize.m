addpath(genpath('C:\Διπλωματική\VLC_Human_Blockages\Final'));
clc
clear
Parameters;

p=1;
NLED=4;
rwp=0;
type=3;
plot_centers=0;
simulation=0;
centers=0;

r_values=0.2:0.01:0.4;

P2BR=zeros(1,length(r_values));
P5BR=zeros(1,length(r_values));
P10BR=zeros(1,length(r_values));
P15BR=zeros(1,length(r_values));

for rr=1:length(r_values)
    r=r_values(rr);
    
    lamda=2;
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
    P2BR(rr)=10*log10(mean2(outputTotalPower));
    
    lamda=5;
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
    P5BR(rr)=10*log10(mean2(outputTotalPower));
    
    lamda=10;
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
    P10BR(rr)=10*log10(mean2(outputTotalPower));
    
    lamda=15;
    [outputTotalPower,~] = Model1(type,lamda,simulation,centers,NLED,r,p,rwp);
    P15BR(rr)=10*log10(mean2(outputTotalPower));

end

h_values=1.2:0.1:2;
r=r1;

P2BH=zeros(1,length(h_values));
P5BH=zeros(1,length(h_values));
P10BH=zeros(1,length(h_values));
P15BH=zeros(1,length(h_values));

for hh=1:length(h_values)
    hB=h_values(hh);
    hB=hB-hR;
    lamda=2;
    [outputTotalPower,~] = Model1DifferentBlockagesHeight(type,lamda,simulation,centers,NLED,r,p,rwp,hB);
    P2BH(hh)=10*log10(mean2(outputTotalPower));
    
    lamda=5;
    [outputTotalPower,~] = Model1DifferentBlockagesHeight(type,lamda,simulation,centers,NLED,r,p,rwp,hB);
    P5BH(hh)=10*log10(mean2(outputTotalPower));
    
    lamda=10;
    [outputTotalPower,~] = Model1DifferentBlockagesHeight(type,lamda,simulation,centers,NLED,r,p,rwp,hB);
    P10BH(hh)=10*log10(mean2(outputTotalPower));
    
    lamda=15;
    [outputTotalPower,~] = Model1DifferentBlockagesHeight(type,lamda,simulation,centers,NLED,r,p,rwp,hB);
    P15BH(hh)=10*log10(mean2(outputTotalPower));
end

r_values=r_values*100;
h_values=h_values*100;
figure
hold on
grid on
plot(r_values,P2BR,'-s','MarkerFaceColor',"b","linewidth",2);
plot(r_values,P5BR,'-x','MarkerFaceColor',"r","linewidth",2);
plot(r_values,P10BR,'-o','MarkerFaceColor',"g","linewidth",2);
plot(r_values,P15BR,'-+','MarkerFaceColor',"m","linewidth",2);
xlabel('Blockage radius in cm')
ylabel('Received Power in dBm')
legend('2B','5B','10B','15B')

figure
hold on
grid on
plot(h_values,P2BH,'-s','MarkerFaceColor',"b","linewidth",2);
plot(h_values,P5BH,'-x','MarkerFaceColor',"r","linewidth",2);
plot(h_values,P10BH,'-o','MarkerFaceColor',"g","linewidth",2);
plot(h_values,P15BH,'-+','MarkerFaceColor',"m","linewidth",2);
xlabel('Blockage radius in cm')
ylabel('Received Power in dBm')
legend('2B','5B','10B','15B')

