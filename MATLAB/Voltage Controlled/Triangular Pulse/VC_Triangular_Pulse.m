clear all;

blue=[0.157 0.439 1];
green=[0 0.569 0];

%Model's parameters
params=[-1e15 7e7 0.0249821 -1.151244 29.473 -0.841 2e-6 5e6 1.89 0.14 3.5 1e13];

Duration=5e-4;%duration of the simulation
Write_Amplitude=5;%circuit parameters
Read_Amplitude=0.1;
Ic=11.25e-6;
Rinitial=5e6;%initial resistance

opts = odeset('RelTol',1e-5,'AbsTol',1e-8,'MaxStep',1e-4);
[t,rm]=ode45(@(t,y)VC_ODE(t,y,Write_Amplitude,Read_Amplitude,Ic,params), [0 Duration], Rinitial,opts);
L=length(rm);
r=rm*1e6;

for i=1:L  %Generates a vector defining the write pulse input to the model
    if t(i)<10e-5
        V(i,1)=Write_Amplitude*1e4*t(i);
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

figure(1)
set(gcf,'units','centimeter','position',[5,5,18.1,5.5])
tiledlayout(1,3,'TileSpacing','Compact','padding','none');

nexttile(1)
plot(t-3.5e-5,I,'Color',blue,'linewidth',2);%plots the current in response to a triangular pulse input
hold on
xlabel({'Time (s)';'(a)'})
ylabel('Current (A)')
yyaxis right
plot(t-3.5e-5,V,'Color',green,'linewidth',1)%plots the input voltage
ylim([-0.5 10])
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';
ylabel('Voltage (V)','Color',green)
yyaxis left
ylim([-5e-6 15e-6]);
xlim([-3.25e-5 4e-4]);
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

%-------------------------------------------------------------------------------------------
clear all;

%Model's parameters
params=[-4e13 1.3e7 0.080314 -1.110418 29.473 -0.841 2e-6 5e6 1.89 0.277 3.5 1e13];

blue=[0.157 0.439 1];
green=[0 0.569 0];

Duration=12e-4;
Write_Amplitude=5;
Read_Amplitude=0.2;
Ic=13.5e-6;
Rinitial=5e6;

opts = odeset('RelTol',1e-5,'AbsTol',1e-8,'MaxStep',1e-4);
[t,rm]=ode45(@(t,y)VC_ODE(t,y,Write_Amplitude,Read_Amplitude,Ic,params), [0 Duration], Rinitial,opts);
L=length(rm);
r=rm*1e6;

for i=1:L
    
    if t(i)<10e-5
        V(i,1)=Write_Amplitude*1e4*t(i);
    else
        V(i,1)=Read_Amplitude;
    end
    
end

for i=1:L
    V_diffusive(i)=V(i);
    I(i)=V_diffusive(i)/(r(i));
    if(I(i)>Ic)
        I(i)=Ic;
        V_diffusive(i)=Ic*r(i);
    end
end

nexttile(2)
plot(t-3.5e-5,I,'Color',blue,'linewidth',2);
hold on
xlabel({'Time (s)';'(b)'})
ylabel('Current (A)')
yyaxis right
plot(t-3.5e-5,V,'Color',green,'linewidth',1)
ylim([-0.5 10])
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';
ylabel('Voltage (V)','Color',green)
yyaxis left
ylim([-5e-6 20e-6]);
xlim([-3.25e-5 10e-4]);
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

%---------------------------------------------------------------------------------------
clear all;

%Model's parameters
params=[-1e14 1.5e7 0.126941 -1.094414 29.473 -0.841 2e-6 5e6 1.89 0.37 3.5 1e13];

blue=[0.157 0.439 1];
green=[0 0.569 0];

Duration=12e-4;
Write_Amplitude=5;
Read_Amplitude=0.35;
Ic=12e-6;
Rinitial=5e6;

opts = odeset('RelTol',1e-5,'AbsTol',1e-8,'MaxStep',1e-4);
[t,rm]=ode45(@(t,y)VC_ODE(t,y,Write_Amplitude,Read_Amplitude,Ic,params), [0 Duration], Rinitial,opts);
L=length(rm);
r=rm*1e6;

for i=1:L
    if t(i)<10e-5
        V(i,1)=Write_Amplitude*1e4*t(i);
    else
        V(i,1)=Read_Amplitude;
    end
end

for i=1:L
    V_diffusive(i)=V(i);
    I(i)=V_diffusive(i)/(r(i));
    if(I(i)>Ic)
        I(i)=Ic;
        V_diffusive(i)=Ic*r(i);
    end
end


nexttile(3)
plot(t-3.5e-5,I,'Color',blue,'linewidth',2);
hold on
xlabel({'Time (s)';'(c)'})
ylabel('Current (A)')
yyaxis right
plot(t-3.5e-5,V,'Color',green,'linewidth',1)
ylim([-0.5 10])
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';
ylabel('Voltage (V)','Color',green)
yyaxis left
ylim([-5e-6 15e-6]);
xlim([-3.25e-5 10e-4]);
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';


f = gcf;
exportgraphics(f,'Trianglular Pulse.jpg','Resolution',800)