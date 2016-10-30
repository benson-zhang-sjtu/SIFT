clear; close all;
addpath('../standard_test_images');
I1 = imread('lena_gray_512.tif');
I2 = histeq(I1);
figure
subplot(2,2,1)
imshow(I1)
subplot(2,2,2)
imhist(I1)
subplot(2,2,3)
imshow(I2)
subplot(2,2,4)
imhist(I2)

%%
clear; close all;
I1 = imread('rice.png');
imshow(I1)
background = imopen(I1,strel('disk',15));
step = 8;
figure
surf(double(background(1:step:end,1:step:end))),zlim([0 255]);
set(gca,'ydir','reverse');
I2 = I1 - background;
imshow(I2)
I3 = imadjust(I2);
imshow(I3);
level = graythresh(I3);
bw = im2bw(I3,level);
figure
imshow(bw)
%%
bw1 = bwareaopen(bw, 50);
figure
imshow(bw1)
bw1-bw

%%
A = magic(5);
x = [19.5 23.5];
y = [8.0 12.0];
image(A,'XData',x,'YData',y), axis image, colormap(jet(25))

%%
imCPU = imread('concordaerial.png');
imGPU = gpuArray(imCPU);
imGPUgray = rgb2gray(imGPU);
imtool(gather(imGPUgray));

%%
imWaterGPU = imGPUgray<70;
figure;imshow(imWaterGPU);
%%
imWaterMask = imopen(imWaterGPU,strel('disk',4));
imWaterMask = bwmorph(imWaterMask,'erode',3);
imshow(imWaterMask);

%%
blurH       = fspecial('gaussian',20,5);
imWaterMask = imfilter(single(imWaterMask)*10, blurH);
imshow(imWaterMask);

%%
blueChannel  = imGPU(:,:,3);
blueChannel  = imlincomb(1, blueChannel,6, uint8(imWaterMask));
imGPU(:,:,3) = blueChannel;
figure;imshow(imGPU);

%%
I = imread('concordaerial.png');
Igpu = gpuArray(I); 
Igray_gpu = arrayfun(@rgb2gray_custom,Igpu(:,:,1),Igpu (:,:,2),Igpu(:,:,3));
I_gpuresult = gather(Igray_gpu);

%% 测试GPU速度和CPU速度  0.03s - 0.15s - 47.14s

num_iterations = 10000;

I = imread('concordaerial.png');
Igpu = gpuArray(I);
tic
for i = 1:num_iterations
    Igray_gpu = arrayfun(@rgb2gray_custom,Igpu(:,:,1),Igpu (:,:,2),Igpu(:,:,3));
end
toc
I_gpuresult = gather(Igray_gpu);
clear;

%% 3.15s - 31.54s - 320s
num_iterations = 10000;
I = imread('concordaerial.png');
tic
for i = 1:num_iterations
    Igray_gpu = rgb2gray_custom(I(:,:,1),I (:,:,2),I(:,:,3));
end
toc