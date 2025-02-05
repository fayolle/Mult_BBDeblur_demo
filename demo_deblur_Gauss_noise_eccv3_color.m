close all;
clear;
clc;

addpath('./images/');
addpath('./kernels/');

filenames = {'starfish'};
nfiles = numel(filenames);

for i=1:nfiles
    xin = im2double(imread([filenames{i} '.png']));
    
    k = im2double(imread('eccv3_blurred_kernel.png'));
    k = k./sum(k(:));
    K = psf2otf(k,size(xin));
    f = @(x) real(ifft2(fft2(x).*K));
    
    % Apply noise to the blurry image
    noise_mean = 0.0;
    noise_var = 0.00001;
    F = @(x) imnoise(f(x), 'gaussian', noise_mean, noise_var);
    
    
    % Observed noisy and blurred image
    yout = F(xin);
    
    figure, imshow(xin), title('Original image');
    figure, imshow(yout), title('Blurred image'); 
    
    % Improved RL
    D = @(x) x; % No denoiser specified 
    opts.max_iter = 100;
    opts.verbose = 1;
    opts.denoise_mode = 'OFF';
    opts.mode = 'PC';
    opts.reg_alpha = 10.0;
    [grl, ~, ~, ~] = RL_imp(f, yout, xin, D, opts);
    figure, imshow(grl), title('Improved RL');
end
