%% Brain Tumor Detection and Parameters Extraction from MRI Images%%
clear all
close all
clc
I=imread('Image1.jpg');
imshow(I)
[m,n]=size(I);

%% Grayscale conversion 
Igray=rgb2gray(I);
imshow(Igray)

%% Averaging filter)
avg=ones(3,3)/9;
Iavg=imfilter(Igray,avg);
imshow(Iavg)
IavgMSE=immse(Iavg,Igray);

%% Median filtering 
Imed=medfilt2(Igray,[3,3]);
imshow(Imed)
ImedMSE=immse(Imed,Igray);

%% Wiener filtering 
Iwien= wiener2(Igray);
imshow(Iwien)
IwienMSE=immse(Iwien,Igray);

%% Gaussian (Not used here)
Igauss=fspecial(Igray,'gaussian');
imshow(Igauss)

%% Binary image filling 
BW=bwareaopen(Igray);
imshow(BW)
Ifill=imfill(Igray,'holes');
imshow(Ifill)

%% Prewitt edge finding filter
% Iprew = edge(Imed,'prewitt');
% imshow(Iprew)

%% Gaussian filter (Not Useful)
Igaus=imgaussfilt(Igray,1);
imshow(Igaus)


%% Segmentation USing K-means Clustering (Final)*
 Idata=reshape(Iwien, [],1);
 imshow(Iwien)
 Idata=double(Idata);
 
 [Idx nn]=kmeans(Idata,4);
 Imsame=reshape(Idx,size(Iwien));
 imshow(Imsame, [])
 imshow(Imsame==2, []); % Tumor in this cluster 
 figure
 subplot(2,2,1); imshow(Imsame==1, []);
 subplot(2,2,2); imshow(Imsame==2, []);
 subplot(2,2,3); imshow(Imsame==3, []);
 subplot(2,2,4); imshow(Imsame==4, []);
 
 bw=(Imsame==2);
 SE=ones(5);
 bw=imopen(bw,SE);
 imshow(bw);
 title('Brain Tumor with other small unwanted objects');
% bwstats=regionprops(bw,'Area');
% Area=bwstats.Area;
% bwm = max(Area);
 bw=bwareaopen(bw,500);
 figure
 imshow(bw)
 title('Segmented Brain Tumor')
 
 
%% Watershed Segmentation (Final)*
I=imread('Image1.jpg');
Igray=rgb2gray(I);
Imed=medfilt2(Igray,[3,3]);
imshow(Imed)
SE=strel('disk',40);
Iw=imtophat(Imed,SE); 
imshow(Iw)
I2=imadjust(Iw);
imshow(I2)
level=graythresh(I2);
BW = im2bw(I2,level);
imshow(BW)
SE2 = strel('disk',3);
Iero = imerode(BW,SE2);
imshow(Iero)
% Iero=bwareaopen(Iero,50);
% imshow(Iero)
c=~Iero;
imshow(c)
dis =-bwdist(c);
dis(c)=-Inf;
label=watershed(dis);
Iwi=label2rgb(label,'hot','r');
imshow(Iwi)
 

%% Otsu Segementation
im_thr=imtophat(Iwien,strel('disk',40));
imshow(im_thr);
im_adjust=imadjust(im_thr);
level=graythresh(im_adjust);
BW=im2bw(im_adjust,level);
SE_erode=strel('disk',3);
im_erode=imerode(BW,SE_erode);
imshow(im_erode);

%% Image Segementation Thresholoding (Otsu method, Another method)
% level=graythresh(Iwien);
BW=im2bw(Iwien,0.5);
imshow(BW);
background = imopen(BW,strel('disk',40));
Itum=BW-background;
imshow(Itum);
Itumad=imadjust(Itum);
imshow(Itumad);
bw=bwareaopen(Itumad,50);
imshow(bw)
cc=bwconncomp(bw,8);
Properties=regionprops(bw,'basic');

