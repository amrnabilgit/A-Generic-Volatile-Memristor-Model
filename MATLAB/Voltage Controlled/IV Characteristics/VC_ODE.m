function dydt = VC_ODE(t,y,Duration,Write_Amplitude,Ic,params)

%-----------Model's Parameters-------------------------
    k1=params(1);
    k2=params(2);
    A1=params(3);
    M1=params(4);
    A2=params(5);
    M2=params(6);
    Rmin=params(7);
    Rmax=params(8);
    Vth=params(9);
    Vh=params(10);
    C=params(11);
    limit=params(12);
%--------------------------------------------------------

R_inf_set=@(z) (z^M1)*(A1)*1e-6;%steady state resistance during SET operation
R_inf_reset=@(z) (z^M2)*(A2)*1e-6;%steady state resistance during RESET operation

if t<Duration/2%Generates the write pulse input to the model
    V=(2*Write_Amplitude/Duration)*t;
else
    V=(-2*Write_Amplitude/Duration)*t+2*Write_Amplitude;
end

V_diffusive=V;
i=V_diffusive/(y*1e6);%Calculates the current through the device

if(i>Ic)%imposes the compliance current
    i=Ic;
    V_diffusive=Ic*y*1e6;
end

if(R_inf_set(i)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_set=Rmin;
elseif (R_inf_set(i)>Rmax)
    R_final_set=Rmax;
else
    R_final_set=R_inf_set(i);
end

if(R_inf_reset(i)<Rmin)%limits the steady state function between Rmin and Rmax
    R_final_reset=Rmin;
elseif (R_inf_reset(i)>Rmax)
    R_final_reset=Rmax;
else
    R_final_reset=R_inf_reset(i);
end


if((R_final_set-y) < 0&& (V_diffusive>Vh))%evolution of the state variable during the SET operation
if (V_diffusive>Vth )
    dydt=k1*exp(C*V_diffusive)*((V_diffusive-Vth)/(y-Rmin));
    if dydt<-limit %Limts the rate of change to aid in convergance
        dydt=-limit;
    end
else
    dydt=k1*exp(C*V_diffusive);
    if dydt<-limit
        dydt=-limit;
    end
end
elseif ((R_final_reset-y) > 0 && (V_diffusive<Vh))%evolution of the state variable during the RESET operation
    dydt=k2*((Vh-V_diffusive)/Vh)*(y^3);
    if dydt>limit
        dydt=limit;
    end
else
    dydt=0;
end

end