function P_octave = octaveplot(signal,Fs,Fstart,type,par)
% octaveplot(signal,Fs,type,par)
% author：syx
% used to calculate third-octave spectral of sound signal
% input:
% ---signal: 测试信号
% ---Fs： 采样率
% ---Fstart： 需观测最小频率
% ---type: 0:用于计算发送信号的平均功率，单位为dBFS 
%          1:用于计算声压 需要知道每一个频率RMS值与声压的对应关系（校准表），单位为dBPa
%          2:用于计算灵敏度 需要知道电压与信号幅度的对应关系，单位为V/Pa
% ---par:  type0: empty;
%          type1: para{1} = 校准表，即每一个频点满量程对应的声压值(Pa)
%          type2: para{1} = A/D满量程幅度(V); para{2} = 声压(Pa)
% pl: presicionLevel,最低精度等级。最低0为。精度等级每提高1，在每个间隔内的采样点数增加一倍
f1 = @(i)(mod((i)-1,3)+3).*2.^(floor(((i)+2)/3)-1); % 第i个third octave的长度（用点来表示，[3,4,5,6,8,10,12,16,20,...]）
f2 = @(i,pl)(arrayfun(@(n)(sum(f1(1:n-1))+12),i)*2^pl); % 第i个third octave频率位于第几个fft频率位置上

% 1.变采样率只能改变观察的最大频率，不能改变频谱间隔以及第一音程频率
% 2.增加时长只能改变频谱间隔，进而修正（降低）第一音程频率的位置
% 3.增加精度等级可以提高计算的准确度，但会使第一音程频率按指数率提高
% 4.以上两种方法要结合使用，从而灵活地画出各种1/3音程频谱

signal = signal(:);

%% 根据 采样率，样本点数，最小观察频率 计算出 音程起始频率，FFT点数，精度等级
[First_Octave_Fre,N,pl] = Calculate1(Fs,length(signal),Fstart);
% N = 77822;
deltaF = First_Octave_Fre/12/2^pl; % 频率间隔
%% 当前点数支持的third octave个数
index = 0;
while f2(index+2,pl)<=ceil((N+1)/2)
    index = index+1;
end

%% 求出每一个频率的相对功率（线性，相对0dBPa）

if type == 0 % 用于计算发送信号的平均功率 % 最终单位为dBFS
    Fx = fft(signal(1:N));
    Px = abs(Fx/N).^2; % Px是每一个单频信号的平均功率(线性，无单位)
elseif type == 1 % 用于计算声压 需要知道每一个频率RMS值与声压的对应关系（校准表） % 最终单位为dBPa
    par{1} = par{1}(:);
    Fx = fft(signal(1:N)./par{1}(1:N)/par{2}*10^(par{3}/20));
    Px = abs(Fx/N).^2; % Px是每一个单频信号的平均声压的平方（平均功率）
elseif  type == 2 % 用于计算灵敏度 需要知道电压与信号幅度的对应关系 % 最终单位为V/Pa
    VoltFscale = par{1}; % V
    Fx = fft(signal(1:N)*VoltFscale);
%     soundPressure = 10^((par{2}-94)/20); % Pa
    P_soundPressure = par{2};
    Px = (abs(Fx/N)).^2; % 每一个单频信号的平均功率，把每个octave内的所有单频信号叠加起来再开方就是该octave内信号的平均电压
    
%     soundPressure = 10^((par{2}-94)/20); % Pa
%     Px = (abs(Fx/N)*VoltFscale/soundPressure).^2;
end
%% 从双边功率谱转变为单边功率谱
LL = ceil(size(Px,1)/2)-1;
if mod(size(Px,1),2) == 1
    Px = [Px(1,:);(Px(2:1+LL,:) + Px(end:-1:end-LL+1,:))];
else
    Px = [Px(1,:);(Px(2:1+LL,:) + Px(end:-1:end-LL+1,:));Px(LL+1,:)];
end
% 声压与信号RMS值（幅度）成正比，声压提高一倍，信号幅度提高一倍，功率提高6dB，也就是dBPa提高6dB。
% 信号RMS值等于每一个频率分量的RMS值的平方和再开放，即可以通过每一个频率分量的有效值来计算信号的RMS值
% 不同频率分量的声压（有效值）受到语音嘴频响曲线的差异影响，因此可以根据语音嘴的校准曲线得到在嘴参考点处的各声波频率分量的RMS值
%% 计算Octave频谱值
fre = [];
for i = 1:index+1
    if i <= index
        P_octave(i) = 10*log10(abs(sum(Px(f2(i,pl):f2(i+1,pl)-1))));
    else
        P_octave(i) = 10*log10(abs(sum(Px(f2(i,pl):end))));
    end
    fre = [fre,f2(i,pl)*deltaF];
end
fre = [fre,f2(i+1,pl)*deltaF];
switch type
    case 0,
    case 1,
    case 2,
        P_voltage = P_octave;
        P_octave = P_voltage-P_soundPressure(1:length(P_voltage));
end
x = [fre(1:end-1);fre(2:end)];
x = x(:);
y = repmat(P_octave,[2,1]);
y = y(:);
semilogx(x,y);grid on;xlim([fre(1),fre(end)]);
xlabel('Hz');
switch type
    case 0,ylabel('dB');
    case 1,ylabel('dBPa');
    case 2,ylabel('dB rel 1V/Pa');ylim([-60,0]+max(P_octave)+2);
end

function [First_Octave_Fre, Nfft, presicionLevel] = Calculate1(Fs,N,Fstart)
% 根据采样率，样本点数，最小观察频率计算出音程起始频率，FFT点数和精度等级
f1 = @(i)(mod((i)-1,3)+3).*2.^(floor(((i)+2)/3)-1); % 第i个third octave的长度（用点来表示，[3,4,5,6,8,10,12,16,20,...]*2^pl）
f2 = @(i,pl)(arrayfun(@(n)(sum(f1(1:n-1))+12),i)*2^pl); % 第i个third octave频率位于第几个fft频率位置上

% Fstart = 200*2^(2/3)+10;
Fstart = round(Fstart);
FreBase = 25*2^ceil(log2(Fstart/25));
nn = abs(ceil(log2(Fstart/FreBase)*3)-2);
First_Octave_Fre = FreBase/(f2(nn,0))*12;
presicionLevel = floor(log2(N*First_Octave_Fre/Fs/12));
Nfft = Fs/First_Octave_Fre*12*2^presicionLevel;

