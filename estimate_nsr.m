function nsr=estimate_nsr(y)

if (size(y,3) ~= 1)
    ybw = rgb2gray(y);
    nsr = estimate_noise(ybw)^2 / var(ybw(:));
else
    nsr = estimate_noise(y)^2 / var(y(:));
end

end
