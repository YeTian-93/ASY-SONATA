function test(T,step)
global lambda col U v

load('data.mat');

col = 14;
lambda = 1;
X   = zeros(col,1);
U_stack = cat(1,U{:});
% U_stack = U_stack(:,1:end-1);
v_stack = cat(1,v{:});
% U_stack = U_stack(1:2,:);
% v_stack = v_stack(1:2,:);
err = zeros(T,1);
fun = zeros(T,1);
F_desc   = zeros(T-1,1);
for k =1:T
    X = X - step*grad(U_stack, v_stack,X);
    err(k) = norm(grad(U_stack, v_stack, X));
    fun(k) = F(U_stack, v_stack, X);
    if k > 1
        F_desc(k-1) = abs(fun(k) - fun(k-1));
    end
    
    if mod(k,1000) == 0
        disp(err(k))
    end
     
end

figure;
subplot(1,3,1);
semilogy(1:T,err)
ylabel('grad norm')

subplot(1,3,2);
semilogy(1:T,fun)
ylabel('function value')

subplot(1,3,3);
semilogy(1:T-1,F_desc)
ylabel('desc value')
