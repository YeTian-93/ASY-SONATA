function f = F(U, v, x)
global lambda

total = size(U,1);
R     = lambda * total;
f     = 0;
for m = 1:total
    linear_fit = v(m) * U(m,:) * x;
    if linear_fit < -1
        f = f + 1;
    elseif linear_fit < 1
        f = f + 0.25 * linear_fit^3 - 0.75 * linear_fit + 0.5;
    end
end

f = f + R * norm(x(1:end-1))^2;
end