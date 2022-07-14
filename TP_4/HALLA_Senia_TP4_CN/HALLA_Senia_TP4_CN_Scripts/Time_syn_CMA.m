clear all
close all
clc
Fs=40000;%sampling rate
L=10; %samples per symbols, i.e. Symbol Time=L*1/Fs  ==> signaling rate = Fs/L

%Square-root raised cosine Design:
D=5; %Filter delay in symbols
alpha=0.5; %Roll-off rc
h=srrc(D,alpha,L); %Square-root raised cosine (pulse shape & Matched filter)

pilots=[1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];%Barker code of length = 13
pilots_up_sampled= (pilots.'*[1 zeros(1,L-1)]).';
pilots_up_sampled=pilots_up_sampled(:);

%Transmitted Base bande signal
 y_1=conv(h,pilots_up_sampled); %Pulse shaping

%Ideal Channel, zero ISI, zero Noise
r=y_1; 

%Receiver
mached_fil_output=conv(h,r);


%Sample time Synchronisation using constant modulus algorithm (CMA)
for p=0:L-1
    gamma(p+1)=mean(abs((mached_fil_output(p+L:L:L*length(pilots)+p))));
    var_y_p(p+1)=var(abs((mached_fil_output(p+L:L:L*length(pilots)+p)))-gamma(p+1));
end

[vla_var_y, p_est]=min(var_y_p);

%  MF outputs; superimpose downsampled values
figure;
stem(p_est+1:-1-p_est+length(mached_fil_output),(mached_fil_output(p_est+1:-1-p_est+length(mached_fil_output))));
hold on
plot(p_est+1:L:-1-p_est+length(mached_fil_output),(mached_fil_output(p_est+1:L:-1-p_est+length(mached_fil_output))),'ro'); 
title('Downsampling of MF Outputs')
hold off


% video illustrating all choices for downsampling

figure;

plot(1:length(mached_fil_output)-p_est,(mached_fil_output(p_est+1:end)));
hold on
for kk=1:L

stem(kk:L:length(mached_fil_output)-p_est-1+kk,(mached_fil_output(p_est+1:L:end)));
title('Symbol timing from CMA','fontsize',13);
pause(0.5)
end
hold off
