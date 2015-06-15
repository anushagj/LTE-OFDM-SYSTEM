% This function demodulates the QAM symbol into 4 corresponding bits
function demodulated_data=demodulator_QAM(input_data)
    demodulated_data=zeros(length(input_data),4);
    input_data=input_data.*sqrt(10);
    for i=1:length(input_data)
        real_part(i)=real(input_data(i));
        imag_part(i)=imag(input_data(i));
        if (real_part(i)>0)&&(real_part(i)<2)
            demodulated_data(i,1)=1;
            demodulated_data(i,3)=0;
        end
        if (real_part(i)<0)&&(real_part(i)>-2)
            demodulated_data(i,1)=0;
            demodulated_data(i,3)=0; 
        end
        if (real_part(i)>2)
            demodulated_data(i,1)=1;
            demodulated_data(i,3)=1; 
        end
        if (real_part(i)<-2)
            demodulated_data(i,1)=0;
            demodulated_data(i,3)=1;
        end
        if (imag_part(i)>0)&&(imag_part(i)<2)
            demodulated_data(i,2)=1;
            demodulated_data(i,4)=0;
        end
        if (imag_part(i)<0)&&(imag_part(i)>-2)
            demodulated_data(i,2)=0;
            demodulated_data(i,4)=0; 
        end
        if (imag_part(i)>2)
            demodulated_data(i,2)=1;
            demodulated_data(i,4)=1; 
        end
        if (imag_part(i)<-2)
            demodulated_data(i,2)=0;
            demodulated_data(i,4)=1;
        end
    end
    demodulated_data=reshape(demodulated_data',1,length(input_data)*4);
end
