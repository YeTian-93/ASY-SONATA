function Err = ASYSONATA(C, R, step, eps, isWithAux)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code describes our algorithm--ASYSONATA in [1].
%
% C:          column stochastic weight matrix;
% R:          row stochastic weight matrix;
% step:       step size gamma;
% eps:        parameter for designing dimishing step size; set to 0 for
%             constant step size;
% isWithAux:  logical value--true if the auxiliary variable phi is invoked
%             and false otherwise
% --------reference-------
% [1] Tian, Ye, Ying Sun, and Gesualdo Scutari. "Achieving Linear 
%     Convergence in Distributed Asynchronous Multi-agent Optimization." 
%     arXiv preprint arXiv:1803.10359 (2018).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global U v col MaxTravelTime Niter act_list X0 Num_Nodes Adj

Err    = zeros(1,Niter+1); % to record the optimality gap at each iteration
Err(1) = evaluate(X0);

%%%% Initialization %%%%
gamma      = step*ones(Num_Nodes,1);    % step size gamma

X          = X0;               % X stacks all local variables in columns
V(:,:,1)   = zeros(col,Num_Nodes);  % initial v variables
Z          = zeros(col,Num_Nodes);
for i=1:Num_Nodes
    Z(:,i) = grad(U{i}, v{i}, X(:,i));
end
rho(:,:,1) = zeros(col,Num_Nodes); % running sum of Z
rho_buff   = zeros(col,Num_Nodes,Num_Nodes);  % rho_tilde in the pseudocode
if isWithAux
    phi        = ones(Num_Nodes, 1);
    sigma(:,1) = zeros(Num_Nodes,1);   % running sum of phi
    sigma_buff = zeros(Num_Nodes,Num_Nodes);    % sigma_tilde in the pseudocode
end

Lic             = ones(Num_Nodes,1);   % local iteration counter for each agent i
% T_arrive(j,i,t) record the global iteration after which the packet, sent
% from agent i and associated with i's local iteration t, becomes available 
% to j
T_arrive(:,:,1) = zeros(Num_Nodes,Num_Nodes);

for k = 1:Niter
    
    i_k = act_list(k);
    %%%% the agent waking up at iteration k %%%%
    Lic(i_k) = Lic(i_k) + 1;
    gamma(i_k) = gamma(i_k) * (1-eps*gamma(i_k));
    
    %%%% Local Descent %%%%
    if isWithAux
        V(:,i_k,Lic(i_k)) = X(:,i_k) - gamma(i_k) * Z(:,i_k) / phi(i_k);
    else
        V(:,i_k,Lic(i_k)) = X(:,i_k) - gamma(i_k) * Z(:,i_k);
    end
    
    %%%% Consensus and gradient tracking %%%%
    new_X = R(i_k,i_k)*V(:,i_k,Lic(i_k));
    
    for j = 1:Num_Nodes
        if Adj(i_k,j) ~= 0
            
            time_list   = T_arrive(i_k,j,1:Lic(j));
            list_arrive = find(time_list<=k & time_list>0);
            if ~isempty(list_arrive)
                
                t = list_arrive(end);
                new_X = new_X + R(i_k,j)*V(:,j,t);
                
                %%%% Sum %%%%
                Z(:,i_k) = Z(:,i_k) +  C(i_k,j)*(rho(:,j,t) - rho_buff(:,i_k,j));
                %%%% Mass-Buffer Update %%%%
                rho_buff(:,i_k,j) = rho(:,j,t);
                
                if isWithAux
                    phi(i_k) = phi(i_k) + C(i_k,j)*(sigma(j,t) - sigma_buff(i_k,j));
                    sigma_buff(i_k,j) = sigma(j,t);
                end
            end
        end
        
        if Adj(j,i_k) ~= 0
            
            T_arrive(j,i_k,Lic(i_k)) = randi([1,MaxTravelTime]) + k;
        end
    end
    Z(:,i_k) = Z(:,i_k) + grad(U{i_k}, v{i_k}, new_X) -...
        grad(U{i_k}, v{i_k}, X(:,i_k));
    
    X(:,i_k) = new_X;
    
    %%%% Push %%%%
    rho(:,i_k,Lic(i_k)) = rho(:,i_k,Lic(i_k)-1) + Z(:,i_k);
    Z(:,i_k) = C(i_k,i_k) * Z(:,i_k);
    
    if isWithAux
        sigma(i_k,Lic(i_k)) = sigma(i_k,Lic(i_k)-1) + phi(i_k);
        phi(i_k) = C(i_k,i_k) * phi(i_k);
    end
    
    %%%% Optimality Gap %%%%
    Err(k+1) = evaluate(X);
    
    if mod(k, 1000) == 0
        if eps == 0
            fprintf('ASYSONATA: %d-th iteration, the error is %f\n', k, Err(k+1));
        else
            fprintf('ASYSONATA-dimi: %d-th iteration, the error is %f\n', k, Err(k+1));
        end
    end
    
end
end
