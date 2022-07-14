clear all
close all
clc
Fs=44100;%sampling rate
fc=8000;
%Square-root raised cosine Design:
D=5; %Filter delay in symbols
L=10; %samples per symbols
alpha=0; %Roll-off rc
h=srrc(D,alpha,L); %Square-root raised cosine (pulse shape & Matched filter)
%effect of D:
figure;
hold on
for D=1:10
    figure(D)
    h=srrc(D,alpha,L); 
    [psd, f_v]=pwelch(h,[],[],[], Fs,'centered'); 
    subplot(2,1,1)
    plot(f_v, 10*log10(psd));
    title(['PSD of SRCC pulse shape span over D = ',num2str(D),' for alpha = 0']);
    subplot(2,1,2)
    stem(h)
    title('The pulse shape')
    pause(1)
end
hold off

pilots=[1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];%Barker code of length = 13
pilots_up_sampled= (pilots.'*[1 zeros(1,L-1)]).';
pilots_up_sampled=pilots_up_sampled(:);

figure;
for D=[1, 3, 5]
    stem(pilots_up_sampled)
    hold on
    axis([0 250 -1.2 1.2])
    h=srrc(D,alpha,L); 
    y_1=conv(h,pilots_up_sampled); %Pulse shaping
    stem(y_1)
    title(['The wave form of the baseband signal for D =' num2str(D)])
    pause(4)
    hold off
end
hold off
figure;

subplot(2,1,1)
[psd, f_v]=pwelch(y_1,[],[],[], Fs,'centered');
plot(f_v, 10*log10(psd));
title(['PSD of BaseBand signal for D =' num2str(D)])

subplot(2,1,2)
[psd, f_v]=pwelch(conv(ones(1,L),pilots_up_sampled),[],[],[], Fs,'centered');
plot(f_v, 10*log10(psd));
title(['PSD of BaseBand signal for Rectangular pulse shape'])