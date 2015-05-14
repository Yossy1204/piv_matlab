Simple Particle Image Velocity for MATLAB
=====

### USAGE
This is a very simple software of the particle image velocimetry (PIV).  
Because the codes of this PIV are written straightforward, the beginner of the PIV users (and may be, programmers) can easily understand the step-by-step procedures of the PIV.  
 
This software is currently for the education of PIV. 
Because this PIV software only imprement the simple maximum-correlation matching.  
So this software is VERY slow right now.  

### FEATURE
ROI-based image masking  
Image matching by the simple maximum-correlation search.  
Automatic error validation by median-based outlier detection.  

### REQUIREMENT
Two sequencial particle image files (*.tif images)   
MATLAB (this software is developed in MATLAB R2014b)  

### HOW TO USE 
1. Put two images into the "image" folder.  
2. (If necessary) Remane the two image files as '1.tif' and '2.tif'.  
3. Set the parameters in 'piv_main.m' file.  
4. Run 'piv_main.m' in the MATLAB console.  
5. Follow the instructions of the software.    
