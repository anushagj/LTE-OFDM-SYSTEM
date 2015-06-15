%This function downsamples the data, that is removes three out of fout bits
function downsampled_data=downsampling(symbol_filtered)
    size_symbol_filtered=length(symbol_filtered);
    downsampled_data=zeros(size_symbol_filtered/4,1);
    for iy=0:1:length(downsampled_data)-1
        downsampled_data(iy+1,1)=symbol_filtered(4*iy+1,1);
    end
end