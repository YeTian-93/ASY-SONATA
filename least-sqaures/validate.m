clear all;
close all;
rng(052019,'v4');

global A b X_opt row col MaxTravelTime Niter act_list Adj ...
    Num_trials Num_Nodes X0
%%%% Problem parameters %%%%
Num_Nodes         = 30;    % network
Num_outneighbor   = 3;
row               = 30;    % number of observations per agent
col               = 200;   % dimension of the variable
MaxTravelTime     = 40;    % asychrony
time_window       = 30;
% Activate_Mode: 1-cyclic; 2-random round with specified maximum length of
% time_window; 3-pure random.
Activate_Mode     = 2;     

Niter             = 24000;
Num_trials        = 100;

%%%% Initializations %%%%
ASYSONATA_stack        = zeros(Num_trials, Niter+1);
ASYSONATA_dimi_stack   = zeros(Num_trials, Niter+1);
SONATA_stack           = zeros(Num_trials, floor(Niter/Num_Nodes)+1);

for exp = 1:Num_trials
    tic
    fprintf('trial: %d\n',exp);
    % generate graph and data 
    [C, R, Adj] = directed_graph_generator(Num_Nodes, Num_outneighbor);
    [A, b, X_opt] = Data_Gen(Num_Nodes);
    
    X0 = randn(col,Num_Nodes);
    % generate a list of activation of agents
    act_list = activation_generator(Num_Nodes, time_window, Activate_Mode);
    
    %% ASYSONATA
    step = 3.5;
    eps  = 0;
    isWithAux = false;
    
    ASYSONATA_stack(exp,:) = ASYSONATA(C, R, step, eps, isWithAux);
    disp(['ASYSONATA Err: ', num2str(ASYSONATA_stack(exp,end))]);
    
    %% ASYSONATA-dimi
    step = 3.5;
    eps  = 0.001;
    isWithAux = false;
    
    ASYSONATA_dimi_stack(exp,:) = ASYSONATA(C, R, step, eps, isWithAux);
    disp(['ASYSONATA-dimi Err: ', num2str(ASYSONATA_dimi_stack(exp,end))]);
    
    %% SONATA
    step = 0.8;
    
    SONATA_stack(exp,:) = SONATA(C, R, step);
    disp(['SONATA Err: ', num2str(SONATA_stack(exp,end))]);
    
    toc
end
save result.mat
% exit;
load result.mat

if Num_trials == 1
    ASYSONATA_mean        = ASYSONATA_stack;
    ASYSONATA_dimi_mean   = ASYSONATA_dimi_stack;
    SONATA_mean           = SONATA_stack;
else
    ASYSONATA_mean        = mean(ASYSONATA_stack);
    ASYSONATA_dimi_mean   = mean(ASYSONATA_dimi_stack);
    SONATA_mean           = mean(SONATA_stack);
end
asy_iterations = 0:1/Num_Nodes:Niter/Num_Nodes;
syc_iterations = 0:floor(Niter/Num_Nodes);

figure
fmean = semilogy(asy_iterations, ASYSONATA_mean,...
    asy_iterations, ASYSONATA_dimi_mean, ...
    syc_iterations, SONATA_mean);
hold on
set(fmean, 'linewidth', 3);
xlabel({'Global iterations'}, 'FontSize', 16)
ylabel({'Optimality gap'}, 'FontSize', 16)
legend({'ASYSONATA', 'ASYSONATA-dimi', 'SONATA'}, 'FontSize', 16)
ylim([10^(-8) inf])
set(gca,'FontSize',16)