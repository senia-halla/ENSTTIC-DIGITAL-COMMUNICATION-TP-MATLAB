function g = srrc(D,alpha,L)
% SRRC Fractionally-sampled square-root raised cosine pulse.
%
% [g] = srrc(D,alpha,L) creates a fractionally-sampled square-root 
% raised cosine pulse
%
%    D       one-half the length of srrc pulse in symbol durations
%    alpha   excess bandwith (value between 0 and 1);
%            alpha=0 gives a sinc pulse
%    L       samples per symbol (oversampling factor)
%            L must be a positive integer
%    g       samples of the srrc pulse

% Digital Communications Laboratory
% Autumn 2014

%% argument check
if(nargin < 3)
    error('Too few input arguments for SRRC')
end
if( min( [D,alpha,L] ) < 0 )
    error('Inputs must be non-negative for SRRC.')
end
if( round(L) ~= L )
    error('Input L must be a non-negative integer for SRRC.')
end

%% compute samples
k = -D:(1/L):D; % k is t/T
g = (sin(pi*(1-alpha)*k)+(4*alpha*k).*cos(pi*(1+alpha)*k)) ./ ...
  ((pi*k) .* (1-(4*alpha*k).^2))/sqrt(L);
%% fill in for denominator zeros
g(k==0) =  (1 + (4/pi-1)*alpha)/sqrt(L);
g(abs(abs(4*alpha*k)-1) < sqrt(eps)) = ...
   alpha/sqrt(2*L)*( (1+2/pi)*sin(pi/4/alpha) + ...
  (1-2/pi)*cos(pi/4/alpha));
%end of function