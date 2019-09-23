function [A, b, X_opt] = Data_Gen(Num_Nodes)
global row col

A_Gen = randn(row*Num_Nodes,col);
for i = 1:Num_Nodes
    A_Gen((i-1)*row+1:i*row,:) = A_Gen((i-1)*row+1:i*row,:)...
        /norm(A_Gen((i-1)*row+1:i*row,:),2);
end
Xe    = randn(col,1);
b_Gen = A_Gen*Xe + 0.2*randn(row*Num_Nodes,1);
X_opt = A_Gen\b_Gen;

A = cell(1, Num_Nodes);
b = cell(1, Num_Nodes);
for i = 1:Num_Nodes
    A{i} = A_Gen((i-1)*row+1:i*row,:);
    b{i} = b_Gen((i-1)*row+1:i*row,:);
end
end