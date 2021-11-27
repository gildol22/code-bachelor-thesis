%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Function to view previously computed hierarchical decomp.       %
%     - only use after initialising by corresponding script         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = testHierarchViewFctn(im,ax,uHis,l)

im.CData = sum(uHis(:,:,1:l+1),3)';
ax.Title = title(['$\Sigma_{\ell=0}^{',num2str(l),'} u_\ell$'], ...
                        'interpreter', 'latex');
end