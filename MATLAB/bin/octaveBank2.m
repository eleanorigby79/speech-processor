close all;
clear all;
 frameLength = 4096;
 Fs = 24000;
 %'Device','Line (3- Steinberg UR22mkII )'
% fileReader = audioDeviceReader('SamplesPerFrame',frameLength,'OutputDataType','int16','SampleRate',Fs);
% deviceWriter = audioDeviceWriter( ...
%     'SampleRate',fileReader.SampleRate);
 % user interface control za prekid while petlje
 
%  fileReader = dsp.AudioFileReader( ...
%     'proba2.wav', ...
%     'SamplesPerFrame',frameLength);
% deviceWriter = audioDeviceWriter( ...
%     'SampleRate',fileReader.SampleRate);
% SpecAnalyzer = dsp.SpectrumAnalyzer('SampleRate',fileReader.SampleRate);
freq = 400;
t = [0:1/Fs:5.1/Fs];
sign = sin(2*400*pi*t);
disp('Recording and sending started');       

Fn = 24000/2;                                      % Stopband Frequency (Normalised)
fc = [200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000];
Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
A = zeros(4*21,6);
N = length(fc);

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
    [b(i,:),a(i,:)] = butter(M,[W1,W2]); 
    H = freqz(b(i,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end

[b(i+1,:),b(i,:)] = butter(M,W1);
H = freqz(b(i+1,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
%plot(f,20*log10(abs(fft(audio,Fn))));
hold on;
    k=5;
for i=16:-3:4
    f1 = fc(i)/(2^(1/6)); 
    f2 = fc(i)*(2^(1/6)); 
    Qr = fc(i)/(f2-f1); 
    Qd = (pi/2/M)/(sin(pi/2/M))*Qr;
    alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
    W1 = fc(i)/(Fs/2)/alpha; 
    W2 = fc(i)/(Fs/2)*alpha;
    [b(k,:),a(k,:)] = butter(M,W1); 
    H = freqz(b(k,:),1,Fn);
    plot(f,20*log10(abs(H)));
    k=k+1;
    hold on;
end

y = zeros(N/3,4096);
while ~isDone(fileReader)
    frameLength = 4096;
    output = 0;
    x=zeros(N,frameLength);
%     audio = record(fileReader);
%     audio = fileReader();
%     audio = audio.*10^(40/20);
    
    i=1;
    [x, frameLength] = thirdOctaveAnalysis(x,frameLength,sign,b,a,i,length(fc));
    %2. korak - odraditi gain s offsetom
    %3. korak - interpolacija
    
    y = thirdOctaveSynthesis(sign,frameLength,y,output,length(fc),6,b,a,9);
   % output = y(1,:)+y(2,:)+y(3,:)+y(4,:)+y(5,:)+y(6,:);
    
    %deviceWriter(y(1,:)');
    step(SpecAnalyzer,y(1,:)');
    %step(SpecAnalyzer,audio);
    y = zeros(N/3,4096);
end



% release(fileReader);                         %<---
% release(deviceWriter);
% release(SpecAnalyzer);


