function [y] = thirdOctaveSynthesis(x,frameLength,y,output,i)
%THIRDOCTAVESYNTHESIS Summary of this function goes here
%   Detailed explanation goes here
    if (i>1)
        frameLength = frameLength*2;
        output(1:frameLength) = x(i,1:frameLength)+x(i-1,1:frameLength)+x(i-2,1:frameLength)+output;
        if(frameLength < 4096)
            y(i,1:2:2*frameLength) = output(1:frameLength);
            output = zeros(1,frameLength*2);
        else
            y(i,1:frameLength) = output(1:frameLength);
            output = zeros(1,frameLength*2);
        end
        y = thirdOctaveSynthesis(x,frameLength,y,output,i-3);
    end
end

