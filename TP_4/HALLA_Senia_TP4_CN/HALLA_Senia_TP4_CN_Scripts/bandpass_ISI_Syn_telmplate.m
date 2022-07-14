% bandpass modem simulator
clear all
close all
clc
%(i) Modem parameters; 
Fs=44100;%sampling rate
fc=8000;
L=10; %samples per symbols
D=5; %Filter delay in symbols
alpha=0.5; %Roll-off rc
h=srrc(D,alpha,L); %Square-root raised cosine (pulse shape & Matched filter)
lh=60; % lh is even
h_demo = firlpf(lh+1,3620,3790,Fs); %carrier removal filter LPF
M=4; %Modulation order
symb=(1/sqrt(2)).*[(-1-1j)  (1+1j)  (-1+1j) (1-1j)];
                     %00      %01     %10    %11
data=[1:10];
aa=dec2bin(data);
[LL, CC] = size(aa);
if (LL*CC/log2(M)) > floor(LL*CC/log2(M)) nL = floor(LL*CC/log2(M))+1; %Ex: floor(3.1)=floor(3.99)=3
else nL=(LL*CC/log2(M));
end;
assert(nL*log2(M)>=LL*CC,'nL*log2(M) should be >= LL*CC')
bits=[zeros(nL*log2(M)-LL*CC, 1);(aa(:))];
bit_words=bin2dec(reshape(bits, nL, log2(M)));
%a = 2*bit_words+1-M;
j=1;
for i=1:2:length(bits)-1
    switch bits(i:i+1)
        case '00'.'
            a(j)=symb(1);
        
        case '01'.'
            a(j)=symb(2);
        case '10'.'
            a(j)=symb(3);
         case '11'.'
             a(j)=symb(4);
     end
            j=j+1;
           
end

a=a(:);
[MM, NN]=size(a(:));

%Add pilot for Frame synchronisation, i.e. determine the index of the 1st symbol
pilots=[1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];%Barker code of length = 13
b=[pilots a.'];
N=length(b);

%(ii) Transmitter;
for i=1:N sig(:,i)=[b(i) zeros(1,L-1) ].';end; %Up-Sampling to L samples per symbols
sigl=sig(:);
y_1=conv(h,sigl); %Pulse shaping


%QAM Carrier modulation
[y_1_l, y_1_c]=size(y_1);
%%define the time vector
t=.........
carrier = exp(1j*2*pi*fc*t);
qam_pb=real(carrier.'.*y_1);  
%display the spectrum of qam_pb

%(iii) Channel Impairments; 
%implemented in low pass, the output of the channel suold be real PassBand
tau=03;  % channel delay: an integer number of sampls

output_Lp_ch=[zeros(tau,1); input_ch(:)];
%H=exp(4j*pi/5); % complex-valued gain for flat channel model
%H=1; ideal channel
noise=0.00; % set the the variance of complex AWGN
w=randn(length(output_Lp_ch),1);
output_Lp_ch = output_Lp_ch*H +sqrt(noise/2)*(w + 1j*w);%flat fading + AWGN
outpu_ch=
% output of the channel suold be real PassBand signal!!

f_delta=0.004*fc; %frequency offset, f?
phase_diff=0;
%qam_pb_r=qam_pb;

%(iv) Receiver.
%carrier removal
[xl, xc] = size(outpu_ch);
t=0:1/Fs:(xl-1)*1/Fs;
carrier_rx = %define the Rx local oscillator 
%%in the second experience, try to include f_delta in carrier_rx
% change f_delta  slowly and observe the effect.

r_demod=[(2*(conj(carrier_rx).').*(outpu_ch))]; % Mixer
%show the specrum


r_bb=conv(.........;%LPF removes higher frequency
    
%display the spectrum
y_2=conv(..............; %Matched Filter output
y_2=y_2(2*D*L+lh/2+1:end); % remove delay of Pulse shaping + Matched filter + Demod LPF

%display the eye diagram

%display the spectrum

%Sample time Synchronisation using constant modulus algorithm (CMA)
for p=0:L-1
    gamma(p+1)=mean(abs((y_2(p+L:L:L*N+p))));
    var_y_p(p+1)=var(abs((y_2(p+L:L:L*N+p)))-gamma(p+1));
end
% CMA criterion
[vla_var_y, p_est]=min(var_y_p);

% To determine the index of the first symbol, use cross-correlation between y and pilots. 

y=y_2(p_est:L:end);
CorrOutput=conv((y),fliplr(pilots));% cross-correlation to find the index of the pilot
[value,indx] = max(abs(CorrOutput));
pilot_rx=y(indx-12:indx);%first symbol of the pilot sequence is at: index-13+1
y=y(indx+1:MM+indx);%first information symbol is at iindx + 1

% frequency recovery

phase_diff=angle(pilots./pilot_rx);
polynm = polyfit(1:13,unwrap(phase_diff),1);

figure; 
stem(unwrap(angle(b(14:33))-angle(y))*180/pi)
hold on
plot((180/pi).*(polynm(2)+polynm(1)*(14:13+length(y))));
title('phase recovery using linear interpolation')
hold off
%uncomment the following expression, and compare with the previous result 
%y=y.*exp(1j*(polynm(2)+polynm(1)*(14:13+length(y))));

%flat fading channel equalization
CorrOutput2=conv((pilot_rx.*exp(1j*(polynm(2)+polynm(1)*(1:13)))),fliplr(pilots));% cross-correlation
H_est = max(CorrOutput2)/length(pilots);
%uncomment the following expression, and compare with the previous result 
%y=y./H_est;

%Optimum Detector:

bits_detected=[];
bit_words= dec2bin([0 1 2 3]);
for i=1:length(y)  
    r_l_s1=abs(y(i)- symb(1));
    r_l_s2=abs(y(i)- symb(2));
    r_l_s3=abs(y(i)- symb(3));
    r_l_s4=abs(y(i)- symb(4));  
    samples=[r_l_s1,r_l_s2,r_l_s3,r_l_s4];
    [minimum ,m]=min(samples);
    
    bits_detected=[bits_detected bit_words(m,:)];
   
end

r_bit_no_zer=bits_detected(nL*log2(M)-LL*CC+1:end);
r_bits=reshape(r_bit_no_zer, LL,CC);


%Taux d'erreur
in=bin2dec(bits(:));
out=bin2dec(r_bits(:));
bin2dec(r_bits);
[error, ratio]=symerr(in,out)