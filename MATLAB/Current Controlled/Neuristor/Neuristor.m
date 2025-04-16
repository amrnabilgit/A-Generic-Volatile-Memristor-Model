clear all;

figure(1)
set(gcf,'units','centimeter','position',[5,5,18.1,6])
tiledlayout(1,3,'TileSpacing','Compact','padding','none');

blue=[0.157 0.439 1];

%Model's parameters
params=[2.4e3 -2e4 1e5 0.2549 -1.174 0.2173 -1.174 4000 113200 113100 1.5481e-5 2.9019e-4];

C1=5.1e-9;%circuit parameters
C2=0.75e-9;

Duration=500e-6;%duration of the simulation
Initial_Values=[-0.1067,0.1067,113100,113100]; %[initial voltage of voltage node 1,initial voltage of voltage node 2,initial resistance of memristor 1, initial resistance of memristor 2] 

opts1 = odeset('RelTol',1e-3,'AbsTol',1e-6,'MaxStep',1e-9);

[t,y]=ode45(@(t,y)CC_Neuristor_ODE(t,y,params,C1,C2), [0 Duration], Initial_Values, opts1);%uses ODE45 to simulate the circuit for the Duration

nexttile(1)
plot(t,y(:,2),'Color',blue,'linewidth',2.5)%plots the output voltage waveform
xlabel({'Time (s)';'(a)'});
ylabel('Voltage (V)');
xlim([0 500e-6])
ylim([-0.1 0.65])
title(' ')
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

C1=5.1e-9;
C2=0.5e-9;

opts1 = odeset('RelTol',1e-3,'AbsTol',1e-6,'MaxStep',1e-9);
[t,y]=ode45(@(t,y)CC_Neuristor_ODE(t,y,params,C1,C2), [0 Duration], Initial_Values, opts1);

nexttile(2)
plot(t,y(:,2),'Color',blue,'linewidth',2.5)
xlabel({'Time (s)';'(b)'});
ylabel('Voltage (V)');
xlim([0 500e-6])
ylim([-0.1 0.65])
title(' ')
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

C1=1.6e-9;
C2=0.5e-9;

opts1 = odeset('RelTol',1e-3,'AbsTol',1e-6,'MaxStep',1e-9);

[t,y]=ode45(@(t,y)CC_Neuristor_ODE(t,y,params,C1,C2), [0 Duration], Initial_Values, opts1);

nexttile(3)
plot(t,y(:,2),'Color',blue,'linewidth',2.5)
xlabel({'Time (s)';'(c)'});
ylabel('Voltage (V)');
xlim([0 300e-6])
ylim([-0.1 0.65])
title(' ')
ax=gca;
ax.LineWidth=1.5;
ax.FontSize=8;
ax.FontName='TimesNewRoman';
ax.XColor='k';
ax.YColor='k';
ax.XMinorTick= 'on';
ax.YMinorTick= 'on';

f = gcf;
exportgraphics(f,'Neuristor.jpg','Resolution',800)