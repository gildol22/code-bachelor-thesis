%=========================================================================
% function[] = minEx_ROFDecom(method)
%
% minimal example for a (BV,L2) image decomposition for greyscale 
% by minimising ROF-J-functional with specified method
% using Gauss-Seidel method as proposed by Tadmor,Nezzar,Vese 2004
%
% code for Bachelor thesis from Ole Gildemeister
%
% Input:
% ------
%   method      [string] name of method that minEx is being called in
%=========================================================================

function[] = minEx_ROFDecom(method)

I=rgb2gray(imread("Data/fjord.jpg"));
I=im2double(imresize(I,[512,512]));
f=flipud(I)';

D=[0,0;1,1];

u = eval([method, '(f, 1e3)']);

figure(12)
subplot(1,2,1)
[im_u, ax_u] = im2Dsetup(u,D,[0,1]);
ax_u.Title=title('u_\lambda');

subplot(1,2,2)
[im_v, ax_v] = im2Dsetup(f-u,D,[-.5,.5]);
ax_v.Title=title('v_\lambda+0.5');

end