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

%Base bande signal
y_1=conv(h,pilots_up_sampled); %Pulse shaping
figure;



for lh=2:2:44
    [psd, f_v]=pwelch(y_1,[],[],[], Fs,'centered');
    plot(f_v, 10*log10(psd));
    hold on
    title(['PSD of BaseBand signal '])
    h_demo = firlpf(L*lh+1,4470,4480,Fs); 
    [psd, f_v]=pwelch(h_demo,[],[],[], Fs,'centered'); 
    plot(f_v, 10*log10(psd));
    title(['PSD of LPF that spans over ' num2str(L*lh+1)])
    hold off
    pause(1)
end
hold off
