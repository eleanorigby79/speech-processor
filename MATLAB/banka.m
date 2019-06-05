close all;

 frameLength = 4096*2;
fileReader = audioDeviceReader('SamplesPerFrame',frameLength);
deviceWriter = audioDeviceWriter( ...
    'SampleRate',fileReader.SampleRate);
 % user interface control za prekid while petlje
h = 50;
w = 150;
figure('OuterPosition', [1920/2 1080/2  w h+90])
ButtonHandle = uicontrol('Style', 'PushButton', ...
                         'String', 'Stop recording', ...
                         'Callback', 'delete(gcbf)',...
                         'Position', [0 0 w h]);
                %<---
pause(0.5)
disp('Recording and sending started');
% alokacija memorije za snimljeni zvuk, velicine fs*sekundi, n broj 
% snimljenih uzoraka

lokalno=[];


    
          %<---
                                       %<---

release(fileReader)                         %<---
release(deviceWriter)         

Fn = 44100/2;                                      % Stopband Frequency (Normalised)

% fc = [200,250,315,400,500,630,800,1000,1250,1600,2000,2500,3150,4000,5000,6300,8024,10000,12500];
 Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
  A = zeros(4*21,6);
 
  [z,p,k] = butter(4,[0.001/Fn Wn(1)/Fn],'bandpass');  % Butterworth filter
  [sos] = zp2sos(z,p,k);          % Convert to SOS form
  A(1:4,1:6)= round(sos.*(2^15-1)); 
  j=4;
  for i=1:19
  [z,p,k] = butter(4,[Wn(i)/Fn Wn(i+1)/Fn],'bandpass');  % Butterworth filter
  [sos] = zp2sos(z,p,k);          % Convert to SOS form
  A(j+1:j+4,1:6)= round(sos.*(2^15-1)); 
  j = j+4;
  end
  [z,p,k] = butter(4,[Wn(20)/Fn 0.999],'bandpass');  % Butterworth filter
  [sos] = zp2sos(z,p,k);          % Convert to SOS form
  A(j+1:j+4,1:6)= round(sos.*(2^15-1)); 
                    
                    

 
 fileID = fopen('coeff.txt','w');
 for i=1:21*4
     for j=1:6
         if(j==2)
           fprintf(fileID,'%d,',0);
           fprintf(fileID,'%d,',A(i,j));
         elseif(j==4)
         else
            fprintf(fileID,'%d,',A(i,j));
         end      
     end
 end
 fclose(fileID);
% offset = [6,7,8,9];
% gain = 15;
% i=1;
% out = zeros(frameLength,1);
% %a = zeros(21,256);
% %figure;
%  while(i~=0)
%     audio = record(fileReader);
%     j=1;
%      for i=1:20
%           if(i==offset(j))
%              a  = sosfilt(C{1,i},audio); 
%              if(j<4)
%                  j = j+1;
%              end
%           else
%              a  = sosfilt(C{1,i},audio);
%           end
%           out = out + a;
% 
%      end
%     i=1;
%     %out = store;
%     
%     step(deviceWriter, out);
%       %xlim([200 800]);
%     %plot(fftshift(abs(fft(out))));drawnow;
%     out=0;
%     a=0;
% 
%  end
release(fileReader)                         %<---
release(deviceWriter) 





