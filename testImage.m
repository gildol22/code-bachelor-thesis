I2=rgb2gray(imread("Data/fjord.jpg"));
I4=imresize(I2,size(I2)/10);
%I4=imresize(I2,[10 5]);
I5 = im2double(I4) ;% + rand(size(I4))/10-.05;

I=flipud(I5)';

D = [0,0;1,1];
%N = size(I);         % number of grid points in each dimension
%h = (D(2,:)-D(1,:)) ./ N;       % grid size
colourLim    = [0,1];           % limits for [black, white]

%im = imagesc('XData', D(:,1)+[h(1)/2; -h(1)/2],...
%             'YData', D(:,2)+[h(2)/2; -h(2)/2], 'CData', flipud(rot90(I)));
       
%im = imagesc(D(:,1)+[h(1)/2; -h(1)/2], D(:,2)+[h(2)/2; -h(2)/2], rot90(I));
           
%ax = gca;
%ax.DataAspectRatio = [1 1 1];
%ax.CLim = colourLim;
%colormap gray


figure(1)
[im,ax] = im2Dsetup(I,D,colourLim);

%f=flipud(I);
%im.CData=f';