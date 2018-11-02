N = 1024;
x = randn(1,N)+1i*randn(1,N);

% 下面公式说明了时频域平均功率之间的对应关系
% fs = 44100;
[rms(x).^2 mean(abs(x).^2)] % 时域平均功率（求平方根即为有效幅度）
sum(abs(fft(x)/N).^2)  % 信号的平均功率也等于功率谱之和（等于abs(fft(x)/N).^2）的和再开方
sqrt(mean(abs(fft(x)/sqrt(N)).^2)) % 上述公式简化后，发现fft后的RMS要与fft前的RMS值相同，需要在求fft后除以sqrt(2)