%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for ROF lambda value comparison      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';

%{x
%result large lambda
u = ROFdecom_FPGS(f, 1e5, 'optimalInit', false, 'stopTol', 1e-9, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 500, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_lambdaCompar_ua.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_lambdaCompar_va.png');
clf;
%}


%{x
%result small lambda
u = ROFdecom_FPGS(f, 1e0, 'optimalInit', false, 'stopTol', 1e-9, ...
  'visualiseROF', true, 'displayROF', true, 'maxIter', 500, 'pauseTime', 0);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_lambdaCompar_ub.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_lambdaCompar_vb.png');
clf;
%}