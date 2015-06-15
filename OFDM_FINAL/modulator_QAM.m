% This function performs mapping of every 4 data bits into one QAM symbol
function data_modulated=modulator_QAM(data_generated)
    temp_matrix=zeros(ceil(length(data_generated)/4),4);
    size_matrix=size(temp_matrix);
    data_counter=1;
    for m=1:1:size_matrix(1)
        for n=1:1:size_matrix(2)
            temp_matrix(m,n)=data_generated(data_counter);
            data_counter=data_counter+1;
            if(data_counter>=length(data_generated))
                break;
            end
        end
        if(data_counter>=length(data_generated))
                break;
        end
    end
    data_modulated=zeros(size_matrix(1),1);
    for m=1:1:size_matrix(1)
        if((temp_matrix(m,1)==0)&&(temp_matrix(m,3)==0))
            data_modulated(m)=data_modulated(m)-1;
        end
        if((temp_matrix(m,1)==0)&&(temp_matrix(m,3)==1))
            data_modulated(m)=data_modulated(m)-3;
        end
        if((temp_matrix(m,1)==1)&&(temp_matrix(m,3)==0))
            data_modulated(m)=data_modulated(m)+1;
        end
        if((temp_matrix(m,1)==1)&&(temp_matrix(m,3)==1))
            data_modulated(m)=data_modulated(m)+3;
        end
        if((temp_matrix(m,2)==0)&&(temp_matrix(m,4)==0))
            data_modulated(m)=data_modulated(m)-i;
        end
        if((temp_matrix(m,2)==0)&&(temp_matrix(m,4)==1))
            data_modulated(m)=data_modulated(m)-3i;
        end
        if((temp_matrix(m,2)==1)&&(temp_matrix(m,4)==0))
            data_modulated(m)=data_modulated(m)+i;
        end
        if((temp_matrix(m,2)==1)&&(temp_matrix(m,4)==1))
            data_modulated(m)=data_modulated(m)+3i;
        end
    end
    
    
    
        
