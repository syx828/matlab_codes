function J = josephus(q,N)
% calculate josephus number with N people and eliminate a person each q
% people
if N<q
    J = 1:N;
else
    J = 0:q-2;
    for n = q+1:N 
        J = mod(J+q,n);
    end
    J = sort(J,'ascend')+1;
end