%=========================================================================
% function [uHis,vm,his,hisROF] = bvHierarchDecom(f,lambda0,m,varargin)
%
% computes hierarchical (BV,L2) image decomposition forward
% with m+1 instances as introduced by Tadmor,Nezzar,Vese 2004
%
% code for Bachelor thesis from Ole Gildemeister
%
% Input:
% ------
%   f           [matrix] original 2D image (double) to be decomposed
%                    -- CELL CENTERED, spatial coord. system --
%   lambda0     [num] initial scaling parameter that weighs first decomp.
%   varargin    ['name',param] optional parameter, see below
%
% Output:
% -------
%   uHis        [3D array] computed BV parts u_0,...,u_m (double values),
%                        third dimension denotes instance l-1
%   vm          [matrix] last residual
%   his         [matrix] optional information on procedure history with:
%                        [l, lambda, |Sum(u)|_BV, |u|_BV, |v|_2, iterROF]
%   hisROF      [matrix] optional infos on each decomp.'s history with:
%                        [iter, J, Jold-J, |u|_BV, |f-u|, |uOld-u|]
%=========================================================================

function [uHis,vm,his,hisROF] = bvHierarchDecom(f,lambda0,varargin)

if nargin ==0 % help and minimal example
  help(mfilename);
  fprintf('-- MINIMAL EXAMPLE: --\n')
  minEx_bvHierarchDecom;
  fprintf('-- END OF MINIMAL EXAMPLE --\n\n')
  return;
end

% parameter initialisation -----------------------------------------------
% parameter for hierarchical decomposition (globally)
ROFdecomMeth = 'ROFdecom_FPGS'; %method for ROF decompositions
               %must be one of {'ROFdecom_FPGS','ROFdecom_FPGSrot'}
ROFinitMeth  = 'inputData';     % method for initialisation of ROF decomp.
               %must be one of {'inputData','optimal','mean'}
m            = 10;              % number of decomposition instances (-1)
s            = 2;               % scaling factor for increase of lambda
colourLim    = [0,1];           % limits for [black, white] in f
displayHie   = true;            % print procedure history?
visualiseHie = true;            % visualise steps in procedure?
pauseTimeHie = .2;              % pause for image visualis. in procedure

N            = size(f);         % number of grid points in each dimension
D = [zeros(1,length(N)); N./max(N)]; % domain
   % standard domain s.t. squared grid cells and larger dim 0 to 1

% parameter for each single decomposition
maxIterROF   = 30;              % maximum number of iterations
eps2ROF      = 1e-6;            % parameter to avoid singularity
stopTolROF   = 1e-7;            % tolerance for stopping criteria
displayROF   = false;           % print procedure history in ROF decomp.?
visualiseROF = false;           % visualise steps in ROF decomp.?
pauseTimeROF = .2;              % pause for image visualis. in ROF decomp.

for k=1:2:length(varargin)      % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

% -- end parameter set-up   -----------------------------------


% -- initialise  ---------------------------------------------------------
uHis = zeros([size(f), m+1]);    % history of BV parts from ROF decomp.'s
hisROF = zeros(maxIterROF+1,6,m+1); % history output of ROF decomp.'s
colourLimDiff = [colourLim(1)-colourLim(2), colourLim(2)-colourLim(1)]/2;
  %limits for [black, white] in residuals (only half of possible variation)


% define discrete norms
h = (D(2,:)-D(1,:)) ./ N;       % grid size
L2norm = @(a) sum(a.^2,'all') * prod(h); %squared; a contains only interior
TVnorm = @(a) sum(sqrt( (([a(2:end,:); a(end,:)] - a)/h(1)).^2 +...
                        (([a(:,2:end), a(:,end)] - a)/h(2)).^2  ...
                       ) ,'all') * prod(h);
    % TV = sqrt(DplusX^2 + DplusY^2); a without border lines

    
% input argument for u0 in ROF decomposition
ROFinitFirst  = 'alpha*f  + (1-alpha)*mean( f,''all'')';
ROFinitFollow = 'alpha*vc + (1-alpha)*mean(vc,''all'')';

if(strcmp(ROFinitMeth,'inputData'))
  alpha = 1;
else if(strcmp(ROFinitMeth,'optimal'))
  alpha = ROFinitOptimal(f,lambda0,'D',D);
else if(strcmp(ROFinitMeth,'mean'))
  alpha = 0.05; %computation needs little variation (Du=0 a.e. problematic)
else, error('ROF initialisation method not defined')
end, end, end


