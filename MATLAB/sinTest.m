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
fc = [200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000];
Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
A = zeros(4*21,6);
N = length(fc);

f = [0:1:Fs/2-1];
figure;
M = 10;
for i=1:3
     f1 = fc(N-i+1)/(2^(1/6)); 
    f2 = fc(N-i+1)*(2^(1/6)); 
    Qr = fc(N-i+1)/(f2-f1); 
    Qd = (pi/2/M)/(sin(pi/2/M))*Qr;
    alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
    W1 = fc(N-i+1)/(Fs/2)/alpha; 
    W2 = fc(N-i+1)/(Fs/2)*alpha;
    [b(i,:),a(i,:)] = butter(M,[W1,W2]); 
    H = freqz(b(i,:),a(i,:),Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end
[b(i+1,1:11),a(i+1,1:11)] = butter(M,W1);
H = freqz(b(i+1,1:11),a(i+1,1:11),Fn);
    plot(f,20*log10(abs(H)));
    hold on;

%plot(f,20*log10(abs(fft(audio,Fn))));
    k=5;
for i=16:-3:4
    f1 = fc(i)/(2^(1/6)); 
    f2 = fc(i)*(2^(1/6)); 
    Qr = fc(i)/(f2-f1); 
    Qd = (pi/2/M)/(sin(pi/2/M))*Qr;
    alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
    W1 = fc(i)/(Fs/2)/alpha; 
    W2 = fc(i)/(Fs/2)*alpha;
    [b(k,1:11),a(k,1:11)] = butter(M,W1);
    H = freqz(b(k,1:11),a(k,1:11),Fn);
    plot(f,20*log10(abs(H)));
    k=k+1;
    hold on;
end
% for i=5:9
% 	[b(i,:)] = fir1(M,(12000/k)/12000);
%     H = freqz(b(i,:),1,Fn);
%     plot(f,20*log10(abs(H)));
%     hold on;
%     k = k*2;
% end     
f = fos(120000,24000);

z = 1;
f = fos(120000,24000);
sign2 = zeros(1,length(sign));
while true
    frameLength = 1024;
    
    x=zeros(N,frameLength);
    audio = sign(1,z:z + 1024 - 1);
    i=1;
    y = audio;
    while i<=18
%             figure;
            if(i ~= 1)
                frameLength = frameLength/2;
            end
            x(i,1:frameLength)=filter(b(1,:),a(1,:),y);
            x(i+1,1:frameLength)=filter(b(2,:),a(2,:),y);
            x(i+2,1:frameLength)=filter(b(3,:),a(3,:),y);
%             plot(f,20*log10(fftshift(abs(fft(x(i,1:frameLength),120000)))),...
%                 f,20*log10(fftshift(abs(fft(x(i+1,1:frameLength),120000)))),...
%                 f,20*log10(fftshift(abs(fft(x(i+2,1:frameLength),120000)))));
%         figure;
        filY = filter(b(4,1:11),a(4,1:11),y);
%         plot(f,20*log10(fftshift(abs(fft(audio,120000)))));
        filY = filY - mean(filY);
        y = zeros(1,length(filY)/2);
%         figure;
        y = 2.*filY(1:2:length(filY));
%         plot(f,20*log10(fftshift(abs(fft(y,120000)))));
        
        i = i + 3;
        
    end

    %2. korak - odraditi gain s offsetom
    %3. korak - interpolacija
    i = 18;
    output = 0;
    y = zeros(N/3,1024);
    j = 5;
    k = 6;
    while (i>1)
        
        temp(1:frameLength) = x(i,1:frameLength)+x(i-1,1:frameLength)+x(i-2,1:frameLength)+output;
        if(frameLength < 1024)
            y(k,1:2:2*frameLength) = temp(1:frameLength);
             temp = filter(b(j,1:11),a(j,1:11),y(k,1:2*frameLength));
             output = temp;
%              output(1,1:frameLength*2) = temp;
        else
            y(k,1:frameLength) = temp(1:frameLength);
        end
        frameLength = frameLength*2;
        j = j + 1;
        k = k - 1;
        i = i - 3;
    end
    
    figure;
    plot(f,20*log10(fftshift(abs(fft(y(1,:),120000)))));
    
    if (z > 48000-1024)
        break;
    else
        sign2(1,z:z + 1024 - 1) = y(1,1:1024);
        z = z + 1024;
    end
    y = zeros(N/3,1024);
end



