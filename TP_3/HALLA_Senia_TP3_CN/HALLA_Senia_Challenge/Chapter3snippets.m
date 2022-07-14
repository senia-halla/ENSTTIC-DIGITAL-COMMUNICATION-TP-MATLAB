% Chapter 3 Code Snippets

%% Scatter plot example for QPSK or BPSK
N = 160; %number of symbols
M = 4; %4=QPSK or 2=BPSK
if(M==2)
   a = (2*round(rand(1,N))-1); %noiseless I
elseif(M==4)
   a = (2*round(rand(1,N))-1) ... %noiseless I
       + 1j*(2*round(rand(1,N))-1); %and add Q
   a = a/sqrt(2); %unit length QPSK symbols
end
EbperN0dB = 6;
EbperN0 = 10^(EbperN0dB/10);
varw = (EbperN0*log2(M))^(-1)/2; %per channel sample var
w = sqrt(varw)*(randn(1,N) + 1j*randn(1,N));
y = a + w; %add noise
% make scatter plot
figure;
plot(real(y),imag(y),'x','MarkerSize',8,'LineWidth',2);
title('Scatter Plot','fontsize',13)
xlabel('In-phase','fontsize',13);
ylabel('Quadrature','fontsize',13);
axis([-1.5 1.5 -1.5 1.5]);axis square% set axes extents
grid % draw grid lines


%% Table 3.2
str='abc';
str_dec=double(str)
str_bin=dec2bin(str_dec,8)
bits=reshape(str_bin.',1,8*length(str))
