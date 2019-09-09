clear all;
close all;
rng(052019,'v4');

global U v lambda col MaxTravelTime Niter act_list Num_trials Num_Nodes X0 Adj
%%%% Problem parameters %%%%
Num_Nodes         = 30;    % network
Num_outneighbor   = 7;
col               = 14;    % data
lambda            = 1;
MaxTravelTime     = 90;    % asychrony
time_window       = 90;
% Activate_Mode: 1-cyclic; 2-random round with specified maximum length of
% time_window; 3-pure random.
Activate_Mode     = 2;

Niter             = 6000;
Num_trials        = 1;

%%%% Problem data generation %%%%
% data_preprocessing
% data_generator(Num_Nodes);
% directed_graph_generator(Num_Nodes, Num_outneighbor);
% ------The user can use the above three lines to generate data and network.
load data.mat
load directed_graph.mat

%%%% Initializations %%%%
ASYSONATA_stack        = zeros(Num_trials, Niter+1);
ASYSONATA_dimi_stack   = zeros(Num_trials, Niter+1);
AsySubPush_stack       = zeros(Num_trials, Niter+1);
AsySPA_stack           = zeros(Num_trials, Niter+1);

for exp = 1:Num_trials
    tic
    fprintf('trial: %d\n',exp);
    X0 = randn(col,Num_Nodes);
    % generate a list of activation of agents
    act_list = activation_generator(Num_Nodes, time_window, Activate_Mode);
    
    %% ASYSONATA
    step = 0.7;
    eps  = 0;
    isWithAux = false;
    
    ASYSONATA_stack(exp,:) = ASYSONATA(C, R, step, eps, isWithAux);
    disp(['ASYSONATA Err: ', num2str(ASYSONATA_stack(exp,end))]);
    
    %% ASYSONATA-dimi
    step = 0.7;
    eps  = 0.001;
    isWithAux = false;
    
    ASYSONATA_dimi_stack(exp,:) = ASYSONATA(C, R, step, eps, isWithAux);
    disp(['ASYSONATA-dimi Err: ', num2str(ASYSONATA_dimi_stack(exp,end))]);
    
    %% AsySubPush
    step = 0.0005;
    
    AsySubPush_stack(exp,:) = AsySubPush(C, step);
    disp(['AsySubPush Err: ', num2str(AsySubPush_stack(exp,end))]);
    
    %% AsySPA
    const = 0.005;
    rho   = const ./ sqrt(1:Niter);
    
    AsySPA_stack(exp,:) = AsySPA(C, rho);
    disp(['AsySPA Err: ', num2str(AsySPA_stack(exp,end))]);
    
    toc
end

clear all
load('result.mat')
if Num_trials == 1
    ASYSONATA_mean        = ASYSONATA_stack;
    ASYSONATA_dimi_mean   = ASYSONATA_dimi_stack;
    AsySubPush_mean       = AsySubPush_stack;
    AsySPA_mean           = AsySPA_stack;
else
    ASYSONATA_mean        = mean(ASYSONATA_stack);
    ASYSONATA_dimi_mean   = mean(ASYSONATA_dimi_stack);
    AsySubPush_mean       = mean(AsySubPush_stack);
    AsySPA_mean           = mean(AsySPA_stack);
end

iterations = 1:Niter+1;

figure
fmean = semilogy(iterations, ASYSONATA_mean, 'r',...
    iterations, ASYSONATA_dimi_mean, 'g', ...
    iterations, AsySubPush_mean, 'k', ...
    iterations, AsySPA_mean, 'b');
hold on
set(fmean, 'linewidth', 3);
xlabel({'Global iterations'}, 'FontSize', 16)
ylabel({'Optimality gap'}, 'FontSize', 16)
legend({'ASYSONATA', 'ASYSONATA-dimi', 'AsySubPush', 'AsySPA'}, 'FontSize', 16)
xlim([0 Niter+1])
ylim([10^(-10) inf])
set(gca,'FontSize',16)
