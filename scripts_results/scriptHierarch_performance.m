%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for analysing the decomp.'s perform. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=imread("Data/barbara.bmp");
I=im2double(imresize(I,[128,128]));
fMean = mean(I,'all');
f=flipud(I)'-fMean; %mean value adjust f for more accurate |v|_2 comparison

%initialise norm and variables
N = size(f);         % number of grid points in each dimension
D = [zeros(1,length(N)); N./max(N)]; % domain
h = (D(2,:)-D(1,:)) ./ N;       % grid size
L2norm = @(a) sum(a.^2,'all') * prod(h); %squared; a contains only interior


%{x
%original image
figure(8)
im2Dsetup(f,D,[-fMean,1-fMean]);
exportgraphics(gca,'./Results/imageHierarch_performance_f.png');
clf;
%}


%{x
%compute less accurate hierarchical forward decomposition and its properties
[uHis1,vm1,his1] = bvHierarchDecom(f, 2e2, 'm', 20, 'stopTolROF', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIterROF', 10000,...
  'ROFinitMeth', 'inputData', 'pauseTimeROF', 0, 'colourLim', [-fMean,1-fMean]);

steps = length(his1)-1;
ul1 = zeros(steps+1,1);  % |u|_2 in each decomposition step
s1=zeros(steps+1,1);     % sum( |u|_BV / lambda + |u|_2 ) as in Thm. 4.1
for i=1:steps+1
  ul1(i) = L2norm(uHis1(:,:,i));
  s1(i)= sum( his1(1:i,4) ./ his1(1:i,2) + ul1(1:i) );
end
%}

%{x
%plot |u|_BV, |u|_2 and |v|_2 for less accurate decomposition
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(0:steps, his1(:,4), 0:steps, ul1(:), 0:steps, his1(:,5));
xlabel('$\ell$', 'interpreter', 'latex')
legend('$\| u_\ell \|_{BV}$', '$\| u_\ell \|_{2}^{2}$', ...
       '$\| v_\ell \|_{2}^{2}$', 'interpreter', 'latex', ...
       'Location', 'Southwest');
exportgraphics(gca,'./Results/imageHierarch_performance_1.png');
clf;
%}


%{x
%compute more accurate hierarchical forward decomposition and its properties
[uHis2,vm2,his2] = bvHierarchDecom(f, 2e2, 'm', 20, 'stopTolROF', 1e-12, ...
  'visualiseROF', false, 'displayROF', false, 'maxIterROF', 10000,...
  'ROFinitMeth', 'inputData', 'pauseTimeROF', 0, 'colourLim', [-fMean,1-fMean]);

steps = length(his2)-1;
ul2 = zeros(steps+1,1);  % |u|_2 in each decomposition step
s2=zeros(steps+1,1);     % sum( |u|_BV / lambda + |u|_2 ) as in Thm. 4.1
for i=1:steps+1
  ul2(i) = L2norm(uHis2(:,:,i));
  s2(i)= sum( his2(1:i,4) ./ his2(1:i,2) + ul2(1:i) );
end
%}

%{x
%plot |u|_BV, |u|_2 and |v|_2 for more accurate decomposition
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(0:steps, his2(:,4), 0:steps, ul2(:), 0:steps, his2(:,5));
xlabel('$\ell$', 'interpreter', 'latex')
legend('$\| u_\ell \|_{BV}$', '$\| u_\ell \|_{2}^{2}$', ...
       '$\| v_\ell \|_{2}^{2}$', 'interpreter', 'latex', ...
       'Location', 'Southwest');
exportgraphics(gca,'./Results/imageHierarch_performance_2.png');
clf;
%}


%{x
%plot comparison of s1, s2 and |f|
figure(9)
set(gcf,'Position',[100 100 250 220]);
semilogy(0:steps, s1(:), 0:steps, s2(:));
ylim([0.02,0.04]);
xlabel('$\ell$', 'interpreter', 'latex')
yline(L2norm(f), '--', '$\| \tilde{f} \|_{2}^{2}$', 'interpreter', 'latex', ...
  'LabelVerticalAlignment', 'bottom')
legend('at $\tau_{stop} = 10^{-8}$', 'at $\tau_{stop} = 10^{-12}$', ...
       'interpreter', 'latex', 'Location', 'Southeast');
exportgraphics(gca,'./Results/imageHierarch_performance_3.png');
clf;
%}