% close all;
% %FIR/IIR Usporedba
% Fn = 44100/2;
% 
% %IIR
% Wn = [178,224,282,355,447,562,708,891,1120,1410,1780,2240,2820,3550,4470,5620,7080,8910,11200,14100];
% A = zeros(4*21,6);
%  
%   [b1,a1] = butter(4,[Wn(12)/Fn Wn(13)/Fn],'bandpass');  % Butterworth filter
% %   [sos] = zp2sos(z,p,k);          % Convert to SOS form
% %   A(1:4,1:6)= round(sos.*(2^15-1)); 
% 
% %FIR
% [b] = firpm(50,[0 Wn(11)/Fn Wn(12)/Fn Wn(13)/Fn Wn(14)/Fn 1],[0 0 1 1 0 0],'bandpass');
% figure;
% freqz(b1,a1)
% figure;
% freqz(b,1)
% 
% %Obièan IIR
% [b1,a1] = butter(4,[Wn(12)/Fn Wn(13)/Fn],'bandpass');  % Butterworth filter
% %   [sos] = zp2sos(z,p,k);          % Convert to SOS form
% %   A(1:4,1:6)= round(sos.*(2^15-1)); 
% 
% %SOS
% [z,p,k] = butter(4,[Wn(12)/Fn Wn(13)/Fn],'bandpass');  % Butterworth filter
% [sos] = zp2sos(z,p,k);          % Convert to SOS form
% 
% figure;
% freqz(b1,a1);
% figure;
% freqz(sos)
% 
% 
% figure;
% freqz(sos);
% sos1 = round(sos.*((2^15)-1));
% figure;
% freqz(sos1)
% 
fs = 44100;
f =[0:1/fs:fs/2-1/fs]
fc = 8024;
[fs1,fs2,n1,n2] = filterDesign(fc,1,60);
fp1 = fc/(2^(1/6)); 
fp2 = fc*(2^(1/6)); 
[b1] = firpm(n1-1,[0 fs1 fp1 fp2 fs2 22050]/22050,[0 0 1 1 0 0],[100 1 100]); 

% figure;
% freqz(b1,1)

fc = 10000;
[fs1,fs2,n1,n2] = filterDesign(fc,1,60);
fp1 = fc/(2^(1/6)); 
fp2 = fc*(2^(1/6)); 
[b2] = firpm(n1-1,[0 fs1 fp1 fp2 fs2 22050]/22050,[0 0 1 1 0 0],[100 1 100]); 

% figure;
% freqz(b2,1)

fc = 12500;
[fs1,fs2,n1,n2] = filterDesign(fc,1,60);
fp1 = fc/(2^(1/6)); 
fp2 = fc*(2^(1/6)); 
[b3] = firpm(n1-1,[0 fs1 fp1 fp2 fs2 22050]/22050,[0 0 1 1 0 0],[100 1 100]); 

% figure;
% freqz(b3,1)


