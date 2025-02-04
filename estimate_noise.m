% Noise estimation for a grayscale image
%
% Adapted from code by Tolga Birdal
%
% This is an extremely simple m-file which implements the method described
% in : J. Immerkær, 'Fast Noise Variance Estimation', Computer Vision and
% Image Understanding, Vol. 64, No. 2, pp. 300-302, Sep. 1996
%
% The function inputs a grayscale image I and returns sigma, the noise
% estimate. Here is a sample use:
%
% I = rgb2gray(imread('sample.jpg'));
% sigma = estimate_noise(I);
%
% The advantage of this method is that it includes a Laplacian operation
% which is almost insensitive to image structure but only depends on the
% noise in the image.

function sigma = estimate_noise(I)

% Check that I is grayscale, otherwise convert it with rgb2gray
if (size(I,3) ~= 1)
    I = rgb2gray(I);
end

[H, W] = size(I);
I = double(I);

% Compute sum of absolute values of Laplacian
M = [1 -2 1; -2 4 -2; 1 -2 1];
sigma = sum(sum(abs(conv2(I, M))));

% Scale sigma with proposed coefficients
sigma = sigma*sqrt(0.5*pi)./(6*(W-2)*(H-2));

end
