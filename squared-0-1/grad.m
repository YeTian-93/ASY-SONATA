function g = grad(U, v, x)
global lambda col

total = size(U,1);
R     = lambda * total;
g     = zeros(col,1);
for m = 1:total
    linear_fit = v(m) * U(m,:) * x;
    if linear_fit > -1 && linear_fit < 1
        g = g + 0.75 * (linear_fit^2 - 1) * v(m) * U(m,:)';
    end
end

g(1:end-1) = g(1:end-1) + 2 * R * x(1:end-1);

end