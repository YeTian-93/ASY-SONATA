function f = F(U, v, x, M)
global r
R = r * M;
total = size(U,1);
f = 0;
for m = 1:total
    f = f + log(1 + exp(-v(m)*U(m,:)*x));
end
f = f + R * norm(x)^2;
end
