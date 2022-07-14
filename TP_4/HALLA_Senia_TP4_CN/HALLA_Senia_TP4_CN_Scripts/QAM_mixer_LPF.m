clear all
close all
clc
Fs=44100;%sampling rate
fc=8000;
%Square-root raised cosine Design:
D=5; %Filter delay in symbols
L=10; %samples per symbols
alpha=0.5; %Roll-off rc
h=srrc(D,alpha,L); %Square-root raised cosine (pulse shape & Matched filter)
pilots=[1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];%Barker code of length = 13
pilots_up_sampled= (pilots.'*[1 zeros(1,L-1)]).';
pilots_up_sampled=pilots_up_sampled(:);

%AT TX
m=conv(h,pilots_up_sampled); %Pulse shaping
figure;
[psd, f_v]=pwelch(m,[],[],[], Fs,'centered', 'twosided');
plot(f_v, 10*log10(psd));
title(['PSD of BaseBand signal '])

t=0:1/Fs:(length(m)-1)*1/Fs;
carrier = exp(1j*2*pi*fc*t);
%Modulation
y_PB=real(m.'.*carrier);
figure;
[psd, f_v]=pwelch(y_PB,[],[],[], Fs,'centered');
plot(f_v, 10*log10(psd));
title(['PSD of PassBand "modulated" signal '])

%demodulation
mixer_output = 2*((carrier)).*y_PB;
figure;
[psd, f_v]=pwelch(mixer_output,[],[],[], Fs,'centered');
plot(f_v, 10*log10(psd));
title(['PSD of the mixer output '])

%Using LPF
lh=2*ceil(5*D*L/2); % lh is even
lpf = firlpf(lh+1,3620,3790,Fs); %carrier removal filter LPF
v=conv(lpf, mixer_output);
figure;
[psd, f_v]=pwelch(v,[],[],[], Fs,'centered');
plot(f_v, 10*log10(psd));
title(['PSD of the LPF output '])


figure;
    stem(m)
    hold on
    stem(v)
    
    hold off

