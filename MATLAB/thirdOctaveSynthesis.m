function [y] = thirdOctaveSynthesis(x,frameLength,y,output,i,k,b,a,j)
%THIRDOCTAVESYNTHESIS Summary of this function goes here
%   Detailed explanation goes here
    if (i>1)
        
        temp(1:frameLength) = x(i,1:frameLength)+x(i-1,1:frameLength)+x(i-2,1:frameLength)+output;
        if(frameLength < 4096)
            y(k,1:2:2*frameLength) = temp(1:frameLength);
             temp = filtfilt(b(j,1:8),a(j,1:8),y(k,1:2*frameLength));
             output = zeros(1,frameLength*2);
             output(1,1:frameLength*2) = temp;
  %          output(1,1:frameLength*2) =  y(k,1:2*frameLength);
        else
            y(k,1:frameLength) = temp(1:frameLength);
        end
        frameLength = frameLength*2;
        y = thirdOctaveSynthesis(x,frameLength,y,output,i-3,k-1,b,a,j+1);
    end
end

