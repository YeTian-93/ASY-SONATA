figure

subplot(1,2,1)
clear all;
load logistic-regression/result.mat

axis_font_size = 18;

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

fmean = semilogy(iterations, ASYSONATA_mean, 'r',...
    iterations, ASYSONATA_dimi_mean, 'g', ...
    iterations, AsySubPush_mean, 'k', ...
    iterations, AsySPA_mean, 'b');
hold on
set(fmean, 'linewidth', 3);
xlabel({'Global iterations'}, 'FontSize', 16)
ylabel({'M_{sc}'}, 'FontSize', axis_font_size)
legend({'ASYSONATA', 'ASYSONATA-dimi', 'AsySubPush', 'AsySPA'}, 'FontSize', 16)
xlim([0 Niter+1])
ylim([10^(-10) inf])
set(gca,'FontSize',axis_font_size)

subplot(1,2,2)
clear all;
load squared-0-1/result.mat

axis_font_size = 18;

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

fmean = semilogy(iterations, ASYSONATA_mean, 'r',...
    iterations, ASYSONATA_dimi_mean, 'g', ...
    iterations, AsySubPush_mean, 'k', ...
    iterations, AsySPA_mean, 'b');
hold on
set(fmean, 'linewidth', 3);
xlabel({'Global iterations'}, 'FontSize', 16)
ylabel({'M_F'}, 'FontSize', axis_font_size)
legend({'ASYSONATA', 'ASYSONATA-dimi', 'AsySubPush', 'AsySPA'}, 'FontSize', 16)
xlim([0 Niter+1])
% ylim([10^(-10) inf])
set(gca,'FontSize',axis_font_size)