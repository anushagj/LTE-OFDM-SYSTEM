%%%%%%%%                    OFDM  SIMULATION                      %%%%%
% This project is being developed by Adharsh Kumar and Anusha Gururaj %
% Instead of generating random data, we use a simple binary image     %
% as transmitted data and compare after reception                     %

clc;
clear all;
close all;

choice=input('Do you want to work with random data or an image? 1 for random and 2 for image : ');
channel_type=input('Select the Channel type:- 0 for AWGN type, 1 for Rayleigh--> ');
disp('NOTE: Press any key to move to the next checkpoint');

N=512; %total number of subcarriers,also size of FFT
%SNR_DB=[-20:4:40];
SNR_DB=[-10 -5 -2.5 0 2.5 5 7.5 10 12.5 15 20 25 ]; % SNR values
count=0;

%% In an LTE frame
slots_per_frame=20; 
symbols_per_slot=7; 
symbols_per_slot_pilot=2;
symobols_per_slot_data=5;
r=0;
data_demod=[length(SNR_DB),160000];


%%%% Generating the random data %%%%%%

% Uncomment the below line if you want to use randomly generated data
% instead 
if(choice==1)
    data=randi([0,1],1,160000);%slots_per_frame*(1000*symbols_per_slot_pilot+1200*symobols_per_slot_data)
end
if(choice==2)
    data=image_data_generator();
end

% Checkpoint_1(a)---Time and Frequency domains of data generating module
disp('Checkpoint_1(a)---Time and Frequency domains of data generating module');
pause
subplot(2,1,1);
time(data(1:200),'time response','B');
subplot(2,1,2);
frequency_response(data(1:200),'frequency response','B');


%=========================================================================%
%% Pilot Generation %%
% Generating per frame
Nc=1600;
N_CP=1; %for normal CP
x1=zeros(1,1701);
x2=zeros(1,1701);
c=zeros(1,101);
temp_matrix=zeros(1,50);
pilot_matrix=[];
x1(1)=1;% Intializing the first m-sequence with x(0)=1 (3gpp pg98)
b=[];
cell_id=1;


for n_s=1:40 %n_s - slot number within a radio frame
    for l=1:3:4 % l-OFDM symbol number within the slot, first and fifth slots.
        c_init=power(2,10)*(7*(n_s+1)+l+1)*(2*cell_id+1)+2*cell_id+N_CP;
        b=dec2bin2(c_init);
            
       
        for ii=length(b):-1:1
                x2(ii)=b(ii);
        end
        for jj=1:1670
                x1(jj+31)=(mod(x1(jj+3)+x1(jj),2));
        end
        for kk=1:1670
                x2(kk+31)=(mod(x2(kk+3)+x2(kk+2)+x2(kk+1)+x2(kk),2));
        end
        for ll=1:101
                c(ll)=(mod(x1(ll+Nc)+x2(ll+Nc),2));
        end
        
       % PILOT MODULATION USING QPSK %
        pilot_symbol=modulator_QPSK(c);
        l=numel(pilot_symbol);
       
    end
    pilot_matrix=[pilot_matrix, pilot_symbol];
    
        
end 


%%% Checkpoint 1.b.i--- Time ,Frequency and Constellation Plot of QPSK
%%% modulated pilot samples
        if(count==0)
            disp('Checkpoint 1.b.i--- Time ,Frequency and Constellation Plot of QPSK');
            pause
        end
        figure;
        subplot(2,1,1);
        time(real(pilot_matrix(1:100)),'Time Response of 100 QPSK Modulated Pilot Samples(Real Part)','B');
        hold on;
        time(imag(pilot_matrix(1:100)),'Time Response of 100 QPSK Modulated Pilot Samples(Imaginary)','R');
        subplot(2,1,2);
        frequency_response(pilot_matrix(1:100),'Freq Response of 100 QPSK Modulated Pilot Samples','B');
        
        
        figure;
        scatter(real(pilot_matrix),imag(pilot_matrix));
        xlabel('In phase');
        ylabel('Quarature phase');
        title('Constellation plot of Pilot Symbols')
 
