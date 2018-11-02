% this code tested LMS Adaptive Filter
% LMS����Ӧ�˲���һ���ƶ�һ���㣬ÿ�ƶ�һ�������һ���˲���ϵ��
% ���ڵ������Ѿ�����������˲����ĸ����ǲ��ɿ��ģ����Բ��ٸ����˲�����Ҳ������������ֻ���˲���ǰ�油�㣬�����ں󷽲�0
% ��ʵ�ϣ���ʵ��ʼ�˲����ĸ���Ҳ�ǲ��ɿ��ģ����Դ�Ӧ�õ�M���㿪ʼ�������La����֮��ֹͣ���
% ���Կ��Գ���һ�´ӵ�M�����ݲſ�ʼ�����˲�����������ǰ��M-1���㣩����һ���˲����������ٶ����
% ���֤���ˣ��ӵ�M�������ٿ�ʼ�����˲��������ٶȸ��죬Ч��Ҳ���á�
% ���ԣ����ݲ���Ҫ���㡣
rng('default');
M = 128;                    %output segment length
La = 5000;                   %input data length
fs = 8000;
signal = sin(2*pi*500*(0:La-1)/fs).';      %data to be filtered
miu = [0.0001,0.0002,0.0005,0.001,0.002];
% miu = [0.005,0.01,0.015,0.05,0.1];
figure(1);clf(1);
%% �ӵ�M�����ݲſ�ʼ�����˲������ӵ�M�����ݲſ�ʼ�����
for i = 1:length(miu)
%     y = zeros(La+M-1,1); %������һֱ�������˲�����ȫ�Ƴ����ݵķ�Χ
    y = zeros(La-M+1,1); 
    w = ones(M,1);
    for k = 1:La-M+1
        x = signal(k-1+(1:M));
        y(k) = w.'*x;
        if 1 % ��ǰһ����������Ϊ����
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
%% �ӵ�1�����ݾͿ�ʼ�����˲������ӵ�M�����ݲſ�ʼ�����
signal = [zeros(M-1,1);signal(:)];
for i = 1:length(miu)
%     y = zeros(La+M-1,1); %������һֱ�������˲�����ȫ�Ƴ����ݵķ�Χ
    y = zeros(La,1); 
    w = ones(M,1);
    for k = 1:La
        x = signal(k-1+(1:M));
        y(k) = w.'*x;
        if 1 % ��ǰһ����������Ϊ����
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