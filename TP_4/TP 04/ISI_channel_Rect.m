clear all

clc
Fs=40000;%sampling rate
L=2; %samples per symbols, i.e. Symbol Time=L*1/Fs  ==> signaling rate = Fs/L

lh=60; % lh is even 
g=ones(1,L); %Rect pulse

pilots=[1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];%Barker code of length = 13
pilots_up_sampled= (pilots.'*[1 zeros(1,L-1)]).';
pilots_up_sampled=pilots_up_sampled(:);

%Base bande signal
y_1=conv(g,pilots_up_sampled); %Pulse shaping



%Channel
h_ch = firlpf(L*lh+1,4000,4680,Fs);
r=conv(h_ch,y_1);

figure;
    subplot(3,1,1)
stem(h_ch)
   title(['The Channel CIR'])
   
    
    subplot(3,1,2)
    stem(y_1);
    hold on
    stem(r);
    hold off
    title(['Transmitted signal VS the received signal'])
    subplot(3,1,3)
    stem(y_1);
    hold on
    stem(r(L*(lh/2):L*(lh/2)+length(y_1)));
    title(['s(t) VS r(t) delay deleted'])
    hold off
    
    figure;
    [psd, f_v]=pwelch(y_1,[],[],[], Fs,'centered');
    subplot(2,2,1)
    plot(f_v, 10*log10(psd));
    
    title(['PSD of BaseBand signal '])
     
    [psd, f_v]=pwelch(h_ch,[],[],[], Fs,'centered'); 
    subplot(2,2,3)
    plot(f_v, 10*log10(psd));
    title(['PSD of the Channel CIR'])
    
    subplot(2,2,2)
    [psd, f_v]=pwelch(r,[],[],[], Fs,'centered'); 
    plot(f_v, 10*log10(psd));   
    title(['PSD of received signal r(t)'])
    figure;
    subplot(2,1,1) 
    %Transmitted symbols
    stem(pilots)
    hold on
    %Band limited channel
    r2=reshape(r(1:(ceil(prod(size(r))/L)-1)*L), L, (ceil(prod(size(r))/L)-1));
    mached_fil_output1=conv2(g.',r2);
    mached_fil_output1=mached_fil_output1(:)/(g*g.');
    stem(mached_fil_output1((lh+1/2)*L:2*L-1:(lh+1/2)*L+(2*L-1)*(length(pilots)-1)))
    title(['Bandlimitted CH: transmitted symbols VS RX Mached Filter output'])
    hold off
    %Ideal Channel "illimited Bw"
    subplot(2,1,2)
     
    %Transmitted symbols
    stem(pilots)
    hold on
    r1=y_1;
    r2=reshape(r1(1:(ceil(prod(size(r1))/L)-1)*L), L, (ceil(prod(size(r1))/L)-1));
    mached_fil_output=conv2(g.',r2);
    mached_fil_output=mached_fil_output(:)/(g*g.');
    stem(mached_fil_output(L:2*L-1:end))
    title(['Ideal Ch "illimited Bw": transmitted symbols VS RX MF output '])
    hold off
eyediagram(r1(L/2:end),3*L);title('ideal ch')
eyediagram(r(L*((1+lh)/2):L*(lh/2)+length(y_1)),L);title('Band limitted CH')