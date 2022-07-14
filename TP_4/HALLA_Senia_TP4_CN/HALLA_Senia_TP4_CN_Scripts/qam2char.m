%% template for qam2char.m
function [str,bits] = qam2char(y,M)
% qam2char.m
% Function to decode M-qam symbols to a string of ASCII text.
% (See also char2qam.m)
%
% Inputs:
% M      size of qam constellation (2 or 4; or 'bqam or 'qqam')
% y      list of qam IQ points (complex numbers)
% Outputs:
% strbin string variable with ASCII text
% bits   list of 0/1 bits (as logical variables)
%
% Digital Communication Laboratory
% Autumn 2014

%% error checks
if(nargin ~= 2)
    error('Error: qam2char.m requires two input arguments')
end
if (isnumeric(y) ~= 1 || isempty(y))
    error('Error: the input y must be numeric.')
end

%% symbol slicing
% first, symbol string to string of integer labels: 0,1,...,log2(M)
% labels are integers; use double data type
  switch M
     case {2,'bqam','Bqam'}
        M = 2;
        labels = (real(y) >= 0);
     case {4,'qqam','Qqam'}
        M = 4;
        %
        %create code here; see table in TP04 for labeling quadrants
        %
  end
% second, labels into string of bits
  N = length(labels)*log2(M)/8;%number of characters
  tmp = dec2bin(labels,log2(M));%label to binary
  strbin = reshape(tmp.',8,N).';%array, labels to 8 bits/character
% third, convert from char to logical:
  bits = logical(bin2dec(reshape(tmp.',1,N*8).').');
% fourth, convert binary to decimal ASCII to character
  str=char(bin2dec(strbin)).';%
% end of function
