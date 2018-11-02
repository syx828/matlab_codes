function output = overlap_add(input,f,L)
La = length(input);
M = length(f);
Nseg = ceil(La/L);                    %segment to be computed
output = zeros(1,La+M-1); 
Z = zeros(1,M-1);
for seg = 1:Nseg
    Xa = (seg-1)*L + (1:L); % indices of segment to be filtered
    Xa(Xa>La) = [];
    aa = [input(Xa),zeros(1,L-length(Xa))];
    b = conv(aa,f);
%     b2 = conv(f,aa);
    % ���ʹ�õ���fir�˲����Ļ���filter����ʵ���Ͼ���ʵ����Overlap-add��
    % ��ʵ���ǰ�Z����ǰ��M-1���źŵ��ӣ�Ȼ���ٰѾ��֮��ʣ�µ�Ԫ�طŵ�Z��
    [b,Z] = filter(f,1,aa,Z); 
    if seg == 1
        output(1:L) = b(1:L);
    elseif seg == Nseg
        b(1:M-1) = b(1:M-1)+Z;
        output((seg-1)*L+1:end) = b;
    else
        b(1:M-1) = b(1:M-1)+Z;
        output((seg-1)*L + (1:L)) = b(1:L);
    end
    Z = b(end-M+2:end);
end