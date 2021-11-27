%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for ROF initialisation comparison    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';

nIter = 60;

% --- inputData = original image ---
%{x
%initialisation 
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_initCompar_ua0.png');
clf;
%}

%{x
%result
[u,his1] = ROFdecom_FPGS(f, 2e2, 'optimalInit', false, 'stopTol', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', nIter);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_initCompar_ua50.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_initCompar_va50.png');
clf;

%performance plot
figure(9)
set(gcf,'Position',[100 100 200 165]);
plot(1:nIter,his1(2:nIter+1,2),1:nIter,his1(2:nIter+1,4),1:nIter,2e2*his1(2:nIter+1,5));
xlabel('$n$', 'interpreter', 'latex')
ylim([0,10]);
legend('$\mathcal{E}_{f,\lambda}$', '$\| u \|_{BV}$', ...
  '$\lambda \| v \|_{2}^{2}$', 'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_initCompar_grapha.png');
clf;
fprintf(['inputData= ', num2str(his1(end,2)), '\n']);
%}


% --- inputData = optimal combination ---
alpha = ROFinitOptimal(f,2e2,'D',D);
fprintf(['alpha=', num2str(alpha), '\n']);
u0 = alpha*f + (1-alpha)*mean(f,'all');

%{x
%initialisation 
figure(8)
im2Dsetup(u0,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_initCompar_ub0.png');
clf;
%}

%{x
%result
[u,his2] = ROFdecom_FPGS(f, 2e2, 'u0', u0, 'stopTol', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIter', nIter);

figure(8)
im2Dsetup(u,D,[0,1]);
exportgraphics(gca,'./Results/imageROF_initCompar_ub50.png');
clf;
im2Dsetup(f-u,D,[-0.5,0.5]);
exportgraphics(gca,'./Results/imageROF_initCompar_vb50.png');
clf;

%performance plot
figure(9)
set(gcf,'Position',[100 100 200 165]);
plot(1:nIter,his2(2:nIter+1,2),1:nIter,his2(2:nIter+1,4),1:nIter,2e2*his2(2:nIter+1,5));
xlabel('$n$', 'interpreter', 'latex')
ylim([0,10]);
legend('$\mathcal{E}_{f,\lambda}$', '$\| u \|_{BV}$', ...
  '$\lambda \| v \|_{2}^{2}$', 'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_initCompar_graphb.png');
clf;
fprintf(['optimal=   ', num2str(his2(end,2)), '\n']);
%}