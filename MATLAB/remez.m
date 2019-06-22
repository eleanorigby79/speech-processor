fs = 24000;
fn = fs/2;
fc = zeros(1,43);
rp=1;
rs=60;
f = [0:1:fs/2-1];
for i=22:39
    fc(i) = 2^((i-30)/3)*1000;
    dev = [10^(-rs/20) (10^(rp/20)-1)/(10^(rp/20)+1) (10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)]; 
    f1 = fc(i)/(2^(1/6));
    f_1 = 0.184*fc(i);
    f2 = fc(i)*(2^(1/6));
    f_2 = 5.5434*fc(i);
    [n,fo,ao,w] = firpmord([0 f_1/fn f1/fn f2/fn f_2/fn 1],[0 1 1 0],dev,fs);
    b = firpm(n,fo,ao,w); 
    H = freqz(b,1,fn);
    plot(f,20*log10(abs(H)));
    hold on;
end

