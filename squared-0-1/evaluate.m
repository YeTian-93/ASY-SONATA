function e = evaluate(X)
global Num_Nodes U v

mean_X     = mean(X,2);
cons_error = norm(X - mean_X * ones(1,Num_Nodes), 'fro')^2;

U_stack    = cat(1,U{:});
v_stack    = cat(1,v{:});
opt_gap    = norm(grad(U_stack, v_stack, mean_X));

e          = max(cons_error, opt_gap);