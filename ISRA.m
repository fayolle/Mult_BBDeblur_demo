function [israk, err, psnr_israk, ssim_israk, noise_israk] = ISRA(F, y, x, D, options)
options.null = 0;

max_iter = getoptions(options, 'max_iter', 50);
verbose = getoptions(options, 'verbose', 0);
denoise_mode = getoptions(options, 'denoise_mode', 'ON'); % 'ON' or 'OFF'

israk = y;

err = [];
fisrak = F(israk);
e = img_norm(y - fisrak);
err = [err; e];
psnr_israk = [];
px = psnr(israk, x);
psnr_israk = [psnr_israk; px];
ssim_israk = [];
ssimx = ssim(israk, x);
ssim_israk = [ssim_israk; ssimx];
noise_israk = [];
noise = estimate_noise(israk);
noise_israk = [noise_israk; noise];

if (verbose)
    fprintf('Err/psnr/ssim: %f %f %f\n', e, px, ssimx);
end


Y = fft2(y);

for i=1:max_iter
    fisrak = F(israk);
    RLK = fft2(israk);
    H = fft2(fisrak)./(RLK+1e-7);
    Hconj = conj(H);
    israk = israk .* real(ifft2(Y.*Hconj)) ./ real(ifft2(fft2(fisrak).*Hconj));

    % PRO
    if (strcmp(denoise_mode, 'ON'))
        gamma = estimate_noise(israk);
        w = min(100*gamma, 0.5);
        israk = (1-w).*israk + w.*D(israk);
    end


    fisrak = F(israk);
    e = img_norm(y - fisrak);
    err = [err; e];

    px = psnr(israk, x);
    psnr_israk = [psnr_israk; px];

    ssimx = ssim(israk, x);
    ssim_israk = [ssim_israk; ssimx];

    noise = estimate_noise(israk);
    noise_israk = [noise_israk; noise];


    if (verbose)
        fprintf('Err/psnr/ssim: %f %f %f\n', e, px, ssimx);
    end

end

end
