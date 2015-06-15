% This function converts a grey image into binary and sends for
% transmission
function data_generated=image_data_generator()
 path=pwd;
 change=cd(path);
 imdata=imread('\Checkered_box.jpg');
 imdata=imdata(:,:,1);
 disp('Image before transmitting');
 pause
 figure;
 title('Image before transmitting');
 imshow(imdata)
 imdata_resized=imresize(imdata,[400 400]);
 imdata_resized=im2double(imdata_resized);
 imdata_resized=fix(imdata_resized);
 data_generated=reshape(imdata_resized',1,160000);
end
     
 