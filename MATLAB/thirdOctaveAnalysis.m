function [x, frameLength] = thirdOctaveAnalysis(x,frameLength,audio,b,i)
%OCTAVEFILTERING Summary of this function goes here
%   Detailed explanation goes here
    
    if i<=18
        for i=i:3+i-1
            x(i,1:frameLength)=filter(b(mod(i,3)+1,:),1,audio);
        end
        y = audio(1:2:length(audio));
        frameLength = frameLength/2;
        [x, frameLength] = thirdOctaveAnalysis(x,frameLength,y,b,i+1);
    end

end

