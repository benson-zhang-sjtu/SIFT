%% 在Image Filtering中， 高斯滤波有两种用法imfilter, imgaussfilt(imgaussfilt3)
% 两种用法有一些小差别， 其中imfilter的默认padding 是0, size是3x3, std是0.5
% 而imgaussfilt的默认padding是replicate, 其他一样
% Matlab建议直接使用imgaussfilt

clear; close all;
A = ones([3, 3], 'double')
h = fspecial('gaussian',3 ,0.5)
h1 = fspecial('gaussian')

B1 = imgaussfilt(A, 'Padding', 0)
B2 = imgaussfilt(A)

C1 = imfilter(A, h)
C2 = imfilter(A, h,'replicate')

pad_A = zeros([5,5], 'double');
pad_A(2:4, 2:4) = A;
filtered_A = zeros([3,3], 'double');
for i=1:3
    for j=1:3
        value = pad_A(i:i+2, j:j+2) .* rot90(h, 2);  % 可以不用旋转
        filtered_A(i,j) = sum(value(:));
    end
end
filtered_A

%% Gaussian函数的样子
[x, y] = meshgrid(-2:0.1:2,-2:0.1:2);
std = 0.5;
arg = -(x.*x + y.*y)/(2*std*std);
h = exp(arg);
surf(x, y, h)
colorbar; colormap(cool)
%% Gaussian滤波的效果
addpath('../standard_test_images')
I = im2double(imread('lena_gray_512.tif'));
figure
subplot(4,3,1)
imshow(I)
title('Original')
subplot(4,3,2)
imshow(imgaussfilt(I, 0.6))
title('sigma=0.6')
subplot(4,3,3)
imshow(imgaussfilt(I, 0.6,'Padding', 0))
title('0-Padding')
subplot(4,3,4)
imshow(imgaussfilt(I, 10))
title('sigma=10')
subplot(4,3,5)
imshow(imgaussfilt(I, 10,'Padding', 0))
title('0-Padding')
subplot(4,3,7)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 5,'Padding', 0))
title('PatchSize 5')
subplot(4,3,8)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 9,'Padding', 0))
title('PatchSize 9')
subplot(4,3,9)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 13,'Padding', 0))
title('PatchSize 13')
subplot(4,3,10)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 5))
title('PatchSize 5')
subplot(4,3,11)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 9))
title('PatchSize 9')
subplot(4,3,12)
imshow(imgaussfilt(I, 0.6, 'FilterSize', 13))
title('PatchSize 13')
