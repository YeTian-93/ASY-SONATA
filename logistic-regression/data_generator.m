function data_generator(Num_Nodes, step_size, N)
rng(06292019,'v4');
global row col

U = cell(1, Num_Nodes);
v = cell(1, Num_Nodes);

ground_truth = normrnd(0, 1, [col, 1]);
for i = 1:Num_Nodes
    U_temp = zeros(row, col);
    v_temp = zeros(row, 1);
    for m = 1:row
        U_temp(m,:) = normrnd(0, 1, [1, col]);
        temp   = rand;
        p      = 1/(1 + exp(-U_temp(m,:) * ground_truth));
        if temp <= p
            v_temp(m) = 1;
        else
            v_temp(m) = -1;
        end
    end
    U{i} = U_temp;  v{i} = v_temp;
end

%%%%% reshape data %%%%%
U_stack  = cat(1, U{:});
v_stack  = cat(1, v{:});

%%%%% minimizing by gradient descent %%%%%
x        = zeros(col, 1);
gradnorm = zeros(N,1);
F_value  = zeros(N,1);
F_desc   = zeros(N-1,1);

for k = 1:N
    g           = grad(U_stack, v_stack, x);
    x           = x - step_size * g;
    gradnorm(k) = norm(g);
    F_value(k)  = F(U_stack, v_stack, x);
    if k > 1
        F_desc(k-1) = abs(F_value(k-1) - F_value(k));
    end
end

F_opt = F_value(N);
X_opt = x;

%%%%% plot %%%%%
figure;

subplot(1,3,1);
semilogy(1:N, gradnorm);
xlabel('Iteration')
ylabel('Gradient Norm')

subplot(1,3,2);
semilogy(1:N, F_value);
xlabel('Iteration')
ylabel('F value')

subplot(1,3,3);
semilogy(1:N-1, F_desc);
xlabel('Iteration')
ylabel('descent per step of F value')

save('data.mat', 'U', 'v', 'F_opt', 'X_opt')
fprintf('Data is generated\n');
end