%========================================================================%

data_counter=1;
pilot_counter=1;
null_matrix=[]; % used for multiplexing in the absence of pilot bits
for each_slot=1:slots_per_frame
    for each_symbol=1:symbols_per_slot
        
          %%%%%%%Modulating random data bits using 16 QAM %%%%%%%%
          
          % Taking the first 1200 data bits and modulating it using QAM%
          %  In this case symbol data is present in 300 carriers
          if (rem(each_symbol-1,4)~=0)
              data_symbol=modulator_QAM(data(data_counter:data_counter+1199));
              data_counter=data_counter+1200;
              
          % In this case symbol data is present in 250 carriers and hence 
          % we modulate the first 1000 bits only %
          else
              data_symbol=modulator_QAM(data(data_counter:data_counter+999));
              data_counter=data_counter+1000;
            
          end  
          
          
%%%%%% Checkpoint 1.b.ii---- Time, Frequency and Constellation plots of 16QAM modulated data samples 
          
          if(count==0)
            disp('Checkpoint 1.b.ii---- Time, Frequency and Constellation plots of 16QAM modulated data samples');
            pause
          end
          if each_symbol==1 && each_slot==1
                figure;
                subplot(2,1,1);
                time(real(data_symbol(1:100)),'Time Response of 100 16QAM Modulated Samples','B');
                hold on;
                time(imag(data_symbol(1:100)),'Time Response of 100 16QAM Modulated Samples(I-blue Q-red)','R');
                subplot(2,1,2);
                frequency_response(data_symbol(1:100),'Freq Response of 100 16QAM Modulated Samples','B');
            end
           % Generating Constellation Plot
            if each_slot==1 && each_symbol==1
                 figure;
                 scatter(real(data_symbol),imag(data_symbol));
                 xlabel('In phase');
                 ylabel('Quadrature phase');
                 title('Constellation plot');
            end
            
            
%=========================================================================%           
           
           %%%%%%%%%%%Multiplexing Data and Pilot %%%%%%%%%
           
           if(rem(each_symbol-1,4)~=0)
               multiplexed_data=multiplexing(data_symbol,null_matrix,each_symbol);
           else
               multiplexed_data=multiplexing(data_symbol,pilot_matrix(pilot_counter:pilot_counter+49),each_symbol);
               pilot_counter=pilot_counter+50;
           end 
%=========================================================================%           
           
           %%%%%%%%%%Subcarier mapping%%%%
           
           mapped_data=zeros(512,1);
           subcarrier_index=[-150:-1 1:150]; %300 usable subcarriers range taken from -150 to 150 so the DC carrier is at zero
           for zz=1:300
                  mapped_data(subcarrier_index(zz)+512/2+1)=multiplexed_data(zz);
           end  
%=========================================================================%        
           
           %%% IFFT %%%%%%
           
           output_ifft=ifft_block(mapped_data);
           
           
           %%%Checkpoint 1.c---Output of the IFFT 
           if(count==0)
                disp('Checkpoint 1.c---Output of the IFFT');
                pause
           end
           if each_slot==1 && each_symbol==1
               figure;
               subplot(2,1,1);
               time(real(output_ifft(1:100)),' Output of the IFFT for first 100 carriers(real)','B');
               hold on;
               time(imag(output_ifft(1:100)),' Output of the IFFT for first 100 carriers(imag)','R');
               subplot(2,1,2);
               frequency_response(output_ifft(1:100),'Frequency response of IFFT','B');
           end         
