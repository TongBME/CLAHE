function [Map,LUT] = runCLAHE(Image,XRes,YRes,Max,Min,NrBins,NrX,NrY,Cliplimit)
                            
%  "Contrast Limited Adaptive Histogram Equalization"

%   These functions implement Contrast Limited Adaptive Histogram Equalization.
%   The main routine (CLAHE) expects an input image that is stored contiguously in
%   memory;  the CLAHE output image overwrites the original input image and has the
%   same minimum and maximum values (which must be provided by the user).
%   This implementation assumes that the X- and Y image resolutions are an integer
%   multiple of the X- and Y sizes of the contextual regions. A check on various other
%   error conditions is performed.
% 
% 
%    Image - The input/output image
%    XRes - Image resolution in the X direction
%    YRes - Image resolution in the Y direction
%    Min - Minimum greyvalue of input image (also becomes minimum of output image)
%    Max - Maximum greyvalue of input image (also becomes maximum of output image)
%    NrX - Number of contextial regions in the X direction (min 2, max uiMAX_REG_X)
%    NrY - Number of contextial regions in the Y direction (min 2, max uiMAX_REG_Y)
%    NrBins - Number of greybins for histogram ("dynamic range")
%    Cliplimit - Normalized cliplimit (higher values give more contrast)


%  The number of "effective" greylevels in the output image is set by uiNrBins; selecting
%  a small value (eg. 128) speeds up processing and still produce an output image of
%  good quality. The output image will have the same minimum and maximum value as the input
%  image. A clip limit smaller than 1 results in standard (non-contrast limited) AHE.

if Cliplimit == 1
    return
end

NrBins   = max(NrBins,128);
XSize    = round(XRes/NrX);
YSize    = round(YRes/NrY);
NrPixels = XSize * YSize;

if Cliplimit > 0 
    ClipLimit = max(1,Cliplimit*XSize*YSize/NrBins);
else
    ClipLimit = 1E8;
end

LUT = makeLUT(Min,Max,NrBins);
Bin = 1 + LUT(round(Image)+1);

% 0# make histogram
Hist = makeHistogram(Bin,XSize,YSize,NrX,NrY,NrBins);
if Cliplimit > 0
    % 1# clip histogram
    Hist = clipHistogram(Hist,NrBins,ClipLimit,NrX,NrY);
end
% 2# map histogram
Map = mapHistogram(Hist,Min,Max,NrBins,NrPixels,NrX,NrY);
