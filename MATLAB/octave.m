Fs = 48000;
BW = '1/3 octave';
N = 8;
F0 = getANSICenterFrequencies(oneThirdOctaveFilter);
F0(F0<20) = [];
F0(F0>20e3) = [];
Nfc = length(F0);
for i=1:Nfc
    oneThirdOctaveFilterBank{i} = octaveFilter('FilterOrder', N, ...
        'CenterFrequency', F0(i), 'Bandwidth', BW, 'SampleRate', Fs); %#ok
    visualize(oneThirdOctaveFilterBank{i}, 'class 1');
end