% ---- compute first decomposition and residual ----
[uHis(:,:,1), hisROF(:,:,1)] = eval([ROFdecomMeth, '(f, lambda0, ', ...
  '''D'', D, ''u0'', ', ROFinitFirst, ', ''maxIter'', maxIterROF, ', ...
  '''eps2'', eps2ROF, ''stopTol'', stopTolROF, ', ...
  '''displayROF'', displayROF, ''visualiseROF'', visualiseROF, ',  ...
  '''pauseTime'', pauseTimeROF, ''colourLim'', colourLim )']);

vc = f-uHis(:,:,1);             % current residual v_l, here v_0


% history and output initialisation
historyHie = displayHie | (nargout>2); % save infos on hierarch. history?

if(historyHie)
  his       = zeros(m+1,6);
  iterROF   = max(hisROF(:,1,1));
  his(1,:)  = [0, lambda0, hisROF(iterROF,4,1), hisROF(iterROF,4,1), ...
    hisROF(iterROF,5,1), iterROF];
  
  if(displayHie)
    hisStr    = {'l','lambda','|Sum(u)|_BV','|u|_BV','|v|_2','iterROF'};
    
    % first output
    fprintf('%3s %-10s %-12s %-11s %-11s %4s\n%s\n',...
      hisStr{:},char(ones(1,60)*'-'));
    dispHis = @(var) ...
      fprintf('%3d %-10.2e %-12.4e %-11.3e %-11.3e %3d\n',var);
    dispHis(his(1,:));
  end
end


% image initialisation
if(visualiseHie)
  figure(20)
  
  subplot(2,2,1)   %f
  [im_f,ax_f] = im2Dsetup(f,D,colourLim);
  ax_f.Title = title('f');
  
  subplot(2,2,2)   %Sum(u)
  [im_uSum,ax_uSum] = im2Dsetup(uHis(:,:,1),D,colourLim);
  ax_uSum.Title = title('$\Sigma_{\ell=0}^0 u_\ell$', ...
                        'interpreter', 'latex');
  
  subplot(2,2,3)   %uc
  [im_uc,ax_uc] = im2Dsetup(uHis(:,:,1),D,colourLim);
  ax_uc.Title = title('u_0');
  
  subplot(2,2,4)   %vc
  [im_vc,ax_vc] = im2Dsetup(vc,D,colourLimDiff);
  ax_vc.Title = title('v_0+0.5');
end



% -- end initialisation   ------------------------------------------------



% == MAIN LOOP ===========================================================
for l=1:m
  
  %If optimal initialisation chosen, compute start value u0
  if(strcmp(ROFinitMeth,'optimal'))
    alpha = ROFinitOptimal(vc,lambda0*s^l,'D',D);
  end
  
  
  %Compute next decomposition and residual
  [uHis(:,:,l+1), hisROF(:,:,l+1)] = eval([ROFdecomMeth, ...
    '( vc, lambda0*s^l, ''D'', D, ''u0'', ', ROFinitFollow, ...
    ', ''maxIter'', maxIterROF, ''eps2'', eps2ROF, ', ...
    '''stopTol'', stopTolROF, ''displayROF'', displayROF, ', ...
    '''visualiseROF'', visualiseROF, ''pauseTime'', pauseTimeROF, ', ...
    '''colourLim'', colourLimDiff )']);
  
  vc = vc-uHis(:,:,l+1);
  
  
  %history and output of latest step
  if(historyHie)
    iterROF = max(hisROF(:,1,l+1));
    his(l+1,:) = [l, lambda0*s^l, TVnorm(sum(uHis(:,:,:),3)), ...
                  hisROF(iterROF+1,4,l+1), hisROF(iterROF+1,5,l+1), iterROF];
                 %{'l','lambda','|Sum(u)|_BV','|u|_BV','|v|_2','iterROF'}
    if(displayHie), dispHis(his(l+1,:)); end
  end
  
  
  %update images with latest step
  if(visualiseHie)
    pause(pauseTimeHie)
    figure(20)
    
    subplot(2,2,2)   %Sum(u)
    [im_uSum,ax_uSum] = im2Dsetup(sum(uHis(:,:,:),3),D,colourLim);
    ax_uSum.Title = title(['$\Sigma_{\ell=0}^{',num2str(l),'} u_\ell$'], ...
                           'interpreter', 'latex');

    subplot(2,2,3)   %uc
    [im_uc,ax_uc] = im2Dsetup(uHis(:,:,l+1),D,colourLimDiff);
    ax_uc.Title   = title(['u_{', num2str(l), '}+0.5']);

    subplot(2,2,4)   %vc
    [im_vc,ax_vc] = im2Dsetup(vc,D,colourLimDiff);
    ax_vc.Title   = title(['v_{', num2str(l), '}+0.5']);
  end
  
end

vm=vc;         %final residual

if(displayHie)
  fprintf('DONE! \n\n')
end


end



function [] = minEx_bvHierarchDecom()
% minimal example for hierarchical decomposition

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512]));
f=flipud(I)';

bvHierarchDecom(f, 1e2);
end