%=========================================================================%           
           
           %%% Cyclic Prefix %%
           
           sequence_cp=cyclic_prefix(output_ifft);

            %%%Checkpoint 1.d---Output of the ICP in time domain  
            if(count==0)
                disp('Checkpoint 1.d---Output of the ICP in time domain')
                pause
            end
            if each_slot==1 && each_symbol==1
               figure;
               plot(1:10);
               zoom on
               % zoom in on the plot
               sequence_cp_zp=[zeros(36,1); sequence_cp];
               time(sequence_cp_zp(1:36),'','W');
               hold on;
               time(sequence_cp_zp(37:572),' Time response of the rest of the sequence','R');
               hold on;
               time(sequence_cp(1:36),' Time response of the CP','B');
               legend('','Without Cyclic Prefix','Cyclic Prefix','Location','SouthOutside');
           end
           
%=========================================================================%           
           

           %%% Upsampling %%%
           
           upsampled_data=zeros(1,length(sequence_cp)*4);
           for i=0:1:length(sequence_cp)-1
               upsampled_data(1,4*i+1)=sequence_cp(i+1);
           end;
           
           %%%Checkpoint 1.e---Output of the upsampler%%%           
           if(count==0)
                disp('Checkpoint 1.e---Output of the upsampler')
                pause
           end
           if each_slot==1 && each_symbol==1
            figure;
            subplot(2,1,1);
            time(real(upsampled_data),'Time Response of Upsampler','Y');
            hold on;
            time(imag(upsampled_data),'Time Response of Upsampler(I-yellow Q-green)','G');
            subplot(2,1,2);
            frequency_response(upsampled_data,'Freq Response of Upsampler','B');
           end
           
%=========================================================================%           
          
           % TX Filter%

           % Order 60 filter coeffiecents %
           h=[-0.000784349139504251,-0.000176734735785689,0.000724012692320556,0.00118554682461376,0.000561224222290113,-0.00100201539035489,-0.00222659432222206,-0.00152383506917547,0.00128589170200708,0.00400894535406963,0.00348933001770781,-0.00115361405151310,-0.00650114618880027,-0.00691923964988450,5.99346493618398e-18,0.00952959027858301,0.0123552446794401,0.00303688616696274,-0.0127969830957593,-0.0206395422737169,-0.00938114247892921,0.0159261635482031,0.0337387363038249,0.0222822647110203,-0.0185216204263869,-0.0586008851851700,-0.0540413312902093,0.0202371971192971,0.145587146371200,0.264043788776860,0.312554129058022,0.264043788776860,0.145587146371200,0.0202371971192971,-0.0540413312902093,-0.0586008851851700,-0.0185216204263869,0.0222822647110203,0.0337387363038249,0.0159261635482031,-0.00938114247892921,-0.0206395422737169,-0.0127969830957593,0.00303688616696274,0.0123552446794401,0.00952959027858301,5.99346493618398e-18,-0.00691923964988450,-0.00650114618880027,-0.00115361405151310,0.00348933001770781,0.00400894535406963,0.00128589170200708,-0.00152383506917547,-0.00222659432222206,-0.00100201539035489,0.000561224222290113,0.00118554682461376,0.000724012692320556,-0.000176734735785689,-0.000784349139504251];     
           output_filter=conv(upsampled_data,h,'same');
                
           %Checkpoint 1.f--Frequency domain input to TX Filter, the frequency 
           %response of the Tx. Filter and the output of the filter
           if(count==0)
                disp('Checkpoint 1.f--Frequency domain input to TX Filter, the frequency response of the Tx. Filter and the output of the filter');
                pause
           end
           if each_slot==1 && each_symbol==1
               figure;
               subplot(2,2,1);
               frequency_response(upsampled_data(1:2192),'Freq domain input to Tx filter','B');
               subplot(2,2,2);
               frequency_response(h,'Freq response of the TX Filter','B');
               subplot(2,2,3);
               frequency_response(output_filter(1:2192),'output of filter','B');   
           end        
           
           %Checkpoint 1.g--Display analog signal
           if(count==0)
                disp('Checkpoint 1.f--Frequency domain input to TX Filter, the frequency response of the Tx. Filter and the output of the filter');
                pause
           end
           if each_slot==1 && each_symbol==1
               figure;
               fs=7.68*10^6;
               t=[0:5.94*10^-11:1/fs];
               t=t(1:2192);
               plot(t,abs(output_filter(1:2192)));
               title('Analog output of filter');
               xlabel('time');
               ylabel('amplitude');                 
           end    
           legend('Oversampling rate: 7.68/1.15');
