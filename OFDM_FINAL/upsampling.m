% This function performs upsampling by padding evry bit with 3 zero bits
function upsampled_data=upsampling(symbol_cp)
    upsampled_data=zeros(1,length(symbols_cp)*4);
    for i=0:1:length(symbols_cp)-1
        upsampled_data(1,4*i+1)=symbols_cp(i+1);
    end
end