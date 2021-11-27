%=========================================================================
% function [im,ax] = im2Dsetup(I,D,colourLim)
%
% setting up image figure in spatial coordinates
%
% code for Bachelor thesis from Ole Gildemeister
%
% Input:
% ------
%   I           [matrix] 2D image (double) to display first
%                    -- CELL CENTERED, spatial coord. system --
%   D           [2x2 matrix] domain, each column represents one axis
%   colourLim   [2x1 vector] colour limits of form [black, white]
%
% Output:
% -------
%   im          image object - NOTE: When updating, data must be transposed
%   ax          corresponding axes object
%=========================================================================

function [im,ax] = im2Dsetup(I,D,colourLim)
N = size(I);         % number of grid points in each dimension
h = (D(2,:)-D(1,:)) ./ N;       % grid size

im = imagesc('XData', D(:,1)+[h(1)/2; -h(1)/2],...
             'YData', D(:,2)+[h(2)/2; -h(2)/2], 'CData', I');
ax = gca;
%ax.XLimitMethod = 'tight'; ax.YLimitMethod = 'tight'; NEEDS R2021a!!!
ax.DataAspectRatio = [1 1 1];
ax.CLim = colourLim;
colormap gray
end