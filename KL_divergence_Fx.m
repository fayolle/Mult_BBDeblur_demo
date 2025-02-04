function kl = KL_divergence_Fx(y, Fx)
% Compute the KL divergence D(y || F(x)) between y and F(x)
%
% D(y || F(x)) = sum_{ij} F(x_{ij}) - y_{ij} - y_{ij} ln(F(x_{ij})/y_{ij})
%

Fx_y = Fx ./ (y+eps);
lnFx_y = log(Fx_y);
s = Fx - y - y.*lnFx_y;
idx = y == 0;
s(idx) = Fx(idx);
kl = sum(s, 'all'); % Matlab 2018b and above, otherwise sum(s(:)) should work

end
