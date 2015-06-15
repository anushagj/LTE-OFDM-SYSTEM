%This function removes the first 36 bits of every symbol which belong to
%the cyclic prefix
function received_ncp=cyclic_prefix_remove(downsampled_data)
    received_matrix=reshape(downsampled_data,548,ceil(length(downsampled_data)/548));
    size_rx=size(received_matrix);
    rows=size_rx(1);
    columns=size_rx(2);
    received_ncp=[];
    received_ncp=[downsampled_data(37:548)];
    %end
end