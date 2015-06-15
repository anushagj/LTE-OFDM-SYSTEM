% This function receives the binary data and converts it back to an image
function image_data_receiver(data_generated)
 imdata_resized=reshape(data_generated,400, 400);
 for i=1:1:400
     for j=1:1:400
         if(imdata_resized(i,j)==1)
             imdata_resized(i,j)=255;
         else 
             imdata_resized(i,j)=0;
         end
     end
 end
 disp('Image after receiving'); 
 pause
 figure;
 title('Image after receiving');
 imshow(imdata_resized')
 end
     
 