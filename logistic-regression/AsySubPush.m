function Err = AsySubPush(C, step)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code describes the algorithm--AsySubPush in [1].
%
% C:          column stochastic weight matrix;
% step:       step size;
% --------reference-------
% [1] Assran, Mahmoud, and Michael Rabbat. "Asynchronous subgradient-push."
%     arXiv preprint arXiv:1803.08950 (2018).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global U v col MaxTravelTime Niter act_list X0 Num_Nodes Adj

Err    = zeros(1,Niter+1); % to record the optimality gap at each iteration
Err(1) = evaluate(X0);

%%%% Initialization %%%%
step_size  = step*ones(Num_Nodes,1);    % step size gamma
X          = X0;               % X stacks all local variables in columns
Z          = X0;
V_h        = zeros(col, Num_Nodes);
y_h        = ones(Num_Nodes, 1);

% local iteration counter for each agent i starting from 1
Lic             = ones(Num_Nodes,1);   
% T_arrive(j,i,t) record the global iteration after which the packet, sent
% from agent i and associated with i's local iteration t, becomes available 
% to j
T_arrive(:,:,1) = zeros(Num_Nodes,Num_Nodes);


for k = 1:Niter  
 
    i_k = act_list(k);
    %%%% the agent waking up at iteration k %%%%
    Lic(i_k) = Lic(i_k) + 1;
    
    %%%% Local Descent %%%%
    V_h(:,i_k,Lic(i_k)-1) = X(:,i_k) - step_size(i_k) * ...
        grad(U{i_k}, v{i_k}, Z(:,i_k));
    
    %%%% Consensus using a column stochastic matrix %%%%
    X(:,i_k)           = C(i_k,i_k) * V_h(:,i_k,Lic(i_k)-1);
    y_h(i_k, Lic(i_k)) = C(i_k,i_k) * y_h(i_k,Lic(i_k)-1);
    
    for j = 1:Num_Nodes
        if Adj(i_k,j) ~= 0
            
            % unused_pac contains the Lic's of agent j with which packets
            % to be used by i_k at this global iteration k are associated            
            time_list = T_arrive(i_k, j, 1:Lic(j)-1);
            unused_pac  = find(time_list <= k & time_list > 0);
            
%             if i_k == 2 && j == 20
%                 fprintf(['at global iteration ', num2str(k), ', ',...
%                     'unused_pac from ', num2str(j), ' to ', num2str(i_k), ' is\n'])
%                 disp(unused_pac)
%             end
            
            [num_arrive, ~] = size(unused_pac);
            for p = 1:num_arrive
                X(:,i_k) = X(:,i_k) + C(i_k,j) * V_h(:, j, unused_pac(p));
                y_h(i_k, Lic(i_k)) = y_h(i_k, Lic(i_k)) + C(i_k,j) * ...
                    y_h(j, unused_pac(p));
            end
            
            % Modify the arrive time of packets used in this global
            % iteation k to 0
            time_list(unused_pac) = 0;
            T_arrive(i_k, j, 1:Lic(j)-1) = time_list;
        end
            
        if Adj(j,i_k) ~= 0
            % i_k sends packets to its outneighbors.  Note that the packet 
            % being sent now is associated with Lic(i_k)-1.
            T_arrive(j,i_k,Lic(i_k)-1) = randi([1,MaxTravelTime]) + k;
            
%             if i_k == 20 && j == 2
%                 fprintf(['at global iteration ', num2str(k), ', ',...
%                     'the ', num2str(Lic(i_k)), '-th pac sent from ', ...
%                     num2str(i_k), ' to ', num2str(j), ' will arrive by\n'])
%                 disp(T_arrive(j,i_k,Lic(i_k)))
%             end
            
        end
    end
    Z(:,i_k) = X(:,i_k) / y_h(i_k, Lic(i_k));
    
    %%%% Optimality Gap %%%%
    Err(k+1) = evaluate(Z);
    
    if mod(k, 1000) == 0
        fprintf('AsySubPush: %d-th iteration, the error is %f\n', k, Err(k+1));
    end
    
end
end