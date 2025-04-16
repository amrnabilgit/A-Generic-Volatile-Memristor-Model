clear all;

%Model's parameters
params=[-2.9e13 5e4 0.140529 -1.090859 29.473 -0.841 2e-6 5e6 1.89 1.6427 3.5 1e9];

Duration=100;%duration of the simulation
Write_Amplitude=2.5;%circuit parameters
Ic=10e-6;
Rinitial=5e6;%initial resistance

blue=[0.157 0.439 1];

opts = odeset('RelTol',1e-5,'AbsTol',1e-8);
[t,rm]=ode45(@(t,y)VC_ODE(t,y,Duration,Write_Amplitude,Ic,params), [0 Duration], Rinitial,opts);%uses ODE45 to simulate for the Duration
L=length(rm); 
r=rm*1e6;

for i=1:L%Generates a vector defining the write pulse input to the model
    if t(i)<Duration/2
        V(i,1)=(2*Write_Amplitude/Duration)*t(i);
    else
        V(i,1)=(-2*Write_Amplitude/Duration)*t(i)+2*Write_Amplitude;
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


figure(1)
plot(V,I,'Color',blue,'linewidth',1.5)%plots the IV charactersitics
set(gca, 'YScale', 'log')
xlabel('Voltage (V)');
ylabel('Current (A)');
xlim([0,2]);
ylim([5e-15,20e-6]);
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