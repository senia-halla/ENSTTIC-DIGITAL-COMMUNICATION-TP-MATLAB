%% template for char2qam.m
function [a,bits] = char2qam(str,M);
% char2qam.m
% Function to map a charater string to qam symbols
% (See also qam2char.m)
%
% Inputs:
% str       string variable with text
% M        size of qam constellation (2 or 4)
%           or, user can select 'bqam' or 'qqam'
% Outputs:
% a         output list of qam symbols (complex-valued)
% bits      output list of bits (logical)

% Digital Communications Laboratory
% Autumn 2014

%% error checks
if(nargin ~= 2)
    error('Error: char2qam.m requires two input arguments.')
end
%% text to symbols
% first, string to decimal to binary
str_binary = dec2bin(double(str),8);
% convert array row-by-row to one long string
bits = reshape(str_binary.',1,8*length(str));
% binary to symbols
switch M
    case {2,'bqam','Bqam'}
        M = 2;
        a = (2*bin2dec(bits.')-1).';
    case {4,'qqam','Qqam'}
        M = 4;
        %
        %create your Qqam code here
        %
end
bits=(bits=='1');% convert char to logical
% end of function
