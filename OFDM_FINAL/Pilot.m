%%% Pilot Generator %%%
function pilot_matrix=Pilot(cell_id)

%  N_slots_frame=20;
%  N_pilots_slot=2;
%  cell_id=100;
%  total_slots=N_slots_frame*N_pilots_slot;

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
    end
        
end
end
        
        