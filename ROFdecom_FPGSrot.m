%=========================================================================
% function [u,his] = ROFdecom_FPGSrot(f,lambda,varargin)
%
% (BV,L2) image decomposer for greyscale by minimising ROF-J-functional
% using fixed point Gauss-Seidel as proposed by Tadmor,Nezzar,Vese 2004
% - rotates the image counterclockwise after every step by 90°
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
%   u           [matrix] BV part of decomposition (double)
%   his         [matrix] optional information on procedure history with:
%                        [iter, J, Jold-J, |u|_BV, |f-u|, |uOld-u|]
%=========================================================================

function [u,his] = ROFdecom_FPGSrot(f,lambda,varargin)

if nargin ==0 % help and minimal example
  help(mfilename);
  fprintf('-- MINIMAL EXAMPLE: --\n')
  minEx_ROFDecom(mfilename);
  fprintf('-- END OF MINIMAL EXAMPLE --\n\n')
  return;
end

% parameter initialisation -----------------------------------------------
maxIter      = 30;              % maximum number of iterations
eps2         = 1e-6;            % parameter to avoid singularity
stopTol      = 3e-7;            % tolerance for stopping criteria
u0           = f;               % initial guess for u
optimalInit  = false;
     % use optimal combination of f and mean(f) for initialisation u0?
colourLim    = [0,1];           % limits for [black, white]
displayROF   = true;            % print procedure history?
visualiseROF = true;            % visualise steps in procedure?
pauseTime    = .2;              % pause for image visualisation

N            = size(f);         % number of grid points in each dimension
D = [zeros(1,length(N)); N./max(N)]; % domain
   % standard domain s.t. squared grid cells and larger dim 0 to 1

for k=1:2:length(varargin)      % overwrites default parameter
  eval([varargin{k},'=varargin{',int2str(k+1),'};']);
end

% -- end parameter set-up   ----------------------------------------------


% -- initialise  ---------------------------------------------------------
h = (D(2,:)-D(1,:)) ./ N;       % grid size
%quadratPixel = all(h == h(1));  % is pixel size quadratic? fasten comput.

lh2 = 2*lambda*prod(h.^2);   % computational constant

% If chosen, compute "optimal" initialisation
if(optimalInit)
  alpha = ROFinitOptimal(f,lambda,'D',D)
  u0 = alpha*f + (1-alpha)*mean(f,'all');
end

% current guess for u incl. border lines with reflection boundary
uc = u0([1,1:end,end],[1,1:end,end]);
uOld = uc;                      % previous guess for computation

%{
   bc        centre         bc
 +-----+-----+-----+-----+-----+
 |     |     |     |     |     |
 |  .  |  .  |  .  |  .  |  .  |
 |     |     |     |     |     |
 +-----+-----+-----+-----+-----+
 |     |     |     |     |     |
 |  .  |(1,2)>  x  >  x  >  .  |
 |     |     |     |     |     |
 +-----+--^--+--^--+--^--+--^--+   -                 y
 |     |     |     |     |     |                     ^
 |  .  |(1,1)>(2,1)>  x  >  .  |  h(2)               |
 |     |     |     |     |     |
 +-----0--^--+--^--+--^--+--^--+   -        origin = 0 -> x
 |     |     |     |     |     |
 |  .  |  .  |  .  |  .  |  .  |
 |     |     |     |     |     |
 +-----+-----+-----+-----+-----+
                       
       | h(1)|
                      
 %}

% define difference operators
DplusX =   @(a,i,j) (a(i+1,j) - a(i,j))   / h(1);
DminusX =  @(a,i,j) (a(i,j)   - a(i-1,j)) / h(1);
DcentreX = @(a,i,j) (a(i+1,j) - a(i-1,j)) / h(1)/2;

DplusY =   @(a,i,j) (a(i,j+1) - a(i,j))   / h(2);
DminusY =  @(a,i,j) (a(i,j)   - a(i,j-1)) / h(2);
DcentreY = @(a,i,j) (a(i,j+1) - a(i,j-1)) / h(2)/2;


% define discrete norms
L2norm = @(a) sum(a.^2,'all') * prod(h); %squared; a contains only interior
TVnorm = @(a) sum(sqrt( ((a(3:end,2:end-1) - a(2:end-1,2:end-1))/h(1)).^2 +...
                        ((a(2:end-1,3:end) - a(2:end-1,2:end-1))/h(2)).^2  ...
                       ) ,'all') * prod(h);
    % TV = sqrt(DplusX^2 + DplusY^2); a without border lines

%define J-functional (to be minimised here)
J = @(u) TVnorm(u) + lambda*L2norm(f-u(2:end-1,2:end-1));
    %Note: dimension of u does not include artificially added border lines

    
    
% history and output initialisation
historyROF = displayROF | (nargout>1); % save infos on procedure history?

