function [output_rayleigh,H]=rayleigh(input,snrDb)
Nc=length(input);
% Number of taps within the channel impulse response
Nch = 10;           
% Factor for exponentially decaying power profile:
c_att = 8;          
% Calculate variances of channel taps according to exponetial decaying power profile
var_ch = exp(-[0:Nch-1]/c_att);  
var_ch = var_ch/sum(var_ch);        % Normalize overall average channel power to one
snrLinear = 10^(snrDb/10);

% Generate random channel coefficients (Rayleigh fading)
        h = sqrt(0.5)*( randn(1,Nch) + j*randn(1,Nch) ) .* sqrt(var_ch); 
        % Calculate corresponding frequency response (needed for receiver part)
        h_zp = [h zeros(1,Nc-Nch)];                  % Zero-padded channel impulse response (length Nc)
        H = fft(h_zp);                               % Corresponding FFT 
        
        % Received sequence --> Convolution with channel impulse response
        y = conv(input,h_zp,'same');

        % Add AWGN 
        fs=7.68*10^6;
        BW=5*10^6;
        noOfSamples=2192;
        power = var(abs(input)); %determing the power of the symbol to be transmitted
        energy=power*noOfSamples;
        snrLinear = 10^(snrDb/10); %convertion signal to noise level into linear from decibels
   
        bitsPerSymbol = 4; %16QAM - log2(16)
    
        noiseFactor =sqrt((energy*fs*bitsPerSymbol)/(snrLinear*BW*512)); %determining the noise factor
       % generating normalized noise in complex form with mean 0 and variance 1
    
        n =(randn(1,length(input))+1i*randn(1,length(input)))*.5*noiseFactor ;
        y = y + n;

        % Discard last Nch-1 received values resulting from convolution
        %y(end-Nch+2:end) = []; 
        output_rayleigh=y;
end