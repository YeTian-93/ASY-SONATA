function data_generator(Num_Nodes)

text  = fileread('processed.cleveland.data');
lines = strread(text, '%s','delimiter','\n');
data  = zeros(1,14);
k     = 1;

for l = 1:length(lines)
    temp = str2num(cell2mat(lines(l)));
    if ~isempty(temp)
        data(k,:) = temp;
        if data(k,end) == 0
            data(k,end) = -1.0;
        else
            data(k,end) = 1.0;
        end
        k = k+1;
    end
end

[n_samp, col] = size(data);
features      = data(:,1:end-1);
features      = (features-ones(n_samp,1)*min(features))...
                ./(ones(n_samp,1)*(max(features)-min(features)));

U_stack            = ones(n_samp, col);
U_stack(:,1:end-1) = features;
v_stack            = data(:,end);

U = cell(1, Num_Nodes);
v = cell(1, Num_Nodes);

n_loc_samp = ceil(n_samp/Num_Nodes);

for i = 1:Num_Nodes-1
    U{i} = U_stack(n_loc_samp*(i-1)+1:n_loc_samp*i,:);
    v{i} = v_stack(n_loc_samp*(i-1)+1:n_loc_samp*i);
end
U{Num_Nodes} = U_stack(n_loc_samp*(Num_Nodes-1)+1:end,:);
v{Num_Nodes} = v_stack(n_loc_samp*(Num_Nodes-1)+1:end);
 
save('data.mat', 'U', 'v')
fprintf('Data is generated\n');
end
% exit;