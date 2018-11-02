% this code tested LMS Adaptive Filter
% LMS自适应滤波器一次移动一个点，每移动一个点更新一次滤波器系数
% 由于当数据已经输出结束后，滤波器的更新是不可靠的，所以不再更新滤波器，也不再输出。因此只在滤波器前面补零，而不在后方补0
% 事实上，其实开始滤波器的更新也是不可靠的，所以从应该第M个点开始输出，第La个点之后停止输出
% 所以可以尝试一下从第M个数据才开始更新滤波器（即舍弃前面M-1个点），看一看滤波器的收敛速度如何
% 结果证明了，从第M个数据再开始更新滤波器收敛速度更快，效果也更好。
% 所以，数据不需要补零。
rng('default');
M = 128;                    %output segment length
La = 5000;                   %input data length
fs = 8000;
signal = sin(2*pi*500*(0:La-1)/fs).';      %data to be filtered
miu = [0.0001,0.0002,0.0005,0.001,0.002];
% miu = [0.005,0.01,0.015,0.05,0.1];
figure(1);clf(1);
%% 从第M个数据才开始更新滤波器（从第M个数据才开始输出）
for i = 1:length(miu)
%     y = zeros(La+M-1,1); %本来想一直滑动到滤波器完全移出数据的范围
    y = zeros(La-M+1,1); 
    w = ones(M,1);
    for k = 1:La-M+1
        x = signal(k-1+(1:M));
        y(k) = w.'*x;
        if 1 % 以前一个点的输出作为期望
            if k==1
                e(k) = -y(k);
            else
                e(k) = y(k-1)-y(k);
            end
        else
            e(k) = -y(k);
        end
        w = w +2*miu(i)*e(k)*x;
    end
%     ag(i) = subplot(2,5,i);plot(1:M-1,y(1:M-1),'r');hold on;plot(M:La,y(M:end-M+1));plot(La+1:La+M-1,y(end-M+2:end),'r');
    ag(i) = subplot(2,5,i);plot(M:La,y);
end
%% 从第1个数据就开始更新滤波器（从第M个数据才开始输出）
signal = [zeros(M-1,1);signal(:)];
for i = 1:length(miu)
%     y = zeros(La+M-1,1); %本来想一直滑动到滤波器完全移出数据的范围
    y = zeros(La,1); 
    w = ones(M,1);
    for k = 1:La
        x = signal(k-1+(1:M));
        y(k) = w.'*x;
        if 1 % 以前一个点的输出作为期望
            if k==1
                e(k) = -y(k);
            else
                e(k) = y(k-1)-y(k);
            end
        else
            e(k) = -y(k);
        end
        w = w +2*miu(i)*e(k)*x;
    end
%     ag(i) = subplot(2,5,i);plot(1:M-1,y(1:M-1),'r');hold on;plot(M:La,y(M:end-M+1));plot(La+1:La+M-1,y(end-M+2:end),'r');
    ag(i+5) = subplot(2,5,i+5);plot(M:La,y(M:end));
end
linkaxes(ag,'xy');
ylim([-1,1]);