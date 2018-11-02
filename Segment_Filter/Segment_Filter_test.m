% Overlap-save Algorithm & Overlap-add Algorithm
% 1.The basis of the two algorithm is: A M point filter will make the first
% M-1 point and last M-1 point of the filtered signal unreliable. So filter
% a L point signal with a M point filter can only get a L-M+1 signal with
% reliable points.
% 2.In overlap-save algorithm, we need L+M-1 points in each step. Because 
% we have to save M-1 point for the next segment.(Or we should say, we need
% to output L reliable points each time.)
% 3.In overlap-add algorithm, we only need L point in each step. Thought we
% can only get L-M+1 reliable points in each step, we could recovery M-1
% points each time.
% 3.����FIR������λ�˲���ʱ����������ż���ף������㣩���˲���������Ⱥʱ��������������
% 4.��ʱ���˲���ʱ��������ǰ����󣩶����Ĳ��ɿ�������һ�롣Ⱥʱ��һ��Ȳ��ɿ�������һ�뻹С��
% 4.���ֱ�ʾ���Ƕ���Ⱥʱ���Ѿ�֪����������λFIR�˲��������Ƕ���ʵ���������ķ�������λ�˲�������Ƶ���˲�����ʱ�Ӳ���ȷ������˻��ǰ�ȫ��������Ϊ�á�
rng('default');
L = 200;                    %output segment length
La = 1000;                   %input data length
fs = 8000;
signal = sin(2*pi*500*(0:La-1)/fs);      %data to be filtered
noise = 0.1*sin(2*pi*1050*(0:La-1)/fs)+0.1*sin(2*pi*3000*(0:La-1)/fs);      %data to be filtered
h = [-0.0025    0.0193    0.0094    0.0018   -0.0108   -0.0248   -0.0330,...
     -0.0274   -0.0029    0.0402    0.0948    0.1488    0.1885    0.2030,...
     0.1885    0.1488    0.0948    0.0402   -0.0029   -0.0274   -0.0330,...
     -0.0248   -0.0108    0.0018    0.0094    0.0193   -0.0025]; % ż�Գ�������������λFIR�˲���
M = length(h);
GroupDelay_in_point = (M-1)/2;
GroupDelay_in_second = GroupDelay_in_point/fs;
figure(1);clf(1);
spectrplot(h,fs,'linearphase');
signal(100:300) = signal(100:300)+randn(1,201)*0.2;
% a = signal+noise;
a = signal;
figure(2);clf(2);
axesGroup(1) = subplot(3,1,1);plot((0:length(a)-1)/fs,a);
xlabel('time(s)');ylabel('A');title('Input')
Output = overlap_add(a,h,L);
axesGroup(2) = subplot(3,1,2);plot((0:length(Output)-1)/fs,Output);
xlabel('time(s)');ylabel('A');title('overlap add')
Output = overlap_save(a,h,L);
axesGroup(3) = subplot(3,1,3);plot((0:length(Output)-1)/fs,Output);
xlabel('time(s)');ylabel('A');title('overlap save')
linkaxes(axesGroup,'xy');
xlim([0,(length(Output)-1)/fs]);