% This function performs iift on the mapped data
function output_ifft=ifft_block(mapped_data)
    mapped_data=fftshift(mapped_data);
    output_ifft=ifft(mapped_data,512);    
end