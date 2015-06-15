%%% Plots the frequency response %%%
function []=frequency_response(data,tit,col)
    N=512;     
    delta_f=15*10^3; %subcarrier spacing    
    fs=N*delta_f; %sampling frequency
    ts=1/fs; %sampling period    
    data_sampled=fft(data)*ts;
    data_ss=fftshift(data_sampled);
    len=length(data_sampled)-1;
    ff=fs/len;
    f=[0:ff:fs]-fs/2;
    %stem(real(Hcentered),imag(Hcentered))
    plot(f,abs(data_ss),col)
    title(tit);
    xlabel('frequency');
    ylabel('frequency response');
end