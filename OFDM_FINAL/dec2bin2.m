% This function converts a decimal number to a biinary vector
function bin = dec2bin2(dec)
i=0;
p=1;
%calculate
while i == 0
     if dec/2 > 0
          if dec/2 ~= round(dec/2)
               bin(p) = 1;
          end
          if dec/2 == round(dec/2)
               bin(p) = 0;
          end
     end
     if dec/2 < 1
          bin(p) = 1;
          i = 1;
     else
          p=p+1;
          dec = floor(dec/2);
     end
end

%Invert
newbin=zeros(1,length(bin));
for i = 1:length(bin)
     newbin(i) = bin((length(bin)-i)+1);
end


end