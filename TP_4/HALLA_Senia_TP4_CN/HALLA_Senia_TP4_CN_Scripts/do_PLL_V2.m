%do_PLL.m
% simulates a PLL with integrator
clear, clc
Ts=1e-5; % Symbol time
Ns=40;    % Samples/Symbol
T=Ts/Ns;  % Sample time 
N_Iter=400; tt=[0:N_Iter-1]*T; % Time range of simulation 
wc=2*pi*4/Ts; %carrier 8*pi/Ts
% time varying phase of input signal (Thita(t))
Thita= pi/4 + pi/50*sin(0.01*pi/T*tt); %vi=sin(wc*t+Thita) is the Input of the PLL
 
% To simulate a PLL with loop filter replaced by an integrator 
lb_ve=10; b_ve=zeros(1,lb_ve); % Initialize the buffer for ve(t) 
% Initialize the phase estimate & integral of LF output
Thita_hat(1)=0; 
vLF(1)=0; KT=1/Ts; %loop filter replaced by an integrator
for n=1:N_Iter
 t=tt(n); 
 vi(n)=sin(wc*t+Thita(n)); % Input to PLL 
 vVCO(n)=cos(wc*t+Thita_hat(n)); % VCO output
 ve(n)=vi(n)*vVCO(n); % Input to LF (i.e. to the integrator)
 vLF(n+1)=vLF(n)+(ve(n)-b_ve(1))*T; % LF output (Eq.(8.2.15)) 
 
 b_ve=[b_ve(2:lb_ve) ve(n)]; % Buffer for ve
 Thita_hat(n+1)= Thita_hat(n)+KT*vLF(n+1); % Phase estimate (Eq.(8.2.14)) 
      if Thita_hat(n+1)>pi, 
          Thita_hat(n+1)= Thita_hat(n+1)-2*pi;
      elseif Thita_hat(n+1)<-pi, 
          Thita_hat(n+1)= Thita_hat(n+1)+2*pi;
      end
end

figure; 
subplot(211), plot(tt,Thita,'k', tt,Thita_hat(1:N_Iter),'r')
title('PLL with loop filter replaced by an integrator');
subplot(212),
plot(tt,cos(wc*tt+Thita),'r', tt,cos(wc*tt+Thita_hat(1:N_Iter)),'k')
 