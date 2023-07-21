Parameters;
NLED=8;
% Find LED positions
TP_all=FindLEDPositions2(x,y,NLED);
% plot(lamdavalues,P1T,"r-X","linewidth",2);

figure
scatter(TP_all(:,1), TP_all(:,2))
xlabel('length (m)')
ylabel('width (m)')
axis([-lx/2 lx/2 -ly/2 ly/2])
