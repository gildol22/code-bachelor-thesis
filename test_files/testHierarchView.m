%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to view previously computed hierarchical decomp.         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure(25)
[im, ax] = im2Dsetup(uHis(:,:,1),D,[0,1]);
ax.Title = title('$\Sigma_{\ell=0}^{0} u_\ell$', ...
                        'interpreter', 'latex');
                      
                      
                      
% Now, view the different instances by the following command
% (in Command Window) and selection specific "l":
%testHierarchViewFctn(im,ax,uHis,l)