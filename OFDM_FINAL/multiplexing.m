% This function multiplexes the data and the pilot bits. Five bits of
% data are followed by one bit of pilot
function data_multiplexed=multiplexing(data_modulated, pilot_modulated,each_symbol)
    pilot_counter=1;
    dat_counter=1;
    loop_variable=length(data_modulated)+length(pilot_modulated);
    if(numel(pilot_modulated)==0)
        data_multiplexed=data_modulated;
    elseif each_symbol==1; %For the 1st symbol at every slot
        for zz=1:1:loop_variable
            if(mod(zz,6)==0)
                data_multiplexed(zz)=pilot_modulated(pilot_counter);
                pilot_counter=pilot_counter+1;
            else 
                data_multiplexed(zz)=data_modulated(dat_counter);
                dat_counter=dat_counter+1;
            end
        end
    else   %For the 5th symbol at every slot
        for zz=1:1:loop_variable
            if(mod(zz-3,6)==0)
                data_multiplexed(zz)=pilot_modulated(pilot_counter);    
                pilot_counter=pilot_counter+1;
            else    
                data_multiplexed(zz)=data_modulated(dat_counter);
                dat_counter=dat_counter+1;
            end
        end
    end  
end