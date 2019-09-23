function [C, R, Adj] = directed_graph_generator(I, N_outneighbor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This code generates a directed graph.
% 
% I:               Number of agents over the graph;
% N_outneighbor:   Number of out-neighbors of each agent
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% A circle graph %%%%
Adj = diag(ones(1,I-1), -1);
Adj(1,I) = 1;
% Adj = Adj + eye(I);

%%%% Add edge randomly %%%%
for i = 1:I
    candidates = randperm(I, N_outneighbor+1);
    counter = 0;
    j       = 1;
    while counter < N_outneighbor-1
        if candidates(j) ~= i && mod(candidates(j)-i,I) ~= 1
            Adj(candidates(j),i) = 1;
            counter = counter + 1;
        end
        j = j + 1;
    end     
end

C = (Adj+eye(I)) * diag(1./sum(Adj+eye(I)));
R = diag(1./sum(Adj+eye(I), 2)) * (Adj+eye(I));
fprintf('The directed graph is generated.\n');
% save('directed_graph.mat', 'C', 'R', 'Adj')
