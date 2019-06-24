close all;
clear all;
 frameLength = 1024;
 %frameLength = 4800;
 Fs = 24000;


disp('Recording and sending started');       
freq = 400;
t = [0:1:24000*2-1];
sign = sin(2*freq/Fs*pi*t);

Fn = 24000/2;                                      % Stopband Frequency (Normalised)
%fc = [200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000];
fc = round(2.^(([22:39]-30)/3)*1000);
%Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
A = zeros(4*21,6);
N = length(fc);
%b = zeros(9,50);
f = [0:1:Fs/2-1];
figure;
M = 10;
for i=1:3
    [fs1,fs2,n1,n2] = filterDesign(fc(N-i+1),1,80,Fs);
    fp1 = fc(N-i+1)/(2^(1/6)); 
    fp2 = fc(N-i+1)*(2^(1/6)); 
    [b(i,:)] = firpm(30,[0 fs1 fp1 fp2 fs2 12000]/12000,[0 0 1 1 0 0],[120 1 120]);  
    H = freqz(b(i,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end
    f2 = fc(15)*2^(1/6);
    [b(i+1,:)] = firpm(30,[0  f2 6480 12000]/12000,[1 1 0 0],[0.4 120]);  
    H = freqz(b(i+1,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;

    [b(i+2,:)] = firpm(30,[0  f2 6240 12000]/12000,[1 1 0 0],[0.4 120]);  
    H = freqz(b(i+2,:),1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
  
f = fos(120000,24000);

z = 1;
f = fos(120000,24000);
sign2 = zeros(1,length(sign));
while true
    frameLength = 1024;
    
    x=zeros(N,frameLength);
    y = sign(1,z:z + 1024 - 1);
    i=1;
    while i<=18
%             figure;
            if(i ~= 1)
                frameLength = frameLength/2;
            end
            x(i,1:frameLength)=filter(b(1,:),1,y);
            x(i+1,1:frameLength)=filter(b(2,:),1,y);
            x(i+2,1:frameLength)=filter(b(3,:),1,y);
%             plot(f,20*log10(fftshift(abs(fft(x(i,1:frameLength),120000)))),...
%                 f,20*log10(fftshift(abs(fft(x(i+1,1:frameLength),120000)))),...
%                 f,20*log10(fftshift(abs(fft(x(i+2,1:frameLength),120000)))));
%         figure;
        filY = filter(b(4,:),1,y);
%         plot(f,20*log10(fftshift(abs(fft(audio,120000)))));
        y = zeros(1,length(filY)/2);
%         figure;
        y = filY(1:2:length(filY));
%         plot(f,20*log10(fftshift(abs(fft(y,120000)))));
        
        i = i + 3;
        
    end

    %2. korak - odraditi gain s offsetom
    %3. korak - interpolacija
    i = 18;
    temp = 0;
    output = 0;
    y = zeros(N/3-1,1024);
    j = 5;
    k = 5;
    while (i>0)
        
        temp(1:frameLength) = x(i,1:frameLength)+x(i-1,1:frameLength)+x(i-2,1:frameLength)+output;
        if(frameLength < 1024)
            y(k,1:2:2*frameLength) = temp(1:frameLength);
%             figure;
%             plot(f,20*log10(fftshift(abs(fft(y(k,:),120000)))));
%             hold on;
             output = filter(b(5,:),1,y(k,1:2*frameLength));
%              plot(f,20*log10(fftshift(abs(fft(output,120000)))));
        else
            out = temp(1:frameLength);
        end
        frameLength = frameLength*2;
        %j = j + 1;
        k = k - 1;
        i = i - 3;
    end
    
    figure;
    plot(f,20*log10(fftshift(abs(fft(out,120000)))));
    
    if (z > 48000-1024)
        break;
    else
        sign2(1,z:z + 1024 - 1) = y(1,1:1024);
        z = z + 1024;
    end
    
end



