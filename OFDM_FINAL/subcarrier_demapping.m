function demapped_data=subcarrier_demapping(output_fft)
%     size_output=size(output_ifft)
%     rows=size_output(1);
%     columns=size_output(2);
%     demapped_data=[];
%     %Zero padding to get length of new multiplexed data equal to that of
%     %rows*columns
%     for i=1:1:columns
%         demapped_data=[demapped_data output_ifft(1:300,i)];
%     end
%     demapped_data=reshape(demapped_data,1,300*columns);
    subcarrier_ind=[-150:-1 1:150];
    demapped_data = zeros(300,1);
            for gg = 1:300
                demapped_data(gg) = output_fft(subcarrier_ind(gg)+512/2+1);
            end 
end
    
  