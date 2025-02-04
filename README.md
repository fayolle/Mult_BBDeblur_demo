# Mult_BBDeblur_demo
This repository contains a simple implementation in MATLAB of the paper 'Accelerated and Enhanced Multiplicative Deblurring Schemes'. 


## Examples 
- The file 'demo_deblur_no_noise_eccv3.m' contains a demonstration of non-blind deblurring with the proposed extensions of Richardon-Lucy (RL), Image Space Reconstruction Algorithm (ISRA) and the original RL and ISRA schemes for a grayscale image 
- The file 'demo_deblur_Gauss_noise_eccv3.m' contains a demonstration of the methods when the input image is altered with Gaussian noise 
- The file 'demo_deblur_Gauss_noise_eccv3_color.m' contains a demonstration for a color image

## Dependencies 
No particular dependency (e.g., to additional tooboxes). 

## Notes 
The implementation of the proposed extensions of RL and ISRA are in: 
- 'RL_imp.m' for the modification of the RL iterations 
- 'ISRA_imp.m' for the modification of ISRA 

For comparison the original RL and ISRA methods are implemented in 'RL.m' and 'ISRA.m'. 


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
