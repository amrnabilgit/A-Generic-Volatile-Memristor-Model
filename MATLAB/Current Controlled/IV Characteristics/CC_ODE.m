function dydt = CC_ODE(t,y,Duration,Write_Amplitude,params)
    
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

    R_inf_set=@(z) (z^M1)*(A1);%steady state resistance during SET operation
    R_inf_reset=@(z) (z^M2)*(A2);%steady state resistance during RESET operation

    
    if t<Duration/2%Generates a vector defining the write pulse input to the model
        V=(2*Write_Amplitude/Duration)*t;
    else
        V=(-2*Write_Amplitude/Duration)*t+2*Write_Amplitude;
    end

    if (y<Rmin) %Limits the model's resistance between Rmin and Rmax
        y=Rmin;
    elseif (y>Rmax)
        y=Rmax;
    end


    V_mott=((y)/((y)+Rseries))*V; %Calculates the voltage across the device
    i=V_mott/(y);%Calculates the current through the device


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

    if((R_final_set-y) < 0 )%evolution of the state variable during the SET operation
        dydt=k1*(y^2)*((Rins/y-1)^0.5)*(((y*i^2)/(Rmax*Ith^2))-1);
    elseif ((R_final_reset-y) > 0)%evolution of the state variable during the RESET operation
        dydt=k2*(y^2)*((Rins/y-1)^0.5)*(1-((y*i^2)/(Rmin*Ih^2)));
    else
        dydt=0;
    end

end

