%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for ROF iteration development        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';

%{x
%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_f.png');
clf;
%}


%{x
%first parameter, one step
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 1);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ua1.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_va1.png');
clf;
%}

%{x
%first parameter, 15 steps
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 15);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ua15.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_va15.png');
clf;
%}

%{x
%first parameter, 50 steps
u = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 50);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ua50.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_va50.png');
clf;
%}

%{x
%first parameter, 300 steps / performance graph
[u,his1] = ROFdecom_FPGS(f, 1e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 300);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ua300.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_va300.png');
clf;

figure(9)
set(gcf,'Position',[100 100 200 180]);
plot(1:300,his1(2:301,2),1:300,his1(2:301,4),1:300,1e3*his1(2:301,5));
xlabel('$n$', 'interpreter', 'latex')
legend('$\mathcal{E}_{f,\lambda}$', '$\| u \|_{BV}$', ...
  '$\lambda \| v \|_{2}^{2}$', 'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_iterDevelop_grapha.png');
clf;
%}



%{x
%second parameter, one step
u = ROFdecom_FPGS(f, 4e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 1);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ub1.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_vb1.png');
clf;
%}

%{x
%second parameter, 15 steps
u = ROFdecom_FPGS(f, 4e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 15);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ub15.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_vb15.png');
clf;
%}

%{x
%second parameter, 50 steps
u = ROFdecom_FPGS(f, 4e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 50);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ub50.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_vb50.png');
clf;
%}

%{x
%second parameter, 300 steps / performance graph
[u,his2] = ROFdecom_FPGS(f, 4e3, 'optimalInit', false, 'stopTol', 1e-11, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', 300);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_ub300.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_iterDevelop_vb300.png');
clf;

figure(9)
set(gcf,'Position',[100 100 200 180]);
plot(1:300,his2(2:301,2),1:300,his2(2:301,4),1:300,4e3*his2(2:301,5));
xlabel('$n$', 'interpreter', 'latex')
legend('$\mathcal{E}_{f,\lambda}$', '$\| u \|_{BV}$', ...
  '$\lambda \| v \|_{2}^{2}$', 'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_iterDevelop_graphb.png');
clf;
%}