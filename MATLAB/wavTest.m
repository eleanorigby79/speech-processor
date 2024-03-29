close all;
clear all;


frameLength = 2048;
Fs = 44100;
Fn = Fs/2;

disp('Recording and sending started');       
fileReader = dsp.AudioFileReader('proba2.wav','SamplesPerFrame',frameLength);
deviceWriter = audioDeviceWriter('SampleRate',fileReader.SampleRate);

fc = round(2.^(([22:42]-30)/3)*1000);

N = length(fc);
f = [0:1:Fn-1];

figure;
M = 10;
for i=1:3
    [fs1,fs2,n1,n2] = filterDesign(fc(N-i+1),1,80,Fs);
    fp1 = fc(N-i+1)/(2^(1/6)); 
    fp2 = fc(N-i+1)*(2^(1/6)); 
    [b(i,:)] = firpm(n1,[0 fs1 fp1 fp2 fs2 Fn]/Fn,[0 0 1 1 0 0],[120 1 120]);  
    H = freqz(b(i,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end
    f2 = fc(15)*2^(1/6);
    [b(i+1,:)] = firpm(n1,[0  f2 11907 Fn]/Fn,[1 1 0 0],[0.4 120]);  
    H = freqz(b(i+1,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;

    [b(i+2,:)] = firpm(n1,[0  f2 11466 Fn]/Fn,[1 1 0 0],[0.4 120]);  
    H = freqz(b(i+2,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
  
f = fos(120000,24000);

z = 1;
f = fos(120000,24000);
while ~isDone(fileReader)
    frameLength = 2048;
    tempFrameLength = frameLength;
    x=zeros(N,frameLength);
    y = fileReader();
    i=1;
    while i<=N
            if(i ~= 1)
                tempFrameLength = tempFrameLength/2;
            end
            x(i,1:tempFrameLength)=filter(b(1,:),1,y);
            x(i+1,1:tempFrameLength)=filter(b(2,:),1,y);
            x(i+2,1:tempFrameLength)=filter(b(3,:),1,y);

        filY = filter(b(4,:),1,y);
        y = zeros(1,length(filY)/2);
        y = filY(1:2:length(filY));
        
        i = i + 3;
        
    end

    %2. korak - odraditi gain s offsetom

    i = N;
    temp = 0;
    output = 0;
    y = zeros(N/3-1,frameLength);
    j = 5;
    k = N/3-1;
    while (i>0)
        
        temp(1:tempFrameLength) = x(i,1:tempFrameLength)+x(i-1,1:tempFrameLength)+x(i-2,1:tempFrameLength)+output;
        if(tempFrameLength < 2048)
            y(k,1:2:2*tempFrameLength) = temp(1:tempFrameLength);
             output = filter(b(5,:),1,y(k,1:2*tempFrameLength));
        else
            out = temp(1:tempFrameLength);
        end
        tempFrameLength = tempFrameLength*2;
        k = k - 1;
        i = i - 3;
    end
    
    deviceWriter(out');
    
end

release(fileReader);                   
release(deviceWriter);


