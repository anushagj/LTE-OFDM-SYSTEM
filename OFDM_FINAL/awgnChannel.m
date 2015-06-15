%simulates AWGN channel using SNR value
%the output of the transmit filter is passed as a parameter and the desired signal to noise ratio in decibel
function channel_Op=awgnChannel(input_matrix,snr_Db)
    fs=7.68*10^6;
    bw=5*10^6;
    no_of_samples=2192;
    power = var(abs(input_matrix)); %determing the power of the symbol to be transmitted
    energy=power*no_of_samples;
    snrLinear = 10^(snr_Db/10); %conversion signal to noise level into linear from decibels
    factor =sqrt((energy*fs*4)/(snrLinear*bw*512)); %determining the noise factor
    % generating zero mean complex noise
    n =(randn(1,length(input_matrix))+1i*randn(1,length(input_matrix)))*.5*factor ;
    channel_Op = input_matrix + n; % adding the noise to the symbol to be transmitted
end