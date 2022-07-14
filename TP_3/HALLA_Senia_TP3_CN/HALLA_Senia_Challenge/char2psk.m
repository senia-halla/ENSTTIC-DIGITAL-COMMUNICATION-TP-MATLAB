%% template for char2psk.m
function [a,bits] = psk2char(str,M)
% char2psk.m
% Function to map a charater string to PSK symbols
% (See also psk2char.m)
%
% Inputs:
% str       string variable with text
% M        size of PSK constellation (2 or 4)
%           or, user can select 'bpsk' or 'qpsk'
% Outputs:
% a         output list of PSK symbols (complex-valued)
% bits      output list of bits (logical)

% Digital Communications Laboratory
% Autumn 2014

%% error checks
if(nargin ~= 2)
    error('Error: char2psk.m requires two input arguments.')
end
%% text to symbols
% first, string to decimal to binary
str_binary = dec2bin(double(str),8);
% convert array row-by-row to one long string
bits = reshape(str_binary.',1,8*length(str)).';
% binary to symbols
switch M
    case {2,'bpsk','BPSK'}
        M = 2;
        a = (2*bin2dec(bits)-1); % Transformer chaque code binaire à 1 ou -1 
    case {4,'qpsk','QPSK'}
        M = 4;
        bits = reshape(bits,2,[]) ; % On vas refaire le shape de vecteur pour qu'on trouve chaque symbole dans une ligne
        bits = bits.' ; 
        %phi_k = ((2*data+1)*pi)/M ; 
        %a = cos(phi_k)+1j*sin(phi_k) ;
        
        a = ((2*bin2dec(bits(:,1))-1) + 1j*(2*bin2dec(bits(:,2))-1)) ; % assigner à chaque symbole son equivalent en PSK 
        % si le premier bit est 1 on a une partie réelle égale à 1 snn -1,
        % meme chose pour deuxieme bit avec la partie imaginaire 
        a = a/sqrt(2) ; 
end

scatterplot(a) ; % Tracer le diagramme de constellation
title(append("Diagramme de Constellation de ",num2str(M),"-PSK"));

figure() ; 
plot(abs(fft(a)) ); %Tracer le spectre
title(append("Spectre du signal ",num2str(M),"-PSK")) ;

    
bits=(bits=='1');% convert char to logical
% end of function
