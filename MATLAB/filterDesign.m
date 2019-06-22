function [fs1,fs2,n1,n2,b1,b2] = filterDesign(fc,rp,rs)
%FILTERDESIGN Summary of this function goes here
%   Detailed explanation goes here
f1 = fc/(2^(1/6)); 
f2 = fc*(2^(1/6)); 
fp1 = f1;
fp2 = f2;


fs = 44100;        %Sampling frequency

TBW1 = fc*0.1;
TBW2 = fc*0.1;


a = [0 1];        % Desired amplitudes
%Convert the deviations to linear units. Design the filter and visualize its magnitude and phase responses.
i=5;
temp = 0;
f1 = [(fp1 - TBW1) fp1];    %Cutoff frequencies
f2 = [fp2 (TBW2 + fp2)];    %Cutoff frequencies
dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 
while true
    
    [n1,fo1,ao1,w1] = firpmord(f1,[0 1],dev,fs);
    [n2,fo2,ao2,w2] = firpmord(f2,[1 0],dev,fs);
    
    if(n1 == n2 && n1 < 40)
        fs1 = (fp1 - TBW1);
        fs2 = (TBW2 + fp2);
        break;
    else
        TBW1 = 1.05*TBW1;
        TBW2 = 1.05*TBW2;
        f1(1) = (fp1 - TBW1);
        f2(2) = (fp2 + TBW2);
    end
end


end

