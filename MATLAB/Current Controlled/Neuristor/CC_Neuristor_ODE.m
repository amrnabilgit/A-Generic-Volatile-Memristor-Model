function dydt = CC_Neuristor_ODE(t,y,params,C1,C2)
dydt = zeros(4,1);

if (t<5e-5)%defines the injected current
    Iin=0;
else
    Iin=20e-6;
end

%-----------Model's Parameters-------------------------
    Rseries=params(1);
    k1=params(2);
    k2=params(3);
    A1=params(4);
    M1=params(5);
    A2=params(6);
    M2=params(7);
    Rmin=params(8);
    Rins=params(9);
    Rmax=params(10);
    Ith=params(11);
    Ih=params(12);
%--------------------------------------------------------

Rl2=15e3;%circuit parameters
Vdc=1.75;

Vm1=(y(3)/(y(3)+Rseries))*(y(1)+Vdc);%voltage across the first memristor
Vm2=(y(4)/(y(4)+Rseries))*(-y(2)+Vdc);%voltage across the second memristor

R_inf_set=@(z) (z^M1)*(A1);%steady state resistance during SET operation
R_inf_reset=@(z) (z^M2)*(A2);%steady state resistance during RESET operation

if (y(3)<Rmin)%Limits the model's resistance between Rmin and Rmax
    y(3)=Rmin;
elseif (y(3)>Rmax)
    y(3)=Rmax;
end

if (y(4)<Rmin)%Limits the model's resistance between Rmin and Rmax
    y(4)=Rmin;
elseif (y(4)>Rmax)
    y(4)=Rmax;
end

i1=Vm1/(y(3));%Calculates the current through the first memristor
i2=Vm2/(y(4));%Calculates the current through the second memristor

if(R_inf_set(i1)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_set_1=Rmin;
elseif (R_inf_set(i1)>Rmax)
    R_final_set_1=Rmax;
else
    R_final_set_1=R_inf_set(i1);
end

if(R_inf_reset(i1)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_reset_1=Rmin;
elseif (R_inf_reset(i1)>Rmax)
    R_final_reset_1=Rmax;
else
    R_final_reset_1=R_inf_reset(i1);
end

if(R_inf_set(i2)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_set_2=Rmin;
elseif (R_inf_set(i2)>Rmax)
    R_final_set_2=Rmax;
else
    R_final_set_2=R_inf_set(i2);
end

if(R_inf_reset(i2)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_reset_2=Rmin;
elseif (R_inf_reset(i2)>Rmax)
    R_final_reset_2=Rmax;
else
    R_final_reset_2=R_inf_reset(i2);
end

if((R_final_set_1-y(3)) < 0 )%evolution of the state variable during the SET operation
    dydt(3)=k1*(y(3)^2)*((Rins/y(3)-1)^0.5)*(((y(3)*i1^2)/(Rmax*Ith^2))-1);
elseif ((R_final_reset_1-y(3)) > 0)%evolution of the state variable during the RESET operation
    dydt(3)=k2*(y(3)^2)*((Rins/y(3)-1)^0.5)*(1-((y(3)*i1^2)/(Rmin*Ih^2)));
else
    dydt(3)=0;
end

if((R_final_set_2-y(4)) < 0 )%evolution of the state variable during the SET operation
    dydt(4)=k1*(y(4)^2)*((Rins/y(4)-1)^0.5)*(((y(4)*i2^2)/(Rmax*Ith^2))-1);
elseif ((R_final_reset_2-y(4)) > 0)%evolution of the state variable during the RESET operation
    dydt(4)=k2*(y(4)^2)*((Rins/y(4)-1)^0.5)*(1-((y(4)*i2^2)/(Rmin*Ih^2)));
else
    dydt(4)=0;
end

dydt(1)=(1/C1)*(Iin-((y(1)+Vdc)/(y(3)+Rseries))-((y(1)-y(2))/Rl2));%evolution of the voltage across C1
dydt(2)=(1/C2)*(((y(1)-y(2))/Rl2)-((y(2)-Vdc)/(y(4)+Rseries)));%evolution of the voltage across C2

end