# Mult_BBDeblur_demo
This repository contains a simple implementation in MATLAB of the paper 'Accelerated and Enhanced Multiplicative Deblurring Schemes'. 


## Examples 
- The file 'demo_deblur_no_noise_eccv3.m' contains a demonstration of semi-blind deblurring with the proposed extensions of Richardon-Lucy (```RL_imp```), Image Space Reconstruction Algorithm (```ISRA_imp```) and the original RL and ISRA schemes for a grayscale image 
- The file 'demo_deblur_Gauss_noise_eccv3.m' contains a demonstration of the methods when the input image is altered with Gaussian noise (no adaptive smoothing is performed, see below)
- The file 'demo_deblur_Gauss_noise_eccv3_color.m' contains a demonstration for a color image (altered with Gaussian noise again) 

## Dependencies 
No particular dependency (e.g., to additional tooboxes). 

## Notes 
The implementation of the proposed extensions of RL and ISRA are in: 
- 'RL_imp.m' for the modification of the RL iterations 
- 'ISRA_imp.m' for the modification of ISRA 

For comparison the original RL and ISRA methods are implemented in 'RL.m' and 'ISRA.m'. 

## Regularization by adaptive smoothing 
All the methods, ```RL_imp```, ```ISRA_imp```, ... can take as input a denoiser to improve the result in the presence of noise. The following code sample shows how to use the [BM3D](https://webpages.tuni.fi/foi/GCF-BM3D/index.html#ref_software) denoiser (Download the most recent one, not the legacy release) 
```matlab 
D = @(x) BM3D(x, 0.01); % BM3D needs to be in the path 
opts.max_iter = 25;
opts.denoise_mode = 'ON';
[xest, ~, ~, ~] = RL_imp(f, yout, xin, D, opts);
```

## Reference 
The methods were introduced in
```
@article{MultDeblur2025,
title = "Accelerated and Enhanced Multiplicative Deblurring Schemes",
author = "Fayolle, Pierre-Alain and Belyaev, Alexander",
year = "2025",
journal = "Signal Processing",
volume = "", 
pages = "", 
issn = "",
publisher = "Elsevier",
doi = "", 
}
```
