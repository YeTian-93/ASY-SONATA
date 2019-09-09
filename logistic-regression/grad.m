function g = grad(U, v, x)
global r

total = size(U,1);
R     = r * total;
g     = 0;
for m = 1:total
    g = g - v(m)/(1 + exp(v(m)*U(m,:)*x)) * U(m,:)';
end
g = g + 2*R*x;
end
