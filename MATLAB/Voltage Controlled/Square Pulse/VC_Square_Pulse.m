clear all;

blue=[0.157 0.439 1];
green=[0 0.569 0];

%Model's parameters
params=[-1e13 6e4 0.140529 -1.090859 29.473 -0.841 2e-6 5e6 1.89 0.4 3.5 1e9];

Duration=0.2;%duration of the simulation
Write_Amplitude=2;%circuit parameters
Read_Amplitude=0.1;
Ic=8e-6;
Rinitial=5e6;%initial resistance

opts = odeset('RelTol',1e-5,'AbsTol',1e-8);
[t,rm]=ode45(@(t,y)VC_ODE(t,y,Duration,Write_Amplitude,Read_Amplitude,Ic,params), [0 Duration], Rinitial,opts);%uses ODE45 to simulate for the Duration
L=length(rm);
r=rm*1e6;

for i=1:L%Generates a vector defining the write pulse input to the model
    if t(i)<Duration/2
        V(i,1)=Write_Amplitude;
    else
        V(i,1)=Read_Amplitude;
    end
end

for i=1:L%imposes the compliance current
    V_diffusive(i)=V(i);
    I(i)=V_diffusive(i)/(r(i));
    if(I(i)>Ic)
        I(i)=Ic;
        V_diffusive(i)=Ic*r(i);
    end
end

V_pulse=V;
V_pulse(1)=0;

figure(1)
plot(t,I,'Color',blue,'linewidth',1.5)%plots the current in response to a square pulse input
hold on
xlabel('Time (s)');
ylabel('Current (A)');
xlim([0-0.003,0.18]);
ylim([-2e-6,15e-6]);
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';
yyaxis right
plot(t,V_pulse,'color',green,'linewidth',0.75)%plots the input voltage
ylim([0,3]);
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';
ylabel('Voltage (V)','Color',green);

set(gcf,'units','centimeter','outerposition',[5,5,8.8,8.8])
f = gcf;
exportgraphics(f,'Square Pulse.jpg','Resolution',800)