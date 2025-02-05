function kl = KL_divergence_Fx(y, Fx)
% KL_DIVERGEBCE_FX Compute the KL divergence D(y || F(x)) between y and F(x)
%   kl = KL_divergence_Fx(y, Fx) Computes the KL divergence between y and
%   Fx
% 
% This computes a generalized KL divergence between y and Fx defined by: 
% D(y || F(x)) = sum_{ij} F(x_{ij}) - y_{ij} - y_{ij} ln(F(x_{ij})/y_{ij})
%
% Inputs: 
%  y: observed image 
%  Fx: computed image 
% 
% Output: 
%  kl: generalized KL divergence 
%

Fx_y = Fx ./ (y+eps);
lnFx_y = log(Fx_y);
s = Fx - y - y.*lnFx_y;
idx = y == 0;
s(idx) = Fx(idx);
kl = sum(s, 'all'); % Matlab 2018b and above, otherwise sum(s(:)) should work

end
