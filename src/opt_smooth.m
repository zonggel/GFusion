function x = opt_smooth(A, b, lambda)
ndim = size(A,2);
B = zeros(ndim-1,ndim); 
for i = 1:(ndim-1)
    B(i,i) = -1;
    B(i,i+1) = 1;
end
B = sparse(B);
A = sparse(A);


H = sparse(B'*B);
Ml = A'*A+ lambda*H;
Mr = A'*b;

x = Ml\Mr;
end