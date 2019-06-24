function [x, frameLength] = thirdOctaveAnalysis(x,frameLength,audio,b,a,i,noBands)
%OCTAVEFILTERING Summary of this function goes here
%   Detailed explanation goes here
    
    if i<=noBands
            figure;
            f = fos(120000,24000);
            x(i,1:frameLength)=filtfilt(b(1,:),a(1,:),audio);
            x(i+1,1:frameLength)=filtfilt(b(2,:),a(2,:),audio);
            x(i+2,1:frameLength)=filtfilt(b(3,:),a(3,:),audio);
            plot(f,20*log10(fftshift(abs(fft(x(i,1:frameLength),120000)))),...
                f,20*log10(fftshift(abs(fft(x(i+1,1:frameLength),120000)))),...
                f,20*log10(fftshift(abs(fft(x(i+2,1:frameLength),120000)))));
        figure;
        audio = filtfilt(b(4,1:8),a(4,1:8),audio);
        plot(f,20*log10(fftshift(abs(fft(audio,120000)))));
        audio = audio - mean(audio);
        y = zeros(1,length(audio)/2);
        figure;
        y = 2.*audio(1:2:length(audio));
        plot(f,20*log10(fftshift(abs(fft(y,120000)))));
        frameLength = frameLength/2;
        [x, frameLength] = thirdOctaveAnalysis(x,frameLength,y,b,a,i+3,noBands);
    end

end

