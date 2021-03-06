M = 4; % Nombre d'états
fe = 100; %Fréquecne d'échantillonage
data = [1:10];
a = dec2bin(data);
symb = [ (-1-1j) (1+1j) (-1+1j) (-1-1j)];
[LL CC] = size(a);
if(LL*CC/log2(M)) > floor(LL*CC/log2(M)) 
    nL = floor(LL*CC/log2(M)) + 1;
else 
    nL = (LL*CC/log2(M));
end 

assert(nL*log2(M) >= LL*CC, 'nL*log2(M) should be >= LL*CC');
bits = 
    bit_words = bin2dec(reshape(bits, nL, log2(M)));
    s = 2*bit_words-1-M; 
    B_B_Sig = pulse*s';
    plot(psd(spectrum.welch, B_B_Sig(:), 'Fs', fe, 'CentreDC', true));
    r = B_B_Sig; 
    [Lr, Cr] = size(r);
    B_B = pulse'*r
    