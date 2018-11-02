function P_octave = octaveplot(signal,Fs,Fstart,type,par)
% octaveplot(signal,Fs,type,par)
% author��syx
% used to calculate third-octave spectral of sound signal
% input:
% ---signal: �����ź�
% ---Fs�� ������
% ---Fstart�� ��۲���СƵ��
% ---type: 0:���ڼ��㷢���źŵ�ƽ�����ʣ���λΪdBFS 
%          1:���ڼ�����ѹ ��Ҫ֪��ÿһ��Ƶ��RMSֵ����ѹ�Ķ�Ӧ��ϵ��У׼������λΪdBPa
%          2:���ڼ��������� ��Ҫ֪����ѹ���źŷ��ȵĶ�Ӧ��ϵ����λΪV/Pa
% ---par:  type0: empty;
%          type1: para{1} = У׼����ÿһ��Ƶ�������̶�Ӧ����ѹֵ(Pa)
%          type2: para{1} = A/D�����̷���(V); para{2} = ��ѹ(Pa)
% pl: presicionLevel,��;��ȵȼ������0Ϊ�����ȵȼ�ÿ���1����ÿ������ڵĲ�����������һ��
f1 = @(i)(mod((i)-1,3)+3).*2.^(floor(((i)+2)/3)-1); % ��i��third octave�ĳ��ȣ��õ�����ʾ��[3,4,5,6,8,10,12,16,20,...]��
f2 = @(i,pl)(arrayfun(@(n)(sum(f1(1:n-1))+12),i)*2^pl); % ��i��third octaveƵ��λ�ڵڼ���fftƵ��λ����

% 1.�������ֻ�ܸı�۲�����Ƶ�ʣ����ܸı�Ƶ�׼���Լ���һ����Ƶ��
% 2.����ʱ��ֻ�ܸı�Ƶ�׼�����������������ͣ���һ����Ƶ�ʵ�λ��
% 3.���Ӿ��ȵȼ�������߼����׼ȷ�ȣ�����ʹ��һ����Ƶ�ʰ�ָ�������
% 4.�������ַ���Ҫ���ʹ�ã��Ӷ����ػ�������1/3����Ƶ��

signal = signal(:);

%% ���� �����ʣ�������������С�۲�Ƶ�� ����� ������ʼƵ�ʣ�FFT���������ȵȼ�
[First_Octave_Fre,N,pl] = Calculate1(Fs,length(signal),Fstart);
% N = 77822;
deltaF = First_Octave_Fre/12/2^pl; % Ƶ�ʼ��
%% ��ǰ����֧�ֵ�third octave����
index = 0;
while f2(index+2,pl)<=ceil((N+1)/2)
    index = index+1;
end

%% ���ÿһ��Ƶ�ʵ���Թ��ʣ����ԣ����0dBPa��

if type == 0 % ���ڼ��㷢���źŵ�ƽ������ % ���յ�λΪdBFS
    Fx = fft(signal(1:N));
    Px = abs(Fx/N).^2; % Px��ÿһ����Ƶ�źŵ�ƽ������(���ԣ��޵�λ)
elseif type == 1 % ���ڼ�����ѹ ��Ҫ֪��ÿһ��Ƶ��RMSֵ����ѹ�Ķ�Ӧ��ϵ��У׼�� % ���յ�λΪdBPa
    par{1} = par{1}(:);
    Fx = fft(signal(1:N)./par{1}(1:N)/par{2}*10^(par{3}/20));
    Px = abs(Fx/N).^2; % Px��ÿһ����Ƶ�źŵ�ƽ����ѹ��ƽ����ƽ�����ʣ�
elseif  type == 2 % ���ڼ��������� ��Ҫ֪����ѹ���źŷ��ȵĶ�Ӧ��ϵ % ���յ�λΪV/Pa
    VoltFscale = par{1}; % V
    Fx = fft(signal(1:N)*VoltFscale);
%     soundPressure = 10^((par{2}-94)/20); % Pa
    P_soundPressure = par{2};
    Px = (abs(Fx/N)).^2; % ÿһ����Ƶ�źŵ�ƽ�����ʣ���ÿ��octave�ڵ����е�Ƶ�źŵ��������ٿ������Ǹ�octave���źŵ�ƽ����ѹ
    
%     soundPressure = 10^((par{2}-94)/20); % Pa
%     Px = (abs(Fx/N)*VoltFscale/soundPressure).^2;
end
%% ��˫�߹�����ת��Ϊ���߹�����
LL = ceil(size(Px,1)/2)-1;
if mod(size(Px,1),2) == 1
    Px = [Px(1,:);(Px(2:1+LL,:) + Px(end:-1:end-LL+1,:))];
else
    Px = [Px(1,:);(Px(2:1+LL,:) + Px(end:-1:end-LL+1,:));Px(LL+1,:)];
end
% ��ѹ���ź�RMSֵ�����ȣ������ȣ���ѹ���һ�����źŷ������һ�����������6dB��Ҳ����dBPa���6dB��
% �ź�RMSֵ����ÿһ��Ƶ�ʷ�����RMSֵ��ƽ�����ٿ��ţ�������ͨ��ÿһ��Ƶ�ʷ�������Чֵ�������źŵ�RMSֵ
% ��ͬƵ�ʷ�������ѹ����Чֵ���ܵ�������Ƶ�����ߵĲ���Ӱ�죬��˿��Ը����������У׼���ߵõ�����ο��㴦�ĸ�����Ƶ�ʷ�����RMSֵ
%% ����OctaveƵ��ֵ
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
% ���ݲ����ʣ�������������С�۲�Ƶ�ʼ����������ʼƵ�ʣ�FFT�����;��ȵȼ�
f1 = @(i)(mod((i)-1,3)+3).*2.^(floor(((i)+2)/3)-1); % ��i��third octave�ĳ��ȣ��õ�����ʾ��[3,4,5,6,8,10,12,16,20,...]*2^pl��
f2 = @(i,pl)(arrayfun(@(n)(sum(f1(1:n-1))+12),i)*2^pl); % ��i��third octaveƵ��λ�ڵڼ���fftƵ��λ����

% Fstart = 200*2^(2/3)+10;
Fstart = round(Fstart);
FreBase = 25*2^ceil(log2(Fstart/25));
nn = abs(ceil(log2(Fstart/FreBase)*3)-2);
First_Octave_Fre = FreBase/(f2(nn,0))*12;
presicionLevel = floor(log2(N*First_Octave_Fre/Fs/12));
Nfft = Fs/First_Octave_Fre*12*2^presicionLevel;

