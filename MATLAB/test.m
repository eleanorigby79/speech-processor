Microphone = dsp.AudioRecorder('SamplesPerFrame', 2048);
Speaker = dsp.AudioPlayer;
SpecAnalyzer = dsp.SpectrumAnalyzer;
tic;
while(toc<30)

audio = step(Microphone);
step(Speaker, audio);
step(SpecAnalyzer,audio);

end

release(Microphone);
release(Speaker);
release(SpecAnalyzer);