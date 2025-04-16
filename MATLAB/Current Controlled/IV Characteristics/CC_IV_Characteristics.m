clear all;

blue=[0.157 0.439 1];

Rseries=2.4e3;%Electrode resistance in series with the device
Duration=100e-8;%Duration of voltage sweep
Write_Amplitude=2;%Amplitude of write pulse
Rinitial=86607;%Initial resistance

%Model's parameters
params=[2.4e3 -2e4 1e5 0.2549 -1.174 0.2173 -1.174 4000 113200 113100 1.5481e-5 2.9019e-4];

opts = odeset('RelTol',1e-5,'AbsTol',1e-8);
[t,r]=ode45(@(t,y)CC_ODE(t,y,Duration,Write_Amplitude,params), [0 Duration], Rinitial,opts);%uses ODE45 to solve for the Duration

L=length(r);
for i=1:L%Generates a vector defining the write pulse input to the model
    
    if t(i)<Duration/2
        V(i,1)=(2*Write_Amplitude/Duration)*t(i);
    else
        V(i,1)=(-2*Write_Amplitude/Duration)*t(i)+2*Write_Amplitude;
    end
   
end

V_mott=(r./(r+Rseries)).*V;%Calculates the voltage across the device
I=(V_mott./r);%Calculates the current through the device


figure(1)
plot(V,I,'Color',blue,'linewidth',1.5)%plots the IV characteristics
xlabel('Voltage (V)');
ylabel('Current (A)');
set(gca,'linewidth',2.2,'fontsize',15)
xlim([0,2])
ylim([0-20e-6,4e-4])
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

set(gcf,'units','centimeter','outerposition',[5,5,8.8,8.8])
f = gcf;
exportgraphics(f,'IV_Characteristics.jpg','Resolution',800)