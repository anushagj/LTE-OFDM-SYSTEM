% This function multiplexes the data and the pilot bits. Five bits of
% data are followed by one bit of pilot
function [data, pilot]=demultiplexing(demapped_data,each_symbol)
    pilot=[];
    data=[];
    pilot_counter=1;
    data_counter=1;
    
    % We have 3 cases--
    
    % (1)When symbol is in the 1st slot
    % (2)When symbol is in the 5th slot
    % (3)When symbol is neither in the 1st slot or 5th slot
    
    if(each_symbol==1)
       for pp=1:1:length(demapped_data)
            if(mod(pp,6)==0)
            pilot=[pilot demapped_data(pp)];
            else 
            data=[data demapped_data(pp)];
            end
       end
        
    elseif(each_symbol==5)
       for pp=1:1:length(demapped_data)
            if(mod(pp-3,6)==0)
            pilot=[pilot demapped_data(pp)];
            else 
            data=[data demapped_data(pp)];
            end
       end
       
    else  data=demapped_data;
    
    end   
       
       
end