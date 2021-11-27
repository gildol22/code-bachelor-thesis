%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to compute hierarchical decomposition                    %
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

% Choose method and parameters to compute hierarchical decomposition
% (see function for options)
%{
[uHis,vm,his,hisROF] = bvHierarchDecom(f, 2e2, 'm', 10, 'stopTolROF', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIterROF', 100,...
  'ROFinitMeth', 'inputData', 'pauseTimeROF', 0);
%}

%{x
[uHis,vm,his,his0,hisB,hisROF] = bvHierarchDecom_BackFor(f, 6.4e3, 'm', 5, ...
  'stopTolROF', 1e-8, 'visualiseROF', false, 'displayROF', false, ...
  'maxIterROF', 100, 'ROFinitMeth', 'inputData', 'pauseTimeROF', 0);
%}