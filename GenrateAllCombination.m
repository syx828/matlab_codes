% An alternative method of nchoosek
% nchoosek(1:20,4)
N = 20;
M = 4;
index = 1:M;
n = factorial(N)/factorial(M)/factorial(N-M);
all = zeros(n,M);
for k = 1:n
    all(k,:) = index;
%     if index(1) == N - M + 1;
%         break;
%     end
    for i = M:-1:1
        if index(i) ~= N-M+i
            index(i) = index(i)+1;
            for j = i+1:M
                index(j) = index(j-1)+1;
            end
            break;
        end
    end
end