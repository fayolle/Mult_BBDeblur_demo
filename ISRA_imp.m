function [gisra, err, psnr_gisra, ssim_gisra, noise_gisra] = ISRA_imp(F, y, x, D, options)
% Note: x (the clean image) is only needed for psnr computations

if (size(y,3) ~= 1)
    % Color image - Call ISRA_imp_internal on the luminance channel
    ycbcr_y = rgb2ycbcr(y);
    luma_y = ycbcr_y(:,:,1);

    ycbcr_x = rgb2ycbcr(x);
    luma_x = ycbcr_x(:,:,1);

    [gisra_tmp, err, psnr_gisra, ssim_gisra, noise_gisra] = ISRA_imp_internal(F, luma_y, luma_x, D, options);

    ycbcr_y(:,:,1) = gisra_tmp;
    gisra = ycbcr2rgb(ycbcr_y);
else
    % Grayscale image
    [gisra, err, psnr_gisra, ssim_gisra, noise_gisra] = ISRA_imp_internal(F, y, x, D, options);
end
end


function [gisra, err, psnr_gisra, ssim_gisra, noise_gisra] = ISRA_imp_internal(F, y, x, D, options)
options.null = 0;

max_iter = getoptions(options, 'max_iter', 20);
verbose = getoptions(options, 'verbose', 0);
mode = getoptions(options, 'mode', 'LM'); % 'LM' or 'PC'
denoise_mode = getoptions(options, 'denoise_mode', 'ON'); % 'ON' or 'OFF'
reg_alpha = getoptions(options, 'reg_alpha', 10.0);

isra = y;
err = [];
fisra = F(isra);
fisra = fisra(:,:,1);
e = img_norm(y - fisra);
err = [err; e];
psnr_isra = [];
px = psnr(isra, x);
psnr_isra = [psnr_isra; px];
ssim_isra = [];
ssimx = ssim(isra, x);
ssim_isra = [ssim_isra; ssimx];
noise_isra = [];
noise = estimate_noise(isra);
noise_isra = [noise_isra; noise];


if (verbose)
    fprintf('Err/psnr/ssim: %f %f %f\n', e, px, ssimx);
end

Y = fft2(y);

for i=1:max_iter
    a = reg_alpha * estimate_noise(isra);

    K = fft2(fisra)./(fft2(isra)+eps);
    Kconj = conj(K);

    if (strcmp(mode, 'LM'))
        nKconj = conj(K)./(Kconj.*K + a);
        nKconj(1,1,:) = 1;
    else
        nKconj = conj(K)./(sqrt(Kconj.*K) + a);
        nKconj(1,1,:) = 1;
    end

    isra = isra.*ifft2(Y.*nKconj)./ifft2(fft2(fisra).*nKconj);

    % PRO
    if (strcmp(denoise_mode, 'ON'))
        gamma = estimate_noise(isra);
        w = min(100*gamma, 0.5);
        isra = (1-w).*isra + w.*D(isra);
    end

    fisra = F(isra);
    fisra = fisra(:,:,1);
    e = img_norm(y - fisra);
    err = [err; e];

    px = psnr(isra, x);
    psnr_isra = [psnr_isra; px];

    ssimx = ssim(isra, x);
    ssim_isra = [ssim_isra; ssimx];

    noise = estimate_noise(isra);
    noise_isra = [noise_isra; noise];

    if (verbose)
        fprintf('Err/psnr/ssim: %f %f %f\n', e, px, ssimx);
    end

end

gisra = isra;
psnr_gisra = psnr_isra;
ssim_gisra = ssim_isra;
noise_gisra = noise_isra;

end
