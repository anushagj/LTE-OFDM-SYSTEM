% This function adds the last 36 bits of the symbol to the beginning as cyclic prefix 
function symbol_cp=cyclic_prefix(output_ifft)
    symbol_cp=[output_ifft(477:512); output_ifft];
   
end