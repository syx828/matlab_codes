% this code tested BLMS Adaptive Filter
clear;
rng('default');
L = 64;                    % block length
M = 64;
Nblock = 100;
La = M-1+L*Nblock;                   %input data length
fs = 8000;
signal = sin(2*pi*500*(0:La-1)/fs);      %data to be filtered
% signal = [zeros(N-1,1);signal(:);zeros(L,1)]; %前面补滤波器长-1，后面补块长，不过感觉后面的输出毫无意义
% signal = [zeros(N-1,1);signal(:)]; % 前面补滤波器长
% 前面不需要补任何长度，只需要从第M个点开始输出即可，第一个Block从第M个点开始
miu = [0.0001,0.0002,0.0005,0.001,0.002,0.005,0.01,0.015,0.05,0.1];
figure(1);clf(1);
for i = 1:length(miu)
    w = 0.5*ones(M,1);
    Y = zeros(L,Nblock);
    for n = 1:Nblock
    %     x = signal((n-1)*L+1:n*L+N-1);
        Xc = signal((n-1)*L+M:n*L+M-1);
        Xr = signal((n-1)*L+M:-1:(n-1)*L+1);
        X = toeplitz(Xc,Xr);
    %     x = signal(k-1+(1:M));
        Y(:,n) = X*w;
        if 1 % 以前一个block的输出作为期望
            if n==1
                e = -Y(:,n);
            else
                e = Y(:,n-1)-Y(:,n);
            end
        else
            e = -Y(:,n);
        end
        w = w +2*miu(i)/L*X.'*e;
    end
    y = Y(:);
    ag(i) = subplot(2,5,i);plot(M:La,y);
end
linkaxes(ag,'xy');
ylim([-5,5]);