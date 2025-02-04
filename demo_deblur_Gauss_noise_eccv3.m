% Compare different methods for motion deblurring when the image is corrupted by Gaussian noise 
%

close all;
clear;
clc;

addpath('./images/');
addpath('./kernels/');

% Image 1 - Barbara 
xin = im2double(imread('barbara_face.png'));

% eccv3 kernel
k = im2double(imread('eccv3_blurred_kernel.png'));
k = k./sum(k(:));
K = psf2otf(k,size(xin));
f = @(x) real(ifft2(fft2(x).*K));

% Apply noise to the blurry image
noise_mean = 0.0;
noise_var = 0.00001;
F = @(x) imnoise(f(x), 'gaussian', noise_mean, noise_var);

% Observed blurred image
yout = F(xin);

figure, imshow(xin), title('Original image'); 
figure, imshow(yout), title('Blurred image'); 

% Denoiser
D = @(x) x; % no denoiser specified   

% Improved RL
opts.max_iter = 50;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
opts.reg_alpha = 10.0; 
opts.mode = 'LM';

opts.denoise_mode = 'OFF';
opts.reg_alpha = 10.0; 
opts.mode = 'LM';
[grl, err_grl, psnr_grl, ssim_grl] = RL_imp(f, yout, xin, D, opts);

figure, imshow(grl), title('RL/LM');


% Improved ISRA
opts.max_iter = 50;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
opts.reg_alpha = 10.0; 
opts.mode = 'LM';
[gisra, err_gisra, psnr_gisra, ssim_gisra] = ISRA_imp(f, yout, xin, D, opts);

figure, imshow(gisra), title('ISRA/LM');


% RL
opts.max_iter = 50;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
[rlk, err_rlk, psnr_rlk, ssim_rlk] = RL(f, yout, xin, D, opts);

figure, imshow(rlk), title('Standard RL');


% ISRA
opts.max_iter = 50;
opts.verbose = 1;
opts.denoise_mode = 'OFF';
[isra, err_isra, psnr_isra, ssim_isra] = ISRA(f, yout, xin, D, opts);

figure, imshow(isra), title('Standard ISRA');


% ------ Plotting

% some settings for the plots
alw = 0.75;    % AxesLineWidth
fsz = 11;      % Fontsize

% psnr 
max_psnr = max([psnr_grl(:); psnr_gisra(:); psnr_rlk(:); psnr_isra(:)]);

figure();
semilogy(psnr_grl, 'LineWidth', 2);
hold on;
semilogy(psnr_gisra, 'LineWidth', 2);
semilogy(psnr_rlk, 'LineWidth', 2);
semilogy(psnr_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_psnr]);
hold off;
legend('acc-RL (LM)', 'acc-ISRA (LM)', 'RL', 'ISRA', 'Location', 'southeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);


% ssim 
max_ssim = max([ssim_grl(:); ssim_gisra(:); ssim_rlk(:); ssim_isra(:)]);

figure();
semilogy(ssim_grl, 'LineWidth', 2);
hold on;
semilogy(ssim_gisra, 'LineWidth', 2);
semilogy(ssim_rlk, 'LineWidth', 2);
semilogy(ssim_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_ssim]);
hold off;
legend('acc-RL (LM)', 'acc-ISRA (LM)', 'RL', 'ISRA', 'Location', 'southeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);


% Least-square error for ISRA 
max_err = max([err_gisra(:); err_isra(:)]);

figure();
semilogy(err_gisra, 'LineWidth', 2);
hold on;
semilogy(err_isra, 'LineWidth', 2), axis([1 opts.max_iter 0 max_err]);
hold off;
legend('acc-ISRA (LM)', 'ISRA', 'Location', 'northeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);


% KL divergence for RL 
max_err = max([err_grl(:,2); err_rlk(:,2)]);

figure();
semilogy(err_grl(:,2), 'LineWidth', 2);
hold on;
semilogy(err_rlk(:,2), 'LineWidth', 2), axis([1 opts.max_iter 0 max_err]);
hold off;
legend('acc-RL (LM)', 'RL', 'Location', 'northeast');
set(gca, 'FontSize', fsz, 'LineWidth', alw);

