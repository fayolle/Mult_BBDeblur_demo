function [gmrl, err, psnr_gmrl, ssim_gmrl, noise_gmrl] = RL_imp(F, y, x, D, options)
% Note: x (the clean image) is only needed for psnr computations

if (size(y,3) ~= 1)
    % Color image - Call RL_imp_internal on the luminance channel
    ycbcr_y = rgb2ycbcr(y);
    luma_y = ycbcr_y(:,:,1);

    ycbcr_x = rgb2ycbcr(x);
    luma_x = ycbcr_x(:,:,1);

    [gmrl_tmp, err, psnr_gmrl, ssim_gmrl, noise_gmrl] = RL_imp_internal(F, luma_y, luma_x, D, options);

    ycbcr_y(:,:,1) = gmrl_tmp;
    gmrl = ycbcr2rgb(ycbcr_y);
else
    % Grayscale image
    [gmrl, err, psnr_gmrl, ssim_gmrl, noise_gmrl] = RL_imp_internal(F, y, x, D, options);
end
end


function [gmrl, err, psnr_gmrl, ssim_gmrl, noise_gmrl] = RL_imp_internal(F, y, x, D, options)
options.null = 0;

max_iter = getoptions(options, 'max_iter', 20);
verbose = getoptions(options, 'verbose', 0);
mode = getoptions(options, 'mode', 'LM'); % 'LM' or 'PC'
denoise_mode = getoptions(options, 'denoise_mode', 'ON'); % 'ON' or 'OFF'
reg_alpha = getoptions(options, 'reg_alpha', 10.0);
alpha = getoptions(options, 'alpha', 0.5); % scaling factor for PRO


mrl = y;
err = [];
fmrl = F(mrl);
fmrl = fmrl(:,:,1);
e = img_norm(y - fmrl); % least square error
ekl = KL_divergence_Fx(y, fmrl);
err = [err; e ekl];
psnr_mrl = [];
px = psnr(mrl, x);
psnr_mrl = [psnr_mrl; px];
ssim_mrl = [];
ssimx = ssim(mrl, x);
ssim_mrl = [ssim_mrl; ssimx];
noise_mrl = [];
noise = estimate_noise(mrl);
noise_mrl = [noise_mrl; noise];

if (verbose)
    fprintf('L2 err/KL div/psnr/ssim: %f %f %f %f \n', e, ekl, px, ssimx);
end


for i=1:max_iter
    a = reg_alpha * estimate_noise(mrl);

    K = fft2(fmrl)./(fft2(mrl)+eps);
    Kconj = conj(K);

    if (strcmp(mode, 'LM'))
        nKconj = Kconj./(Kconj.*K+a);
        nKconj(1,1,:) = 1;
        mrl = mrl.*real(ifft2(fft2(y./(fmrl+eps)).*nKconj));
    else
        % it should be 'PC'
        nKconj = Kconj./(abs(K)+a);
        nKconj(1,1,:) = 1;
        mrl = mrl.*real(ifft2(fft2(y./(fmrl+eps)).*nKconj));
    end

    % PRO
    if (strcmp(denoise_mode, 'ON'))
        mrl = (1-alpha).*mrl + alpha.*D(mrl);
    end

    fmrl = F(mrl);
    fmrl = fmrl(:,:,1);
    e = img_norm(y - fmrl);
    ekl = KL_divergence_Fx(y, fmrl);
    err = [err; e ekl];

    px = psnr(mrl, x);
    psnr_mrl = [psnr_mrl; px];

    ssimx = ssim(mrl, x);
    ssim_mrl = [ssim_mrl; ssimx];

    noise = estimate_noise(mrl);
    noise_mrl = [noise_mrl; noise];

    if (verbose)
        fprintf('L2 err/KL div/psnr/ssim: %f %f %f %f\n', e, ekl, px, ssimx);
    end

end

gmrl = mrl;
psnr_gmrl = psnr_mrl;
ssim_gmrl = ssim_mrl;
noise_gmrl = noise_mrl;

end
