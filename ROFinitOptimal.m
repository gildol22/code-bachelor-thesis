%=========================================================================
% function [alpha] = ROFinitOptimal(f,lambda)
%
% This function returns the parameter at which the optimal combination of
% f and its mean in terms of the objective function J of ROF is obtained
%
% code for Bachelor thesis from Ole Gildemeister
%
% Input:
% ------
%   f           [matrix] original 2D image (double) to be decomposed
%                    -- CELL CENTERED, spatial coord. system --
%   lambda      [num] scaling parameter that weighs residual |f-u|
%   varargin    ['name',param] optional parameter, see below
%
% Output:
% -------
%   alpha       [num] optimal combining parameter -> a*f + (1-a)*mean(f)
% It analytically holds: alpha = 1 - (|f|_BV /(2 lambda |f-mean(f)_2^2))
%=========================================================================

function [alpha] = ROFinitOptimal(f,lambda,varargin)

% parameter initialisation -----------------------------------------------
N = size(f);         % number of grid points in each dimension
D = [zeros(1,length(N)); N./max(N)]; % domain
   % standard domain s.t. squared grid cells and larger dim 0 to 1

for k=1:2:length(varargin)      % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

% -- end parameter set-up   ----------------------------------------------


% -- initialise  ---------------------------------------------------------
h = (D(2,:)-D(1,:)) ./ N;       % grid size

% define difference operators

% define discrete norms
fMean = mean(f,'all');

alpha = max( 1 - sum(sqrt( (([f(2:end,:); f(end,:)] - f)/h(1)).^2 +...
                 (([f(:,2:end), f(:,end)] - f)/h(2)).^2 ) ,'all') / ... %TVnorm
               ( 2*lambda * sum((f-fMean).^2,'all')), 0.1); %squared L2norm