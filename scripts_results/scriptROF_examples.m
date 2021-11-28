%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for ROF example decompositions       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rng(2206) % control random noise

% --- 1st: fjord low noise image ---
%{x
I=rgb2gray(imread("Data/fjord.jpg"));
%I=im2double(imresize(I,[512,512])) + (rand(512)-0.5)/10; %uniform distrib.
I=im2double(imresize(I,[512,512])) + randn(512)/32;      %normal distrib.
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_1f.png');
clf;

%result
u = ROFdecom_FPGS(f, 8e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 100, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_1u.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_examples_1v.png');
clf;
%}


% --- 2nd: fjord high noise image ---
%{x
I=rgb2gray(imread("Data/fjord.jpg"));
%I=im2double(imresize(I,[512,512])) + (rand(512)-0.5)/5; %uniform distrib.
I=im2double(imresize(I,[512,512])) + randn(512)/8;     %normal distrib.
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_2f.png');
clf;

%result
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 150, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_2u.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_examples_2v.png');
clf;
%}


% --- 3rd: lena noise image ---
%{x
I=im2double(rgb2gray(imread("Data/lena_noise.png")));
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_3f.png');
clf;

%result
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 100, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_3u.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_examples_3v.png');
clf;
%}


% --- 4th: square noise image ---
%{x
f=[zeros(64,1); ones(128,1); zeros(64,1)] * ...
  [zeros(1,64), ones(1,128), zeros(1,64)] + randn(256)/4;

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_4f.png');
clf;

%result
u = ROFdecom_FPGSrot(f, 2e1, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 100, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_4u.png');
clf;
im2Dsetup(f-u,D,[-1,1]);
exportgraphics(gca,'./Results/imageROF_examples_4v.png');
clf;
%}


% --- 5th: fjord texture image ---
%{x
I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512]));
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_5f.png');
clf;

%result
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 150, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_5u.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_examples_5v.png');
clf;
%}


% --- 6th: barbara texture image ---
%{x
I=im2double(imread("Data/barbara.bmp"));
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_6f.png');
clf;

%result
u = ROFdecom_FPGS(f, 2e3, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 100, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_6u.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_examples_6v.png');
clf;
%}


% --- 7th: xray hand texture image ---
%{x
I=im2double(imread('hands-T.jpg'));
D=[0,0;1,1];
f=flipud(I)';

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_7f.png');
clf;

%result
u = ROFdecom_FPGS(f, 5e2, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 500, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_7u.png');
clf;
im2Dsetup(f-u,D,[-1,1]);
exportgraphics(gca,'./Results/imageROF_examples_7v.png');
clf;
%}


% --- 8th: square plain image ---
%{x
f=[zeros(64,1); ones(128,1); zeros(64,1)] * ...
  [zeros(1,64), ones(1,128), zeros(1,64)] ;
D=[0,0;1,1];

%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_8f.png');
clf;

%result
u = ROFdecom_FPGSrot(f, 2e0, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 2000, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_examples_8u.png');
clf;
im2Dsetup(f-u,D,[-1,1]);
exportgraphics(gca,'./Results/imageROF_examples_8v.png');
clf;
%}