if(historyROF)
  his       = zeros(maxIter+1,6);
  Jold = J(uc);
  his(1,:)  = [0,Jold,0,TVnorm(uc),L2norm(f-u0),L2norm(u0)];
  
  if(displayROF)
    hisStr    = {'iter','J','Jold-J','|u|_BV','|f-u|','|uOld-u|'};
    
    % first output
    fprintf('%4s %-12s %-11s %-11s %-11s %4s\n%s\n',...
      hisStr{:},char(ones(1,64)*'-'));
    dispHis = @(var) ...
      fprintf('%4d %-12.4e %-11.3e %-11.3e %-11.3e %-11.3e\n',var);
    dispHis(his(1,:));
  end
end


% image initialisation
if(visualiseROF)
  figure(10)
  [im_uc,ax_uc] = im2Dsetup(u0,D,colourLim);
  ax_uc.Title = title('u^{(0)}');
end


% -- end initialisation   ------------------------------------------------



% == MAIN LOOP ===========================================================
for iter=1:maxIter              % number of iteration
  for i=2:N(1)+1                % x-dim = row
    for j=2:N(2)+1              % y-dim = column
      
      %{
      %Compute constants forward
      cE = 1/sqrt(eps2 +    DplusX(uOld,i,j)^2   + DplusY(uOld,i,j)^2);
      cW = 1/sqrt(eps2 +   DminusX(uOld,i,j)^2   + DplusY(uOld,i-1,j)^2);
      cN = 1/sqrt(eps2 +  DplusX(uOld,i,j)^2   + DplusY(uOld,i,j)^2);
      cS = 1/sqrt(eps2 +  DplusX(uOld,i,j-1)^2 + DminusY(uOld,i,j)^2);
      %}
      
      %{x
      %Compute constants symmetrically
      cE = 1/sqrt(eps2 +    DplusX(uOld,i,j)^2   + DcentreY(uOld,i,j)^2);
      cW = 1/sqrt(eps2 +   DminusX(uOld,i,j)^2   + DcentreY(uOld,i-1,j)^2);
      cN = 1/sqrt(eps2 +  DcentreX(uOld,i,j)^2   + DplusY(uOld,i,j)^2);
      cS = 1/sqrt(eps2 +  DcentreX(uOld,i,j-1)^2 + DminusY(uOld,i,j)^2);
      %}
      

      %{
        +-----cN-----+
        |            |
        |            |
       cW     XX     cE
        |            |
        |            |
        +-----cS-----+
      %}
      
      %Compute most recent value of uc
      uc(i,j) = ( lh2*f(i-1,j-1) + h(2)^2*(cE*uc(i+1,j) + cW*uc(i-1,j)) +...
                                   h(1)^2*(cN*uc(i,j+1) + cS*uc(i,j-1))  ...
                 ) / ( lh2 + h(2)^2*(cE+cW) + h(1)^2*(cN+cS) );
    end
  end
  
  %update border lines by reflection boundary condition
  uc(1,:)   = uc(2,:);
  uc(end,:) = uc(end-1,:);
  uc(:,1)   = uc(:,2);
  uc(:,end) = uc(:,end-1);
  
  
  %compute update size for display and stopping criterion
  uDiff = L2norm(uc(2:end-1,2:end-1)-uOld(2:end-1,2:end-1));
  
  
  %history and output of latest step
  if(historyROF)
    Jc = J(uc);
    his(iter+1,:) = [iter, Jc, Jold-Jc, TVnorm(uc), ...
                     L2norm(f-uc(2:end-1,2:end-1)), uDiff];
    if(displayROF), dispHis(his(iter+1,:)); end
    Jold = Jc;
  end
  
  
  %image of latest step
  if(visualiseROF)
    pause(pauseTime)
    im_uc.CData = rot90(uc(2:end-1,2:end-1),1-iter)';
    ax_uc.Title = title(['u^{(', num2str(iter), ')}']);
  end
  

  
%!!!!!!!!!!!!!!!!!!!!!!
%{
  %check whether second stopping criterion might be satisfied
  fprintf('(u,f-u) = %-12.4e ; |u|_BV/2lam = %-12.4e\n', ...
    [sum(uc(2:end-1,2:end-1).*(f-uc(2:end-1,2:end-1)),'all') * prod(h),...
    TVnorm(uc)/2/lambda])
%}
%{
  %check whether second stopping criterion might be satisfied
  disp(abs(sum(uc(2:end-1,2:end-1).*(f-uc(2:end-1,2:end-1)),'all') * prod(h)-...
    TVnorm(uc)/2/lambda))
%}


  
  %check stopping criterion (with squared L2-norm of last update)  
  if uDiff < stopTol
    uc = rot90(uc,1-iter);
    break;
  end
  
  %rotate image counterclockwise by 90° and adjust dimensions and functions
  uc = rot90(uc); f = rot90(f); N = flip(N); h = flip(h);
  J = @(u) TVnorm(u) + lambda*L2norm(f-u(2:end-1,2:end-1));

  uOld = uc;
  
  %if maxIter reached, rotate image back
  if(iter==maxIter), uc = rot90(uc,-iter); end

end

u = uc(2:end-1, 2:end-1);       % final image without border lines
if(displayROF)
  fprintf('DONE! \n\n')
end
end