%=========================================================================%  
           
           %%%%% AWGN Channel and Rayleigh %%%%%
           
           for ss=1:length(SNR_DB)            
            
             if(channel_type==0);
                
                output_channel=awgnChannel(output_filter,SNR_DB(ss));
                %Checkpoint 2.a Received I and Q Response
                if(count==0)
                    disp('Checkpoint 2.a Received I and Q Response');
                    pause
                end
                if  SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1 
                    
                    figure;
                    subplot(2,1,1);
                    time(real(output_filter(200:400)),'I and Q phase response (I-Blue, Q-Red) for 200 samples','B');
                    hold on;
                    time(imag(output_filter(200:400)),'I and Q phase response (I-Blue, Q-Red) for 200 samples','R');
                    
                    subplot(2,1,2);
                    
                    time(real(output_channel(200:400)),'I(Red) and Q(Blue) channel response ','B');
                    hold on;
                    time(imag(output_channel(200:400)),'I(Red) and Q(Blue) channel response ','R');
                end            
           
             else(channel_type==1)
            
                [output_channel,HH]=rayleigh(output_filter,SNR_DB(ss));
                    if(count==0)
                        disp('Checkpoint 2.a Received I and Q Response');
                        pause
                    end
                    if  SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1 
                        figure;
                        subplot(2,1,1);
                        time(real(output_filter(200:400)),'I and Q phase response (I-Blue, Q-Red) for 200 samples','B');
                        hold on;
                        time(imag(output_filter(200:400)),'I and Q phase response (I-Blue, Q-Red) for 200 samples','R');
                    
                        subplot(2,1,2);
                    
                        time(real(output_channel(200:400)),'I(Red) and Q(Blue) channel response ','B');
                        hold on;
                        time(imag(output_channel(200:400)),'I(Red) and Q(Blue) channel response ','R');
                    end
              end
        
