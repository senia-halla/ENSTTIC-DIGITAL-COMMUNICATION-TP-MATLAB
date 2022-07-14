%do_sym_sync_earlylate.m -- Early-Late sampling time control 
clear, clc
KC=1; % 1/0 for timing recovery or not
Ns=80; % Nb of sample per symbol
Ts=1; %Symbol time
T=Ts/Ns; % Sampling time
%Square Root Raised Cosine Filter with upsampling rate of Ns - P6.1(h)
rof=0.5; % Roll-off factor  
nos=6; % Number of symbols of SRRC filter impulse response (filter span)
g=rcosdesign(rof,nos,Ns); % TX pulse shape: SRRC filter coeffs (impulse response) 
Ng=length(g); % and its length
h=fliplr(g); % matched filter(SRRC)  in baseband (Impulse response of RX)

Es=1; b=1; SNRbdB=8; 
SNRb=10^(SNRbdB/10); sigma2=(Es/b)/SNRb; sgmsT=sqrt(sigma2/T); 
dT=Ts/2; dTN=ceil(dT/T); delta=0.01;
N_Iter=2000;
nx=100;
for ts=[3.1 2.9 2.1]*Ts
   tsN=ceil(ts/T); % Initial sampling time in number of sample times 
   dd=round(Ng/Ns*2)-floor(ts/Ts)-nos+9; % Detection delay 
   ch_input=zeros(1,Ng+Ns-1); % Channel input buffer 
   rs=zeros(1,Ng+Ns-1); 
   ys=zeros(1,Ns*10); 
   ds=zeros(1,nx+dd); 
   Ds=zeros(1,nx);
   nobe=0;
   for k=1:N_Iter
       d(k)=(rand>0.5)*2-1; % BPSK-modulated data symbol
       ds=[ds(2:end) d(k)];
       ch_input=[ch_input(Ns+1:end) d(k)*ones(1,Ns)];
       for n=1:Ns % through channel 
           rn=ch_input(end-Ns+n-Ng+1:end-Ns+n)*g' +sgmsT*randn;
           rs=[rs(2:end) rn/Ns]; % Received signal buffer updated 
           yn=rs(end-Ng+1:end)*h'; % Rx Matched (SRRC) filter output
           ys=[ys(2:end) yn]; % RCVR filter output buffer updated
       end
       dif=abs(ys(tsN-dTN))-abs(ys(tsN+dTN));
       if KC>0 % Early or Late by Eq.(8.5.1)
           if dif>delta, 
               ts=ts-T; % T is the sampling time period
           elseif dif<-delta, 
               ts=ts+T; 
           end
       end
       ts_history(k)=ts; tsN=ceil(ts/T); % Adjusted sampling time 
       D=(ys(tsN)>0)*2-1; 
       Ds=[Ds(2:nx) D]; % Detection and DTR buffer 
       nobe=nobe+(D~=ds(nx));
       if nobe>nx, 
           break; 
       end
   end
   pobe=nobe/k
   plot(ts_history); hold on
end
