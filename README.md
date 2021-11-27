# Code to the bachelor thesis from Ole Gildemeister
## Title: "The Rudin-Osher-Fatemi model and a hierarchical (BV,L²) image decomposition for multiscale image representation"
### Advisor: Prof. Dr. Jan Modersitzki
### Written at the Institute of Mathematics and Image Computing, University of Luebeck, Germany
### Study programme: Mathematik in Medizin und Lebenswissenschaften
### Date of submission: 29.11.2021

The code is written in MATLAB (Version R2020b) and ordered in the following structure:
1. Kernel files:
    * "ROFdecom_FPGS.m", "ROFdecom_FPGS_STOP.m" and "ROFdecom_FPGSrot.m" are functions that approximate a minimiser to the ROF problem
    * "ROFinitOptimal.m" is a function to compute the 'optimal parameter' for the ROF initialisation
    * "bvHierarchDecom.m"  is a function that computes a hierarchical image decomposition solely by the forward procedure
    * "bvHierarchDecom_BackFor.m"  is a function that computes a hierarchical image decomposition, starting with backward initialisation followed by the forward procedure
2. Test files:
    * "testROF.m" is a script to compute the ROF decomposition of an image
    * "testHierarch.m" to compute the hierarchical decomposition of an image
    * "testHierarchProp.m", "testHierarchView.m" are scripts to view and further analyse a previously computed hierarchical image decomposition
    * "testHierarchViewFctn.m" can be called to view a previously computed hierarchical image decomposition at instance 'l' after initialising with "testHierarchView.m"
3. The script files used to compute the images presented in the bachelor thesis:
    * "scriptROF_examples.m", "scriptROF_initCompar.m", "scriptROF_iterDevelop.m", "scriptROF_lambdaCompar.m", "scriptROF_stopCrit.m" produce the result images on the one-time ROF decomposition
    * "scriptHierarch_backward.m", "scriptHierarch_barbara.m", "scriptHierarch_fjord.m", "scriptHierarch_fjordnoise.m" and "scriptHierarch_performance.m" produce the result images on the hierarchical decomposition
4. Image data: "barbara.bmp", "fjord.jpg", "hands-R.jpg" and "lena_noise.png"


Finally, the bachelor thesis itself is attached.

For questions and comments, please contact me by mail: ole.gildemeister@student.uni-luebeck.de.
