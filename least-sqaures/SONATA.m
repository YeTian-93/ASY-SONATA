function Err = SONATA(C, R, step)

global A b X_opt X0 Niter Num_Nodes col

rounds = floor(Niter/Num_Nodes);
Err    = zeros(1, rounds+1); % to record the optimality gap at each round
Err(1) = norm(X0 - X_opt * ones(1, Num_Nodes), 'fro')/Num_Nodes;

%%%% Initialization %%%%
X   = X0;
Z   = zeros(col,Num_Nodes);
for i=1:Num_Nodes    
    Z(:,i) = 2*A{i}'*(A{i}*X(:,i)-b{i});  
end

for k = 1:rounds
    %%%% SONATA update %%%%
    new_X   = (X - step * Z) * R';
    Z       = Z * C';
    for i = 1:Num_Nodes    
        Z(:,i) = Z(:,i) + 2*A{i}'*A{i} * (new_X(:,i)-X(:,i));          
    end    
    X       = new_X;
    
    Err(k+1) = norm(X - X_opt * ones(1, Num_Nodes), 'fro')/Num_Nodes;    
    if mod(k, 100) == 0
        fprintf('SONATA: %d-th round, the error is %f\n', k, Err(k+1));
    end
    
end