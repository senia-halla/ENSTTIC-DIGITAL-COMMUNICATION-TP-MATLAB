function [h]=firlpf(Lh,fpass,fstop,fsample)
%FIRLPF  Least-squares design of linear-phase low-pass filter.
%
% [h] = firlpf(Lh,fpass,fstop,fsample) designs Type I, length Lh, 
% linear-phase low-pass filter via least-squares design. 
% Lh must be odd.
%
% Lh        filter length (odd)
% fpass     edge of passband (Hz)
% fstop     edge of stopband (Hz)
% fsample   sampling rate (Hz)
% h         designed impulse response

% Digital Communications Laboratory
% Autumn 2014

%% argument check
if(nargin < 4)
    error('Too few input arguments for FIRLPF.')
end
if(fpass >= fstop)
    error('Passband edge must be less than stopband edge')
end
if(fsample <= 2*fstop)
    error('Sampling rate is sub-Nyquist')
end
if( mod(Lh,2) ~= 1);
    Lh=Lh+1;
    warning('Lh incremented for Type I FIR filter.');
end
%% normalized frequency (radians per sample)
fpass = fpass / (fsample/2) * pi; 
fstop = fstop / (fsample/2) * pi; 
%% apply orthogonality principle for LS solution
indx=(1:(Lh-1)/2);
RHS = [fpass sin(fpass*indx)./indx].';
% diagonal of matrix
tmp=zeros(1,length(indx)+1);
tmp(1) = pi - (fstop - fpass); 
tmp(2:end) = tmp(1)/2+(sin(2*indx*fpass)-sin(2*indx*fstop))./(4*indx);
LHS = diag(tmp);
% off-diagonals
for row=0:(Lh-1)/2;
    for col=row+1:(Lh-1)/2;
        LHS(row+1,col+1) = ...
            (sin((col+row)*fpass) - sin((col+row)*fstop))/2/(col+row) + ...
            (sin((col-row)*fpass) - sin((col-row)*fstop))/2/(col-row);
        LHS(col+1,row+1) = LHS(row+1,col+1);%symmetry
    end
end
g = LHS\RHS;g=g.';%solve linear system
h = [g(end:-1:2)/2 g(1) g(2:1:end)/2];%linear phase impulse response
%end of function