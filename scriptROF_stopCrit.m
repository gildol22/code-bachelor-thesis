%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for ROF quantity comparison          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';


%{x
%compute history of stopping criteria
[~,hisSTOP] = ROFdecom_FPGS_STOP(f, 1e3, 'optimalInit', false, 'stopTol',...
  1e-11, 'visualiseROF', false, 'displayROF', false, 'maxIter', 300);
%}

%{x
%plot first criterion (update size)
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(1:300,hisSTOP(2:301,7));
xlabel('$n$', 'interpreter', 'latex')
legend('$\| u^{(n)} - u^{(n-1)} \|_{2}^{2}$', 'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_stopCrit_updateSize.png');
%}

%{x
%plot second criterion (improvement)
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(1:300,hisSTOP(2:301,3));
xlabel('$n$', 'interpreter', 'latex')
legend('$\mathcal{E}_{f,\lambda}(u^{(n)})-\mathcal{E}_{f,\lambda}(u^{(n-1)})$',...
  'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_stopCrit_improvement.png');
%}

%{x
%plot third criterion (accuracy)
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(1:300,hisSTOP(2:301,9), 1:300,hisSTOP(2:301,10), 1:300,hisSTOP(2:301,11));
xlabel('$n$', 'interpreter', 'latex')
ylim([1e-4,1e-2]);
legend('$\langle u^{(n)}, v^{(n)} \rangle$', ...
  '$\frac{1}{2\lambda} \| u^{(n)} \|_{BV}$', ...
  '$\big| \langle u^{(n)}, v^{(n)} \rangle - \frac{1}{2\lambda} \| u^{(n)} \|_{BV} \big|$',...
  'interpreter', 'latex');
exportgraphics(gca,'./Results/imageROF_stopCrit_accuracy.png');
%}