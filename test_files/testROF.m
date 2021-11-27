%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to compute ROF decomposition                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Choose one of the following images
I=rgb2gray(imread("Data/fjord.jpg"));
%I=imread("Data/barbara.bmp");
%I=rgb2gray(imread("Data/lena_noise.png"));
%I=imread('hands-T.jpg');


% Choose size
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
%I=im2double(imresize(I,[128,128])); D=[0,0;1,1];


% Add artificial noise?
%rng(2206);I=I+randn(size(I))/16;


f=flipud(I)';


% Select parameters to compute decomposition
% (see function for options)

[u,his] = ROFdecom_FPGS(f, 2e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 50, 'pauseTime', 0);


% Plot results
figure(12)
subplot(1,2,1)
[im_u, ax_u] = im2Dsetup(u,D,[0,1]);
ax_u.Title=title('u_\lambda');

subplot(1,2,2)
[im_v, ax_v] = im2Dsetup(f-u,D,[-.5,.5]);
ax_v.Title=title('v_\lambda+0.5');
