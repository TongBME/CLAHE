clear all
clc;
close all

% Key: vessel enhancement
% Main function: [runCLAHE] uses "Contrast Limited Adaptive Histogram Equalization"
%                to increase contrasting of image.
% Main steps:
            % - Read frame
            % - CLAHE
            % - interpolate
% Note: 
        % - calculate CDF in first frame, and that be used in second frame.
        % - CLAHE: a.make histogram; b.clip histogram; c.map histogram.
  
% Writer: Owen, 2021-08-16

%% parameters setting
%    Image1 - The input image in first frame
%    Image2 - The input image in second frame
%    XRes - Image resolution in the X direction
%    YRes - Image resolution in the Y direction
%    maxGray - Maximum greyvalue of input image
%    minGray - Minimum greyvalue of input image 
%    NrBins - Number of greybins for histogram (dynamic range)
%    NrX - Number of contextial regions in the X direction (min 2, max uiMAX_REG_X)
%    NrY - Number of contextial regions in the Y direction (min 2, max uiMAX_REG_Y)
%    Cliplimit - Normalized cliplimit (higher values give more contrast)
%    saturationPara - for change of saturation in HSV

inputImage     = [];
Image2     = [];
XRes       = 1080;
YRes       = 1920;
BIT        = 8;
maxGray    = 2^BIT-1;
minGray    = 0;
NrBins     = 2^BIT;
NrX        = 5;
NrY        = 8;
Cliplimit  = 2;
saturationPara = 1.0; % if 1.0, saturation deosn't change

inputImage = imread('unprocessedImg.jpg');

% CLAHE in one chanel: R/G/B
for chanelRGB = 1:1:3
    [Map,LUT] = runCLAHE(inputImage(:,:,chanelRGB),XRes,YRes,maxGray,minGray,NrBins,NrX,NrY,Cliplimit);
    % interpolate
    imageInterp(:,:,chanelRGB) = interpCLAHE(inputImage(:,:,chanelRGB),Map,LUT,NrX,NrY,Cliplimit);
end

imshow(uint8(imageInterp));

