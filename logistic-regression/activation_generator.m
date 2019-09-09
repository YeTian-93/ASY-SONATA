function act_list = activation_generator(Num_Nodes, time_window, Activate_Mode)

global Niter

act_list = zeros(1, Niter);

switch Activate_Mode
    case 1
        % cyclic
        for m = 1:floor(Niter/Num_Nodes)
            act_list((m-1)*Num_Nodes+1:m*Num_Nodes) = 1:Num_Nodes;
        end
        act_list(floor(Niter/Num_Nodes)*Num_Nodes+1:end) = ...
            1:mod(Niter,Num_Nodes);
        
    case 2
        % incrementally generate random rd
        if time_window < Num_Nodes
            error('time_window cannot be less than Num_Nodes.');
        end
        end_prev_rd = 0;
        
        for k = 1:Niter
            p = k - end_prev_rd;
            
            if p == 1
                % Now it is the time to generate a new rd, which is of a random
                % length not less than Num_Nodes and not greater than
                % time_window.  In a rd, every agent appears at least once.
                
                len_rd                 = randi([Num_Nodes, time_window]);
                rd                     = zeros(1, len_rd);
                rd(1:Num_Nodes)        = 1:Num_Nodes;
                rd(Num_Nodes+1:len_rd) = randi(Num_Nodes,1,len_rd-Num_Nodes);                
                rd                     = rd(randperm(len_rd)); % random sorting
                
            elseif p == len_rd
                % Now we are at the end of a rd.  We need to set the
                % following.
                
                end_prev_rd = k;
            end
            
            act_list(k) = rd(p);
        end
        
    case 3
        % pure random
        act_list = randi(Num_Nodes,1,Niter);
        
end
end