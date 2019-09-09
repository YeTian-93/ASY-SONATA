function Err = AsySPA(C, rho)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code describes our algorithm--ASYSONATA.
%
% C:          column stochastic weight matrix;
% R:          row stochastic weight matrix;
% step:       step size gamma;
% eps:        parameter for designing dimishing step size; set to 0 for
%             constant step size;
% isWithAux:  logical value--true if the auxiliary variable phi is invoked
%             and false otherwise
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global U v col MaxTravelTime Niter act_list X0 Num_Nodes Adj

Err    = zeros(1,Niter+1); % to record the optimality gap at each iteration
Err(1) = evaluate(X0);

%%%% Initialization %%%%
w          = zeros(col, Num_Nodes);  
z          = zeros(col, Num_Nodes);
x_h        = X0;                     % _h stacks all the history variables
y_h        = ones(Num_Nodes, 1);
l_h        = ones(Num_Nodes, 1);

% local iteration counter for each agent i starting from 1
Lic        = ones(Num_Nodes, 1);   
% T_arrive(j,i,t) record the global iteration after which the packet, sent
% from agent i and associated with i's local iteration t, becomes available 
% to j
T_arrive(:,:,1) = randi(MaxTravelTime, Num_Nodes);

for k = 1:Niter  
 
    i_k = act_list(k);
    %%%% the agent waking up at iteration k %%%%
    Lic(i_k) = Lic(i_k) + 1;   
      
    %%%% Consensus using a column stochastic matrix %%%%
    w(:,i_k)           = C(i_k,i_k) * x_h(:,i_k,Lic(i_k)-1);
    y_h(i_k, Lic(i_k)) = C(i_k,i_k) * y_h(i_k,Lic(i_k)-1);
    l_tilde            = l_h(i_k,Lic(i_k)-1);
    
    for j = 1:Num_Nodes
        if Adj(i_k,j) ~= 0
            
            % unused_pac contains the Lic's of agent j with which packets
            % to be used by i_k at this global iteration k are associated            
            time_list = T_arrive(i_k, j, 1:Lic(j));
            unused_pac  = find(time_list <= k & time_list > 0);
            
            [num_arrive, ~] = size(unused_pac);
            for p = 1:num_arrive
                w(:,i_k) = w(:,i_k) + C(i_k,j) * x_h(:, j, unused_pac(p));
                y_h(i_k, Lic(i_k)) = y_h(i_k, Lic(i_k)) + C(i_k,j) * ...
                    y_h(j, unused_pac(p));
                l_tilde = max(l_tilde, l_h(j,unused_pac(p)));
            end
            
            % Modify the arrive time of packets used in this global
            % iteation k to 0
            time_list(unused_pac) = 0;
            T_arrive(i_k, j, 1:Lic(j)) = time_list;
        end
            
        if Adj(j,i_k) ~= 0
            % i_k sends packets to its outneighbors.  Note that the packet 
            % being sent now is associated with Lic(i_k)-1.
            T_arrive(j,i_k,Lic(i_k)) = randi([1,MaxTravelTime]) + k;            
            
        end
    end
    
    %%%% Local Descent %%%%
    z(:,i_k) = w(:,i_k) / y_h(i_k, Lic(i_k));
    step_size = sum(rho(l_h(i_k,Lic(i_k)-1) : l_tilde));   
    
    x_h(:,i_k,Lic(i_k)) = w(:,i_k) - step_size * ...
        grad(U{i_k}, v{i_k}, z(:,i_k));    
    l_h(i_k,Lic(i_k)) = l_tilde + 1;
    
    %%%% Optimality Gap %%%%
    Err(k+1) = evaluate(z);
    
    if mod(k, 1000) == 0
        fprintf('AsySPA: %d-th iteration, the error is %f\n', k, Err(k+1));
    end
    
end
end