%% Examining one object (Otsu segmentation technique)
tumor = false(size(bw));
tumor(cc.PixelIdxList{6}) = true;
imshow(tumor);
tumorarea=regionprops(tumor(cc.PixelIdxList{19}),'Area');


%% Skull Stripping Method (Can be Used)
I=imread('brain16.jpg');
imshow(I)
Igray=rgb2gray(I);
Imed=medfilt2(Igray,[3,3]);
imshow(Imed)

Imed = im2double(Imed);
Imed = imresize(Imed, [256 256]);

level = graythresh(Imed) ;
BW = im2bw(Imed, level) ;

%opening operation
SE = strel('disk', 3) ;
BW = imopen(BW, SE) ;

%getting  biggest component
BW = bwareafilt(BW, 1) ;
imshow(BW)

%closing operation
BW = imclose(BW, SE) ;
figure
imshow(BW)
J = Imed.*BW;
imshow(J)                 %% Skull stripped image
% Imed2 = uint8(255 * J);

% Segmentation after Skull Stripping
SE=strel('disk',40);
Iw=imtophat(J,SE); 
imshow(Iw)
I2=imadjust(Iw);
imshow(I2)
level=graythresh(I2);
BW=im2bw(I2,level);
imshow(BW)

SE2=strel('disk',3);
Iero=imerode(BW,SE2);
imshow(Iero)

c=~Iero;
imshow(c)
dis=-bwdist(c);
dis(c)=-Inf;
label=watershed(dis);
Iwi=label2rgb(label,'hot','r');
imshow(Iwi)

Iwi2=rgb2gray(Iwi);
imshow(Iwi2)
Iwi2=im2bw(Iwi2);
imshow(Iwi2)
Tumor=bwareafilt(Iwi2,2,'largest');
imshow(Tumor)
% im=I;
% im(label==0)=0;
% imshow(im)

%% Skull removal (not useful)
[L,n]=bwlabel(BW);
mask=ismember(L,2:n);
Ibrai=Igray.*uint8(mask);
imshow(Ibrai)
% Imbin=imbinarize(Igray);
% Clear image border (not useful here)
BW2=imclearborder(BW);
imshow(BW2)
figure
imshow(BW)

%% Outer layer removal (Not Useful)
BW=imbinarize(Imed);
imshow(BW)
Imbrain=bwlabel(BW);
Ionlybrain=ismember(Imbrain,1);
imshow(Ionlybrain)
Ithick=imdilate( Ionlybrain, true(5));
imshow(Ithick)

% Bw=imbinarize(Igray);
% imshow(Bw)
%% Boundaray search (Not Useful)
Ib=bwboundaries(BW);
imshow(Ib)
I2 = imtophat(Igray,strel('disk',15));
imshow(I2)
%% Segmentation K-means Clustering (Not Useful)
SE = strel('disk', 3) ;
BW = imopen(Iwien, SE) ;
%gettingn  biggest component
BW = bwareafilt(BW, 1) ;
%closing operation
BW = imclose(BW, SE) ;
J = Iwien.*BW ;
imshow(J)

%% Brain Tumor Detection based on Tumor Solidity (Used for GUI development)
im=imread('Image1.jpg');
bw=im2bw(im,0.6);
label=bwlabel(bw);
%Properties
stats=regionprops(label,'Solidity','Area');

density=[stats.Solidity];
area=[stats.Area];

High_Density_Area=density > 0.5; % reduce to detect small or early stage tumors
 
MaxArea=max(area(High_Density_Area));
tumor_label=find(area==MaxArea);
tumor=ismember(label,tumor_label);
 
SE=strel('disk',5);
tumor=imdilate(tumor,SE);
imshow(tumor)

[B,L]=bwboundaries(tumor,8,'noholes');
imshow(im)
hold on
for i=length(B)
    plot(B{i}(:,2),B{i}(:,1),'r','linewidth',2)  %For boundary around the tumor
end
title('Brain Tumor Detected')
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

