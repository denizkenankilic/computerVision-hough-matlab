clear all;
close all;
clc;

I=imread('Satellite-streak-long-exposure.jpg');
imshow(I);
IG=rgb2gray(I);
if ndims(IG) ~= 2 || ~isnumeric(IG),
    error('Hough_Grd: ''img'' has to be 2 dimensional');
end
if ~all(size(IG) >= 16),
    error('Hough_Grd: ''img'' has to be larger than 16-by-16');
end

% Radon
% abc(IG,0,10,170);


% Gradients
% [Gx, Gy] = imgradientxy(IG);
% [Gmag, Gdir] = imgradient(Gx, Gy);
% 
% figure, imshow(Gmag, []), title('Gradient magnitude')
% figure, imshow(Gdir, []), title('Gradient direction')
% title('Gradient Magnitude and Gradient Direction')
% figure; imshowpair(Gx, Gy, 'montage'); axis off;
% title('Directional Gradients, Gx and Gy')


bw1=edge(IG,'sobel');
bw2=edge(IG,'canny'); % visboundaries(bw2) gives region boundaries
[Dxx,Dxy,Dyy] = Hessian2D(bw2,0.7);

figure, imshow(bw1);
figure, imshow(bw2);
figure, imshow(Dxx,[]); % It can be used in Hough transformation instead of
% bw2

% Create the Hough transform using the binary image.
% rho = x*cos(theta) + y*sin(theta)
% Check RhoResolution and ThetaResol
[H,T,R] = hough(bw1,'RhoResolution',4,'Theta',-90:0.5:89.5); ution
figure, imshow(imadjust(mat2gray(H)),[],'XData',T,'YData',R,...
            'InitialMagnification','fit');
xlabel('\theta(degrees)'), ylabel('\rho');
axis on, axis normal, hold on; colormap(hot);

% Find peaks in the Hough transform of the image.
% peaks = houghpeaks(H,numpeaks) locates peaks in the Hough transform 
% matrix numpeaks specifies the maximum number of peaks to identify. 
% The function returns peaks a matrix that holds the row and column 
% coordinates of the peaks.
% Example: P = houghpeaks(H,2,'Threshold',15); Minimum value to be 
% considered a peak, specified as a nonnegative numeric scalar. 
% The value can be any value between 0 and Inf.
% NHoodSize is isze of suppresion neighborhood, smallest odd values grater 
% than or equal to size(H)/50(default)
P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
plot(x,y,'s','color','black');

% Find lines and plot them.
% Example: lines = houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
% FillGap is distance between two line segments assoc. with the same Hough
% transform bin. MinLength is min line length, positive scalar. Discard 
% lines that are shorter than the value specified. 
% FillGap 1-2, minlength 9-10 try
lines = houghlines(bw1,T,R,P,'FillGap',5,'MinLength',7);
figure, imshow(I), hold on
line_plot(lines)


% Notes: imrotate(I, theta,'loose');  % theta ranges from 0 to 180
% then use imfilter(I,f); where you may have 4 choice for f:
% f=[-1 -1 -1; 2 2 2;-1 -1 -1]; % horizontal line
% f=[-1 2 -1;-1 2 -1;-1 2 -1]; % vertical
% f=[-1 -1 2;-1 2 -1;2 -1 -1]; % 45 degree
% f=[2 -1 -1;-1 2 -1;-1 -1 2]; % 135 degree
% There is a naive method (though sounds a little silly): 
% imrotate your image from 0 to 90 degree with the 'loose' option, 
% and apply a horizontal(vertical, 45 degree) line filter to extract 
% all the lines.