%=========================================================================%           
           
            
                %%%% Receiver %%%%
       
                % RX FILTER % 
         
                % filter-coefficents
                h=[-0.000784349139504251,-0.000176734735785689,0.000724012692320556,0.00118554682461376,0.000561224222290113,-0.00100201539035489,-0.00222659432222206,-0.00152383506917547,0.00128589170200708,0.00400894535406963,0.00348933001770781,-0.00115361405151310,-0.00650114618880027,-0.00691923964988450,5.99346493618398e-18,0.00952959027858301,0.0123552446794401,0.00303688616696274,-0.0127969830957593,-0.0206395422737169,-0.00938114247892921,0.0159261635482031,0.0337387363038249,0.0222822647110203,-0.0185216204263869,-0.0586008851851700,-0.0540413312902093,0.0202371971192971,0.145587146371200,0.264043788776860,0.312554129058022,0.264043788776860,0.145587146371200,0.0202371971192971,-0.0540413312902093,-0.0586008851851700,-0.0185216204263869,0.0222822647110203,0.0337387363038249,0.0159261635482031,-0.00938114247892921,-0.0206395422737169,-0.0127969830957593,0.00303688616696274,0.0123552446794401,0.00952959027858301,5.99346493618398e-18,-0.00691923964988450,-0.00650114618880027,-0.00115361405151310,0.00348933001770781,0.00400894535406963,0.00128589170200708,-0.00152383506917547,-0.00222659432222206,-0.00100201539035489,0.000561224222290113,0.00118554682461376,0.000724012692320556,-0.000176734735785689,-0.000784349139504251];
                %h=[-4.16883250902603e-05,-0.000562112610859686,-0.000668172258129623,-0.000200366236118458,0.000575738390893345,0.00104558986233150,0.000661028519118995,-0.000513664719458405,-0.00161475528998131,-0.00152174570424262,0.000111932099033970,0.00221646960370360,0.00287217061851728,0.000943368102579544,-0.00252353600280363,-0.00463599353503190,-0.00293518443132191,0.00206562617985091,0.00651963900819132,0.00602886680469975,-0.000281546938115915,-0.00799051464772451,-0.0102018045957769,-0.00342795512612827,0.00827163881541604,0.0152088969695628,0.00970137036555585,-0.00629737236414732,-0.0205958112965991,-0.0193996445836007,0.000451197196714892,0.0257609669932866,0.0344095580701570,0.0126523522504150,-0.0300554155900923,-0.0615066056698756,-0.0453644633626440,0.0329002136074827,0.150853332876701,0.257163963472810,0.299848866961441,0.257163963472810,0.150853332876701,0.0329002136074827,-0.0453644633626440,-0.0615066056698756,-0.0300554155900923,0.0126523522504150,0.0344095580701570,0.0257609669932866,0.000451197196714892,-0.0193996445836007,-0.0205958112965991,-0.00629737236414732,0.00970137036555585,0.0152088969695628,0.00827163881541604,-0.00342795512612827,-0.0102018045957769,-0.00799051464772451,-0.000281546938115915,0.00602886680469975,0.00651963900819132,0.00206562617985091,-0.00293518443132191,-0.00463599353503190,-0.00252353600280363,0.000943368102579544,0.00287217061851728,0.00221646960370360,0.000111932099033970,-0.00152174570424262,-0.00161475528998131,-0.000513664719458405,0.000661028519118995,0.00104558986233150,0.000575738390893345,-0.000200366236118458,-0.000668172258129623,-0.000562112610859686,-4.16883250902603e-05];
                Rx_filter_output=conv(output_channel,h,'same').';
                
                              
                if (channel_type==1)
                    % Equalisation
                    G_ZF =1./ HH; 
                    Rx_fft=fft(Rx_filter_output);
                    equ_op_fft=G_ZF'.*Rx_fft;
                    equ_op=fft(equ_op_fft); 
                    
                % Checkpoint --Before Rx Filter and After Rx.Filter 
                    if(count==0)
                        disp('Checkpoint 3a.--Before Rx Filter and After Rx.Filter')
                        pause
                    end
                              
                if  SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1
                    figure;
                    subplot(2,1,1);
                    frequency_response(output_channel,'Freq response before Rx. filter','B');
                    subplot(2,1,2);
                    frequency_response(Rx_filter_output,'Freq response after Rx.filter','R');
                end
                
                % Checkpoint 3a.--Before and After Equalisation
                if  SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1
                    figure;
                    subplot(2,1,1);
                    frequency_response(equ_op,'Freq response before Equalization','B');
                    subplot(2,1,2);
                    frequency_response(Rx_filter_output,'Freq response after Equalisation','R');
                end
              
                else 
                if  SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1
                    figure;
                    subplot(2,1,1);
                    frequency_response(output_channel,'Freq response before Rx. filter','B');
                    subplot(2,1,2);
                    frequency_response(Rx_filter_output,'Freq response after Rx.filter','R');
                end             
                end 
%=========================================================================%              
     
              % Downsampler %
              if(channel_type==0)
               downsampled_data=downsampling(Rx_filter_output);
              else
               downsampled_data=downsampling(equ_op);
              end  
%=========================================================================%               
               
               % Removing cyclic prefix %
      
               data_ncp=cyclic_prefix_remove(downsampled_data);
               
%=========================================================================%             
                            
               % FFT %
               output_fft=fft_block(data_ncp);               
              
               
