function yc = convolve(fun,irf,t,N,method)
%% yc = convolve(fun,irf,t,N,method)
%
%
% Written by Marcin Konowalczyk
% Timmel Group @ Oxford University

%% Parse input
if nargin < 5 || isempty(method)
    method = 'conv';
end

if nargin < 4 || isempty(N)
    N = numel(t);
end

min_t = min(t);
max_t = max(t);
range = max_t-min_t;
% Make padded time axis for convolution
pt = linspace(min_t-range,max_t+range,(3*N+1));
pt2 = pt((N+1):(3*N+1));
pt3 = pt((N+1):(N+(N+1)));

%% Do the convolution
% Evaluate fun at x
yf = fun(pt); yf = yf(:);
K = irf(pt3); K = K(:); % Convolution kernel

% Convolve
switch method
    case 'conv'
        yc = conv(yf,K,'valid');
    case 'fft'
        yc = real(ifft(fft(yf).*fft(K,numel(yf))));
        yc = yc(N+1:end);
end

% Interpolate onto the range if needed
F = griddedInterpolant(pt2,yc,'linear');
yc = F(t);
end