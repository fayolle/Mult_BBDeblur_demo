function [rlk, err, psnr_rlk, ssim_rlk, noise_rlk] = RL(F, y, x, D, options)

options.null = 0;

max_iter = getoptions(options, 'max_iter', 50);
use_pro = getoptions(options, 'use_pro', 1);
pro_alpha = getoptions(options, 'pro_alpha', 0.5);
verbose = getoptions(options, 'verbose', 0);
denoise_mode = getoptions(options, 'denoise_mode', 'ON'); % 'ON' or 'OFF'
alpha = getoptions(options, 'alpha', 0.5); % scaling factor for PRO


rlk = y;

err = [];
frlk = F(rlk);
e = img_norm(y - frlk);
ekl = KL_divergence_Fx(y, frlk);
err = [err; e ekl];
psnr_rlk = [];
px = psnr(rlk, x);
psnr_rlk = [psnr_rlk; px];
ssim_rlk = [];
ssimx = ssim(rlk, x);
ssim_rlk = [ssim_rlk; ssimx];
noise_rlk = [];
noise = estimate_noise(rlk);
noise_rlk = [noise_rlk; noise];

if (verbose)
    fprintf('L2 err/KL div/psnr/ssim: %f %f %f %f\n', e, ekl, px, ssimx);
end

Y = fft2(y);

for i=1:max_iter
    frlk = F(rlk);
    RLK = fft2(rlk);
    H = fft2(frlk)./(RLK+1e-7);
    Hconj = conj(H);
    rlk = real(ifft2(Hconj.*fft2(y./(ifft2(H.*RLK)+eps)))).*rlk;

    % PRO
    if (strcmp(denoise_mode, 'ON'))
        gamma = estimate_noise(rlk);
        w = min(100*gamma, alpha);
        rlk = (1-w).*rlk + w.*D(rlk);
    end


    frlk = F(rlk);
    e = img_norm(y - frlk);
    ekl = KL_divergence_Fx(y, frlk);
    err = [err; e ekl];

    px = psnr(rlk, x);
    psnr_rlk = [psnr_rlk; px];

    ssimx = ssim(rlk, x);
    ssim_rlk = [ssim_rlk; ssimx];

    noise = estimate_noise(rlk);
    noise_rlk = [noise_rlk; noise];

    if (verbose)
        fprintf('L2 err/KL div/psnr/ssim: %f %f %f %f\n', e, ekl, px, ssimx);
    end

end

end
