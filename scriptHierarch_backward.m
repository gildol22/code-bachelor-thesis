%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to generate figures for forward-backward comparison      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I=imread("Data/barbara.bmp");
I=im2double(imresize(I,[512,512])); D=[0,0;1,1];
f=flipud(I)';


%{x
%original image
figure(8)
im2Dsetup(f,D,[0,1]);
exportgraphics(gca,'./Results/imageHierarch_backward_f.png');
clf;
%}


%{x
%compute hierarchical forward decomposition of image
[uHis,vm] = bvHierarchDecom(f, 2e2, 'm', 5, 'stopTolROF', 1e-8, ...
  'visualiseROF', false, 'displayROF', false, 'maxIterROF', 200,...
  'ROFinitMeth', 'inputData', 'pauseTimeROF', 0);
%}

%{x
%save resultant u of forward decomposition (current instance of u, i.e. u_l)
figure(8)
im2Dsetup(uHis(:,:,1),D,[0,1]);
exportgraphics(gca,strcat('./Results/imageHierarch_backward_uF', ...
                          num2str(0), '.png'));
for l=1:5
  im2Dsetup(uHis(:,:,l+1),D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_uF', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant v (current instance of v, i.e. v_l)
for l=0:5
  figure(8)
  im2Dsetup(vm+sum(uHis(:,:,l+1:end),3)-uHis(:,:,l+1), D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_vF', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant us (sum of all u up to l, i.e. sum(u_0:u_l))
for l=0:5
  figure(8)
  im2Dsetup(sum(uHis(:,:,1:l+1),3),D,[0,1]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_usF', ...
                            num2str(l), '.png'));
  clf;
end
%}


%{x
%compute hierarchical backward-forward decomposition of image
[uHis,vm] = bvHierarchDecom_BackFor(f, 1.6e3, 'm0', 3, 'm', 2, ...
  'stopTolROF', 1e-8, 'visualiseROF', false, 'displayROF', false, ...
  'maxIterROF', 200, 'ROFinitMeth', 'inputData', 'pauseTimeROF', 0);
%}

%{x
%save resultant u of forward decomposition (current instance of u, i.e. u_l)
figure(8)
im2Dsetup(uHis(:,:,1),D,[0,1]);
exportgraphics(gca,strcat('./Results/imageHierarch_backward_uB', ...
                          num2str(-3), '.png'));
for l=-2:2
  im2Dsetup(uHis(:,:,l+4),D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_uB', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant v (current instance of v, i.e. v_l)
for l=-3:2
  figure(8)
  im2Dsetup(vm+sum(uHis(:,:,l+4:end),3)-uHis(:,:,l+4), D,[-0.5,0.5]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_vB', ...
                            num2str(l), '.png'));
  clf;
end
%}

%{x
%save resultant us (sum of all u up to l, i.e. sum(u_0:u_l))
for l=-3:2
  figure(8)
  im2Dsetup(sum(uHis(:,:,1:l+4),3),D,[0,1]);
  exportgraphics(gca,strcat('./Results/imageHierarch_backward_usB', ...
                            num2str(l), '.png'));
  clf;
end
%}