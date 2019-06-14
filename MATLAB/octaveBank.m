close all;
clear all;
 frameLength = 2048*2;
 %'Device','Line (3- Steinberg UR22mkII )'
fileReader = audioDeviceReader('SamplesPerFrame',frameLength);
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);
 % user interface control za prekid while petlje

disp('Recording and sending started');
% alokacija memorije za snimljeni zvuk, velicine fs*sekundi, n broj 
% snimljenih uzoraka

lokalno=[];


    
          %<---
                                       %<---

release(fileReader)                         %<---
release(deviceWriter)         

Fn = 44100/2;                                      % Stopband Frequency (Normalised)
 fc = [200,250,315,400,500,630,800,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000,12500];
 Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
  A = zeros(4*21,6);
 N = length(fc);
Fs = 44100;
f = [0:1:Fs/2-1];
figure;
M = 40;
for i=1:3
    f1 = fc(N-i+1)/(2^(1/6)); 
    f2 = fc(N-i+1)*(2^(1/6)); 
    Qr = fc(N-i+1)/(f2-f1); 
    Qd = (pi/2/M)/(sin(pi/2/M))*Qr;
    alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
    W1 = fc(N-i+1)/(Fs/2)/alpha; 
    W2 = fc(N-i+1)/(Fs/2)*alpha;
    [b(i,:)] = fir1(M,[W1,W2]); 
    H = freqz(b(i,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end
y = zeros(N/3,frameLength);
while true
    frameLength = 4096;
    output = 0;
    x=zeros(N,frameLength);
    audio = record(fileReader);
    
    i=1;
    [x, frameLength] = thirdOctaveAnalysis(x,frameLength,audio,b,i);
    %2. korak - odraditi gain s offsetom
    %3. korak - interpolacija
    
    y = thirdOctaveSynthesis(x,frameLength,y,output,18);
    output = y(1,:)+y(2,:)+y(3,:)+y(4,:)+y(5,:)+y(6,:);
    step(deviceWriter, output');
end



release(fileReader)                         %<---
release(deviceWriter) 


