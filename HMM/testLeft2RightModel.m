clear all;close all;clc;
%% generate model
N = 4;                       %state number
M = 1;                       %mixture component number
observeDimension = 1;        %dimension of observance
observeSpan = 0:0.02:10;   %
HMMstruct.N = N;
HMMstruct.M = M;
HMMstruct.observePDFType = 'CONTINUOUS_GAUSSIAN';     %% CONTINUOUS_GAUSSIAN, DISCRET
HMMstruct.transitMatrixType = 'LEFT2RIGHT';               %% NORMAL, LEFT2RIGHT
% HMMstruct.A = [0.4   0.15   0.25   0.2;
%                0.12  0.52   0.16   0.2;
%                0.33  0.17   0.28   0.22;
%                0.2   0.1    0.25   0.45];
HMMstruct.A = [0.96   0.04   0      0;
               0      0.92   0.08   0;
               0      0      0.91   0.09;
               0.10   0      0      0.90];
HMMstruct.B.mixtureNum = M;
HMMstruct.B.weights = [1;1;1;1];
HMMstruct.B.mu = cell(N,1);
HMMstruct.B.mu{1} = 0.6;
HMMstruct.B.mu{2} = 3.5;
HMMstruct.B.mu{3} = 6.5;
HMMstruct.B.mu{4} = 9;
HMMstruct.B.sigma = cell(N,1);
HMMstruct.B.sigma{1} = zeros(1,1,M);
HMMstruct.B.sigma{1}(1,1,1) = 0.5;
HMMstruct.B.sigma{2} = zeros(1,1,M);
HMMstruct.B.sigma{2}(1,1,1) = 0.6;
HMMstruct.B.sigma{3} = zeros(1,1,M);
HMMstruct.B.sigma{3}(1,1,1) = 0.55;
HMMstruct.B.sigma{4} = zeros(1,1,M);
HMMstruct.B.sigma{4}(1,1,1) = 0.45;
HMMstruct.B.PDF = cell(N,1);
HMMstruct.B.PDF{1} = gmdistribution(HMMstruct.B.mu{1},HMMstruct.B.sigma{1},HMMstruct.B.weights(1,:));
HMMstruct.B.PDF{2} = gmdistribution(HMMstruct.B.mu{2},HMMstruct.B.sigma{2},HMMstruct.B.weights(2,:));
HMMstruct.B.PDF{3} = gmdistribution(HMMstruct.B.mu{3},HMMstruct.B.sigma{3},HMMstruct.B.weights(3,:));
HMMstruct.B.PDF{4} = gmdistribution(HMMstruct.B.mu{4},HMMstruct.B.sigma{4},HMMstruct.B.weights(4,:));
HMMstruct.initialStateProbability = [0.25 0.25 0.25 0.25];
model = HMM();
model = model.SetModel(HMMstruct);
observePDF = model.GetObservePDF(observeSpan);
%% optimal para settings
optPara.maxIter = 50;
optPara.tolerance = 0.001;
model = model.SetOptPara(optPara);
%% generate observe sequence
observeLength = 15000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
%% optimize model
%%initialization of model
HMMstruct_initial.N = N;
HMMstruct_initial.M = M;
HMMstruct_initial.observePDFType = 'CONTINUOUS_GAUSSIAN';
HMMstruct_initial.transitMatrixType = 'LEFT2RIGHT';               %% NORMAL, LEFT2RIGHT
% HMMstruct_initial.A = [0.30  0.20   0.40   0.10;
%                        0.20  0.42   0.10   0.28;
%                        0.22  0.28   0.38   0.12;
%                        0.13  0.14   0.20   0.53];
HMMstruct_initial.A = [0.15   0.60    0.10   0.15;
                       0.10   0.22    0.58   0.10;
                       0.05   0.05    0.58   0.42;
                       0.60   0.10    0.10  0.20];
HMMstruct_initial.B.mixtureNum = M;
HMMstruct_initial.B.weights = [1;1;1;1];
HMMstruct_initial.B.mu = cell(N,1);
HMMstruct_initial.B.mu{1} = 1.8;
HMMstruct_initial.B.mu{2} = 2.8;
HMMstruct_initial.B.mu{3} = 7;
HMMstruct_initial.B.mu{4} = 8;
HMMstruct_initial.B.sigma = cell(N,1);
HMMstruct_initial.B.sigma{1} = zeros(1,1,M);
HMMstruct_initial.B.sigma{1}(1,1,1) = 0.6;
HMMstruct_initial.B.sigma{2} = zeros(1,1,M);
HMMstruct_initial.B.sigma{2}(1,1,1) = 1.1;
HMMstruct_initial.B.sigma{3} = zeros(1,1,M);
HMMstruct_initial.B.sigma{3}(1,1,1) = 0.6;
HMMstruct_initial.B.sigma{4} = zeros(1,1,M);
HMMstruct_initial.B.sigma{4}(1,1,1) = 0.75;
HMMstruct_initial.B.PDF = cell(N,1);
HMMstruct_initial.B.PDF{1} = gmdistribution(HMMstruct_initial.B.mu{1},HMMstruct_initial.B.sigma{1},HMMstruct_initial.B.weights(1,:));
HMMstruct_initial.B.PDF{2} = gmdistribution(HMMstruct_initial.B.mu{2},HMMstruct_initial.B.sigma{2},HMMstruct_initial.B.weights(2,:));
HMMstruct_initial.B.PDF{3} = gmdistribution(HMMstruct_initial.B.mu{3},HMMstruct_initial.B.sigma{3},HMMstruct_initial.B.weights(3,:));
HMMstruct_initial.B.PDF{4} = gmdistribution(HMMstruct_initial.B.mu{4},HMMstruct_initial.B.sigma{4},HMMstruct_initial.B.weights(4,:));
HMMstruct_initial.initialStateProbability = [0.2 0.3 0.15 0.35];
%%optimization
model = model.SetModel(HMMstruct_initial);
tic
[model,HMMstructEstimated,stateEstimated,residual,flag] = model.ModelOptimization(observeSequence,stateSequence);
toc
% [stateSequenceEstimate,observeSequenceEstimate] = model.GenerateObserveSequence(observeLength);
% HMMstructEstimated = model.GetModel();
observePDFestimated = model.GetObservePDF(observeSpan);
%% plot
HMMstruct.A
HMMstructEstimated.A
figure(1)
plot(stateSequence(1:100,1),'LineWidth',2);
xlabel('samples')
ylabel('state')
title('State Sequence of Simulation')

figure(2)
plot(observeSequence(1:100,1),'LineWidth',2);
xlabel('samples')
ylabel('observance')
title('Observe Sequence of Simulation')

figure(3)
plot(residual,'LineWidth',2)
xlabel('iteration')
ylabel('residual')
title('Error Ratio')

figure(4)
for i = 1:N
    subplot(N,1,i)
    plot(observeSpan,observePDF(i,:),'LineWidth',2);
    hold on
    plot(observeSpan,observePDFestimated(i,:),'LineWidth',2);
    legend('True','Estimated')
    title(strcat('Observed Gaussian Mixture PDF (state',num2str(i),')'))
end

figure(5)
plot(stateSequence(1:100,1),'LineWidth',2)
hold on
plot(stateEstimated(1:100,1),'+','MarkerSize',8)
legend('True','Estimated')
xlabel('samples')
ylabel('state')
title('State Compare')