function [Map,Sum] = mapHistogram(Hist,Min,Max,NrBins,NrPixels,NrX,NrY)
%  This function calculates the equalized lookup table (mapping) by
%  cumulating the input histogram. Note: lookup table is rescaled in range [Min..Max].

Map = zeros(NrX,NrY,NrBins);

Scale = round(2048* (Max - Min)/ NrPixels); 
%       round(2048 * 256 / (240*216)) = 10;

for i = 1:NrX
    for j = 1:NrY
        Sum = 0;
        for nr = 1:NrBins
            Sum = round(Sum + Hist(i,j,nr));
            pixNum = Sum *Scale /2048;
            Map(i,j,nr) = fix(min(pixNum,Max));
        end
    end
end

