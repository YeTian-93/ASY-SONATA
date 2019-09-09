function special_directed(I)

while true
    pErdosRenyi = 0.8;
    p_data_gen = 1 - sqrt(1 - pErdosRenyi);
    Adj = rand(I);
    idx1 = (Adj >= p_data_gen);
    idx2 = (Adj < p_data_gen);
    Adj(idx1) = 0;
    Adj(idx2) = 1;
    
    NotI = ~eye(I);
    Adj = Adj.*NotI;        % set diagonal entries to 0's
    Adj = or(Adj,Adj');     % symmetrize, undirected
    degree=diag(sum(Adj));  % degree matrix
    L = degree - Adj;       % standard Laplacian matrix
    lambda = sort(eig(L));
    if lambda(2) > 0.5
        fprintf(['The Erdos-Renyi graph is generated. Algebraic Connectivity: ',...
            num2str(lambda(2)),'\n']);
        break;
    end
end

%%%% delete odd number of edges randomly but still guarantee strong conn %%%%
while true
    adja         = Adj;
    num_del      = 3;
    pos_nz       = find(adja ~= 0);
    [num_nz, ~]  = size(pos_nz);
    rand_pos     = randperm(num_nz, num_del);
    for k = 1:num_del
        adja(rand_pos(k)) = 0;
    end
    if all( all( (eye(I) + adja)^I ) )        
        break;
    end
end

%%%% generate uniform weight matrices %%%%
adja = adja + eye(I);
C = adja * diag(1./sum(adja));
R = diag(1./sum(adja,2)) * adja;
fprintf('The directed graph is generated.\n');
save('directed_graph.mat', 'C', 'R')