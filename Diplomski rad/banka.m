close all;

 frameLength = 2048*2;
fileReader = audioDeviceReader('SamplesPerFrame',frameLength,'Device','Line (3- Steinberg UR22mkII )');
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);
 % user interface control za prekid while petlje

disp('Recording and sending started');
% alokacija memorije za snimljeni zvuk, velicine fs*sekundi, n broj 
% snimljenih uzoraka
     

Fn = 44100/2;                                      % Stopband Frequency (Normalised)
 fc = [200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000,12500];
 Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
  A = zeros(4*21,6);
 
%   [b,a] = butter(7,[20/Fn Wn(1)/Fn],'bandpass');  % Butterworth filter
%   %[sos] = zp2sos(z,p,k);          % Convert to SOS form
%   %A(1:4,1:6)= round(sos.*(2^15-1)); 
%   A(1,1:length([b a]))= [b a];
%   j=4;
%   for i=1:19
%   [b,a] = butter(7,[Wn(i)/Fn Wn(i+1)/Fn],'bandpass');  % Butterworth filter
%   %[sos] = zp2sos(z,p,k);          % Convert to SOS form
%   %A(j+1:j+4,1:6)= round(sos.*(2^15-1)); 
%   A(i,1:length([b a]))= [b a]; 
%   j = j+4;
%   end
%   [b,a] = butter(7,[Wn(20)/Fn 20/22.05],'bandpass');  % Butterworth filter
%   %[sos] = zp2sos(z,p,k);          % Convert to SOS form
%   %A(j+1:j+4,1:6)= round(sos.*(2^15-1)); 
%   A(20,1:length([b a]))= [b a];
% 
Fs = 44100;
f = [0:1:Fs/2-1];
figure;
N = 50;
for i=1:19
    f1 = fc(i)/(2^(1/6)); 
    f2 = fc(i)*(2^(1/6)); 
    Qr = fc(i)/(f2-f1); 
    Qd = (pi/2/N)/(sin(pi/2/N))*Qr;
    alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
    W1 = fc(i)/(Fs/2)/alpha; 
    W2 = fc(i)/(Fs/2)*alpha;
    [B] = fir1(N,[W1,W2],'bandpass'); 
    b(i,:) = B; %a(i,:) = A';
    H = freqz(B,1,Fn);
    plot(f,20*log10(abs(H)));
    hold on;
end

% BW = '1/3 octave';
% N = 8;
% F0 = 1000;
% Fs = 44100;
% oneThirdOctaveFilter = octaveFilter('FilterOrder', N, ...
%     'CenterFrequency', F0, 'Bandwidth', BW, 'SampleRate', Fs);
% F0 = getANSICenterFrequencies(oneThirdOctaveFilter);
% F0(F0<20) = [];
% F0(F0>20e3) = [];
% Nfc = length(F0);
% for i=1:Nfc
%     oneThirdOctaveFilterBank{i} = octaveFilter('FilterOrder', N, ...
%         'CenterFrequency', F0(i), 'Bandwidth', BW, 'SampleRate', Fs); %#ok
% end               

%  fileID = fopen('coeff.txt','w');
%  for i=1:21*4
%      for j=1:6
%          if(j==2)
%            fprintf(fileID,'%d,',0);
%            fprintf(fileID,'%d,',A(i,j));
%          elseif(j==4)
%          else
%             fprintf(fileID,'%d,',A(i,j));
%          end      
%      end
%  end
%  fclose(fileID);
offset = [8,9,10,11];
gain = 0;
k=1;
out = 0;
       % IIR filter design
                  % zero-phase filtering
figure;
%  while true
%     
%     audio = record(fileReader);
%     
%     j=1;
%      for i=1:19
%         if(i==offset(j))
%            x  = filter(b(i,:)*10^(gain/20),a(i,:),audio);    
%            
%            if(j<length(offset))
%               j = j+1;
%            end
%         else
%            x  = filter(b(i,:),a(i,:),audio);
%         end           
%         out = out + x;
%         k= k+4;
%         %disp(k+","+i);
%      end
%      i=1;
%         k=1;
% %         subplot(2,1,1)
% %     plot(f,20*log10(fftshift(abs(fft(out, Fn)))));
% %     subplot(2,1,2)
% %      plot(f,20*log10(fftshift(abs(fft(audio, Fn)))));
% %     drawnow;
%     out = audio + out;
%     step(deviceWriter, out);
%     out=0;
%     x=0;
% 
%  end
release(fileReader)                         %<---
release(deviceWriter) 






