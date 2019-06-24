Fc = 200;
N = 3;
Fs = 44100;
f1 = Fc/(2^(1/6)); 
f2 = Fc*(2^(1/6)); 
Qr = Fc/(f2-f1); 
Qd = (pi/2/N)/(sin(pi/2/N))*Qr;
alpha = (1 + sqrt(1+4*Qd^2))/2/Qd; 
W1 = Fc/(Fs/2)/alpha; 
W2 = Fc/(Fs/2)*alpha;
[B,A] = butter(N,[W1,W2]); 
freqz(B,A)

Fs = 44100; % Sampling Frequency
N = 3; % Order of analysis filters.
F = [ 100 125 160, 200 250 315, 400 500 630, 800 1000 1250, ...
20 1600 2000 2500, 3150 4000 5000 ]; % Preferred labeling freq.
ff = (1000).*((2^(1/3)).^[-10:7]); % Exact center freq.

