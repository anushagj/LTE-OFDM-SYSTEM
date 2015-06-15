%This function demoulates the QPSK symbol into correspondijng bits
function pilot_demodulated=demodulator_QPSK(pilot_modulated)
    length_pilot_modulated=length(pilot_modulated)
    length_pilot=2*length_pilot_modulated;
    pilot_demodulated=zeros(1,length_pilot);
    jj=1;
    for kk=1:1:length(pilot_demodulated)/2
        if(real(pilot_modulated(kk))>0 && imag(pilot_modulated(kk))>0)
            pilot_demodulated(jj)=0;
            pilot_demodulated(jj+1)=0;
            jj=jj+2;
        end 
        if(real(pilot_modulated(kk))<0 && imag(pilot_modulated(kk))>0)
            pilot_demodulated(jj)=0;
            pilot_demodulated(jj+1)=1;
            jj=jj+2;
        end 
        if(real(pilot_modulated(kk))<0 && imag(pilot_modulated(kk))<0)
            pilot_demodulated(jj)=1;
            pilot_demodulated(jj+1)=1;
            jj=jj+2;
        end 
        if(real(pilot_modulated(kk))<0 && imag(pilot_modulated(kk))>0)
            pilot_demodulated(jj)=1;
            pilot_demodulated(jj+1)=0;
            jj=jj+2;
        end
    end 
end