%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for hierarchical decomp. of fjord    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';

%{x
%compute hierarchical forward decomposition of image
[uHis,vm] = bvHierarchDecom(f, 2e2, 'm', 10, 'stopTolROF', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIterROF', 200,...
  'ROFinitMeth', 'inputData', 'pauseTimeROF', 0);
%}


%{x
%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageHierarch_fjord_f.png');
clf;
%}


%{x
%save resultant u (current instance of u, i.e. u_l)#
figure(8)
im2Dsetup(uHis(:,:,1),D,[0,1]);
exportgraphics(gca,strcat('./Results/imageHierarch_fjord_u', ...
                          num2str(0), '.png'));
for l=1:10
  im2Dsetup(uHis(:,:,l+1),D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_fjord_u', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant v (current instance of v, i.e. v_l)
for l=0:10
  figure(8)
  im2Dsetup(vm+sum(uHis(:,:,l+1:end),3)-uHis(:,:,l+1), D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_fjord_v', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant us (sum of all u up to l, i.e. sum(u_0:u_l))
for l=0:10
  figure(8)
  im2Dsetup(sum(uHis(:,:,1:l+1),3),D,[0,1]);
  exportgraphics(gca,strcat('./Results/imageHierarch_fjord_us', ...
                            num2str(l), '.png'));
  clf;
end
%}