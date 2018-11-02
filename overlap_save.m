function output = overlap_save(input,filter,L)
La = length(input);
M = length(filter);
Nseg = ceil(La/L);                    %segment to be computed
output = zeros(1,La+M-1); 
saved = [];
for seg = 1:Nseg
    Xa = (seg-1)*L + (1:L+M-1); %indices of segment to be filtered
    Xa(Xa>La) = [];
%     aa = [input(Xa),zeros(1,L+M-1-length(Xa))];
    b = conv(input(Xa),filter);
    relb = b(M:end-M+1);
    if seg == 1
        output((seg-1)*L + (1:L)) = b(1:L);
    elseif seg == Nseg
        output((seg-1)*L+1:end) = [saved,b(M:end)];
    else
        output((seg-1)*L + (1:L)) = [saved,relb(1:end-M+1)];
    end
    saved = relb(end-M+2:end);
end