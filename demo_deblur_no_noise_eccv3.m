% Compare different methods for motion deblurring in the absence of noise
%

close all;
clear;
clc;

addpath('./images/');
addpath('./kernels/');


% Barbara test image 
xin = im2double(imread('barbara_face.png'));

% eccv3 kernel
k = im2double(imread('eccv3_blurred_kernel.png'));
k = k./sum(k(:));
K = psf2otf(k,size(xin));
f = @(x) real(ifft2(fft2(x).*K));

% Observed blurred image
yout = f(xin);

figure, imshow(xin), title('Original image');
figure, imshow(yout), title('Blurred image');

% No denoiser needed
D = @(x) x;

% Improved RL (LM variant)
opts.max_iter = 500;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
opts.reg_alpha = 10.0;
opts.mode = 'LM';
[grl, err_grl, psnr_grl, ssim_grl, ~] = RL_imp(f, yout, xin, D, opts);

figure, imshow(grl), title('RL/LM');


% PC variant
opts.reg_alpha = 10.0;
opts.mode = 'PC';
[grl_pc, err_grl_pc, psnr_grl_pc, ssim_grl_pc, ~] = RL_imp(f, yout, xin, D, opts);

figure, imshow(grl_pc), title('RL/PC');


% Improved ISRA (LM variant)
opts.max_iter = 500;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
opts.reg_alpha = 10.0;
opts.mode = 'LM';
[gisra, err_gisra, psnr_gisra, ssim_gisra, ~] = ISRA_imp(f, yout, xin, D, opts);

figure, imshow(gisra), title('ISRA/LM');


% PC variant
opts.reg_alpha = 10.0;
opts.mode = 'PC';
[gisra_pc, err_gisra_pc, psnr_gisra_pc, ssim_gisra_pc, ~] = ISRA_imp(f, yout, xin, D, opts);

figure, imshow(gisra_pc), title('ISRA/PC');


% RL
opts.max_iter = 500;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
[rlk, err_rlk, psnr_rlk, ssim_rlk, ~] = RL(f, yout, xin, D, opts);

figure, imshow(rlk), title('Classic RL');


% ISRA
opts.max_iter = 500;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
[isra, err_isra, psnr_isra, ssim_isra, ~] = ISRA(f, yout, xin, D, opts);

figure, imshow(isra), title('Classic ISRA');


% ------ Plotting

% Common settings for the plots
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize

% psnr
max_psnr = max([psnr_grl(:); psnr_grl_pc(:); psnr_gisra(:); psnr_gisra_pc(:); psnr_rlk(:); psnr_isra(:)]);

figure();
semilogy(psnr_grl, 'LineWidth', 2);
hold on;
semilogy(psnr_grl_pc, 'LineWidth', 2);
semilogy(psnr_gisra, 'LineWidth', 2);
semilogy(psnr_gisra_pc, 'LineWidth', 2);
semilogy(psnr_rlk, 'LineWidth', 2);
semilogy(psnr_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_psnr]);
hold off;
legend('acc-RL (LM)', 'acc-RL (PC)', 'acc-ISRA (LM)', 'acc-ISRA (PC)', 'RL', 'ISRA', 'Location', 'southeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);
title('PSNR');


% ssim
max_ssim = max([ssim_grl(:); ssim_grl_pc(:); ssim_gisra(:); ssim_gisra_pc(:); ssim_rlk(:); ssim_isra(:)]);

figure();
semilogy(ssim_grl, 'LineWidth', 2);
hold on;
semilogy(ssim_grl_pc, 'LineWidth', 2);
semilogy(ssim_gisra, 'LineWidth', 2);
semilogy(ssim_gisra_pc, 'LineWidth', 2);
semilogy(ssim_rlk, 'LineWidth', 2);
semilogy(ssim_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_ssim]);
hold off;
legend('acc-RL (LM)', 'acc-RL (PC)', 'acc-ISRA (LM)', 'acc-ISRA (PC)', 'RL', 'ISRA', 'Location', 'southeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);
title('SSIM');


% Least-square error for ISRA
max_err = max([err_gisra(:); err_gisra_pc(:); err_isra(:)]);

figure();
semilogy(err_gisra, 'LineWidth', 2);
hold on;
semilogy(err_gisra_pc, 'LineWidth', 2);
semilogy(err_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_err]);
hold off;
legend('acc-ISRA (LM)', 'acc-ISRA (PC)', 'ISRA', 'Location', 'northeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);
title('L_2 error');


% KL divergence for RL
max_err = max([err_grl(:,2); err_grl_pc(:,2); err_rlk(:,2)]);

figure();
semilogy(err_grl(:,2), 'LineWidth', 2);
hold on;
semilogy(err_grl_pc(:,2), 'LineWidth', 2);
semilogy(err_rlk(:,2), 'LineWidth', 2), axis([1 opts.max_iter 0 max_err]);
hold off;
legend('acc-RL (LM)', 'acc-RL (PC)', 'RL', 'Location', 'northeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);
title('KL divergence');
