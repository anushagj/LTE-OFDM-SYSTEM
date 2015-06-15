% This function maps the every 300 symbols to 300 subcarriers
function mapped_data=subcarrier_mapping(data_multiplexed)
    %Zero padding to get length of new multiplexed data equal to that of
    %rows*columns   
    %new_data_multiplexed=reshape(data_multiplexed,rows,columns);
 
    subcarrier_data=zeros(512,1);
    sub_carrier_index=[-150:-1 1:150];
  
        for a=1:300
            subcarrier_data(sub_carrier_index(a)+512/2+1)=data_multiplexed(a);
        end
end
    
    