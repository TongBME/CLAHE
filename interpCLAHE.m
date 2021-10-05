function [CEImage] = interpCLAHE(Image,Map,LUT,NrX,NrY,Cliplimit)

[XRes,YRes]=size(Image);
CEImage = zeros(XRes,YRes);
if Cliplimit == 1
    return
end

XSize = round(XRes/NrX);
YSize = round(YRes/NrY);

Bin=1+LUT(round(Image)+1); 

% Interpolate
xI = 1;
for i = 1:NrX+1
    if i == 1
        subX = XSize/2;
        xU = 1;
        xB = 1;
    elseif i == NrX+1
        subX = XSize/2;
        xU = NrX;
        xB = NrX;
    else
        subX = XSize;
        xU = i - 1;
        xB = i;
    end
    yI = 1;
    for j = 1:NrY+1
        if j == 1
            subY = YSize/2;
            yL = 1;
            yR = 1;
        elseif j == NrY+1
            subY = YSize/2;
            yL = NrY;
            yR = NrY;
        else
            subY = YSize;
            yL = j - 1;
            yR = j;
        end
        UL = Map(xU,yL,:);
        UR = Map(xU,yR,:);
        BL = Map(xB,yL,:);
        BR = Map(xB,yR,:);
        subImage = Bin(xI:xI+subX-1,yI:yI+subY-1);
        subImage = interpolate(subImage,UL,UR,BL,BR,subX,subY);
        CEImage(xI:xI+subX-1,yI:yI+subY-1) = subImage;
        yI = yI + subY;
    end
    xI = xI + subX;
end

