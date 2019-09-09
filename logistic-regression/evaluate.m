function e = evaluate(X)
global X_opt Num_Nodes

e = norm(X - X_opt * ones(1, Num_Nodes), 'fro');