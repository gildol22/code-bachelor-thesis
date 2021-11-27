%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Bachelor Thesis Ole Gildemeister                                %
%   Script to analyse previously computed hierarchical decomp.      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hisStr    = {'l','lambda','|Sum(u)|_BV','|u|_BV','|v|_2','|u|_2','normSum'};
    
fprintf('%3s %-10s %-12s %-11s %-11s %-11s %4s\n%s\n',...
  hisStr{:},char(ones(1,75)*'-'));
dispHis = @(var) ...
  fprintf('%3d %-10.2e %-12.4e %-11.3e %-11.3e %-11.3e %-11.3e\n',var);


N = size(f);         % number of grid points in each dimension
D = [zeros(1,length(N)); N./max(N)]; % domain
h = (D(2,:)-D(1,:)) ./ N;       % grid size
L2norm = @(a) sum(a.^2,'all') * prod(h); %squared; a contains only interior


steps = length(his)-1;
ul2 = zeros(steps+1,1);  % |u|_2 in each decomposition step
s=zeros(steps+1,1);      % sum( |u|_BV / lambda + |u|_2 ) as in Thm. 4.1

for i=1:steps+1
  ul2(i) = L2norm(uHis(:,:,i));
  s(i)= sum( his(1:i,4) ./ his(1:i,2) + ul2(1:i) );
  dispHis([his(i,1:5), ul2(i), s(i)]);
end

fprintf('|f|_2 = %11.3e\n', L2norm(f));