%=========================================================================%            
               
              % subcarrier demapper %       
               
              demapper_output=subcarrier_demapping(output_fft);
               
               
%=========================================================================%               
               
              % demultiplexer %       
              
              [data_d, pilot]=demultiplexing(demapper_output,each_symbol);             
               
               
%=========================================================================%               
               
              % Demodulate only data symbols
               demod_data=demodulator_QAM(data_d);        
               
              
               Rx_data(ss,r+1:r+length(demod_data))=demod_data;
   
             
               % Checkpoint 3.b-Demodulated signal(200 samples) in time and frequency domain 
               if(count==0)
                   disp('Checkpoint 3.b-Demodulated signal(200 samples) in time and frequency domain for SNR=-10dB ');
                   pause
               end
               if SNR_DB(ss) == 5 && each_symbol==1 && each_slot==1 
                 figure;
                 subplot(2,1,1);
                 time(Rx_data(200:400),'Time domain of demodulated signal','B');
                 subplot(2,1,2);
                 frequency_response(Rx_data(200:400),'Frequency domain of demodulated signal','R');
               end                  
                 
                  
               % Checkpoint 3.c-- Comparing for SNR_dB=-10 and SNR_dB=10 and SNR_dB=0 
               if(count==0)
                    disp('Checkpoint 3.c-- Comparing for SNR_dB=-10 and SNR_dB=10 and SNR_dB=0');  
                    pause
               end
             
               if SNR_DB(ss) == -10  && each_symbol == 1 && each_slot == 1
                 SNR_db=-10;                
                 figure;
                 subplot(3,1,1);
                
                 time(data(200:400),'Time Response of Tx Data Bits at SNR -10 db','B');
                 subplot(3,1,2);
                
                 time(Rx_data(200:400),'Time Response of Rx Data Bits at SNR -10 db','R');
                 subplot(3,1,3);
                 time(data(200:400) - Rx_data(200:400),'Comparing the Tx and Rx bits at-10db','G');
               end    
                
               if SNR_DB(ss) == 0  && each_symbol == 1 && each_slot == 1
                 SNR_db=0;                 
                 
                 figure;
                 subplot(3,1,1);
                
                 time(data(200:400),'Time Response of Tx Data Bits at SNR 0 db','B');
                 subplot(3,1,2);
                
                 time(Rx_data(200:400),'Time Response of Rx Data Bits at SNR 0 db','R');
                 subplot(3,1,3);
                 time(data(200:400) - Rx_data(200:400),'Comparing the Tx and Rx bits at 0','G');
               end    
               
             
               if SNR_DB(ss) == 10  && each_symbol == 1 && each_slot == 1
               SNR_db=10;  
               
                 figure;
                 subplot(3,1,1);
                 time(data(200:400),'Time Response of Tx Data Bits at SNR 10 db','B');
                
                 subplot(3,1,2);
                 time(Rx_data(200:400),'Time Response of Rx Data Bits at SNR 10 db','R');
                
                 subplot(3,1,3);
                 time(data(200:400) - Rx_data(200:400),'Comparing the Tx and Rx bits at 10db','G');                   
               end
               count=count+1;
        end
        r=r+length(demod_data);
    end    
end            
if(choice==2)           
    image_data_receiver(Rx_data(12,:));  
end
 
k=4;
for ss=1:length(SNR_DB)
      
   error(ss)=length(find(xor(data(1:8000),Rx_data(ss,1:8000))))/8000;
   theoryBer = (1/k)*3/2*erfc(sqrt(k*0.1*(10.^(SNR_DB/10))));
     
end

figure;
semilogy(SNR_DB,error,'B');
hold on
semilogy(SNR_DB,theoryBer,'R');
title('BER curve');
xlabel('SNR');
ylabel('BER');
axis([-10 20 10^-2.6 1]);
legend('Simulated value','theoretical value');
  
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
           
 












