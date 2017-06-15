clear all;close all;clc;
%% generate model
N = 2;                       %state number
M = 1;                       %mixture component number
observeDimension = 1;        %dimension of observance
observeSpan = -10:0.02:10;   %
HMMstruct.N = N;
HMMstruct.M = M;
HMMstruct.observePDFType = 'CONTINUOUS_GAUSSIAN';     %% CONTINUOUS_GAUSSIAN, DISCRET
HMMstruct.transitMatrixType = 'NORMAL';               %% NORMAL, LEFT2RIGHT
HMMstruct.A = [0.7 0.3;0.2 0.8];
HMMstruct.B.mixtureNum = M;
HMMstruct.B.weights = [1;1];
% HMMstruct.B.weights = [1/3 1/3 1/3;0.3 0.35 0.35];
HMMstruct.B.mu = cell(N,1);
HMMstruct.B.mu{1} = -3.5;
HMMstruct.B.mu{2} = 2;
% HMMstruct.B.mu{1} = [-5;1;5.5];
% HMMstruct.B.mu{2} = [-8;-2.5;3];
HMMstruct.B.sigma = cell(N,1);
HMMstruct.B.sigma{1} = zeros(1,1,M);
HMMstruct.B.sigma{1}(1,1,1) = 1.2;
% HMMstruct.B.sigma{1}(1,1,1) = 1.2;
% HMMstruct.B.sigma{1}(1,1,2) =  1.4;
% HMMstruct.B.sigma{1}(1,1,3) = 1.4;
HMMstruct.B.sigma{2} = zeros(1,1,M);
HMMstruct.B.sigma{2}(1,1,1) = 1.4;
% HMMstruct.B.sigma{2}(1,1,1) = 1.4;
% HMMstruct.B.sigma{2}(1,1,2) = 1.4;
% HMMstruct.B.sigma{2}(1,1,3) = 1.2;
HMMstruct.B.PDF = cell(N,1);
HMMstruct.B.PDF{1} = gmdistribution(HMMstruct.B.mu{1},HMMstruct.B.sigma{1},HMMstruct.B.weights(1,:));
HMMstruct.B.PDF{2} = gmdistribution(HMMstruct.B.mu{2},HMMstruct.B.sigma{2},HMMstruct.B.weights(2,:));
HMMstruct.initialStateProbability = [0.5 0.5];
model = HMM();
model = model.SetModel(HMMstruct);
observePDF = model.GetObservePDF(observeSpan);
%% optimal para settings
optPara.maxIter = 120;
optPara.ErrorTolerance = 0.01;         %%used when there is a ground truth of state
optPara.ChangingTolerance = 1e-4;      %%used when there is no ground truth of state
model = model.SetOptPara(optPara);
%% generate observe sequence
observeLength = 10000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
%% optimize model
%%initialization of model
HMMstruct_initial.N = N;
HMMstruct_initial.M = M;
HMMstruct_initial.observePDFType = 'CONTINUOUS_GAUSSIAN';
HMMstruct_initial.transitMatrixType = 'NORMAL';               %% NORMAL, LEFT2RIGHT
HMMstruct_initial.A = [0.1 0.9;0.15 0.85];
HMMstruct_initial.B.mixtureNum = M;
HMMstruct_initial.B.weights = [1;1];
% HMMstruct_initial.B.weights = [0.2 0.4 0.4;0.1 0.5 0.4];
HMMstruct_initial.B.mu = cell(N,1);
HMMstruct_initial.B.mu{1} = -1;
HMMstruct_initial.B.mu{2} = 0;
% HMMstruct_initial.B.mu{1} = [-6;1.6;6];
% HMMstruct_initial.B.mu{2} = [-5.5;-4;2.8];
HMMstruct_initial.B.sigma = cell(N,1);
HMMstruct_initial.B.sigma{1} = zeros(1,1,M);
HMMstruct_initial.B.sigma{1}(1,1,1) = 0.8;
% HMMstruct_initial.B.sigma{1}(1,1,1) = 0.8;
% HMMstruct_initial.B.sigma{1}(1,1,2) = 4;
% HMMstruct_initial.B.sigma{1}(1,1,3) = 1.1;
HMMstruct_initial.B.sigma{2} = zeros(1,1,M);
HMMstruct_initial.B.sigma{2}(1,1,1) = 0.9;
% HMMstruct_initial.B.sigma{2}(1,1,1) = 2.2;
% HMMstruct_initial.B.sigma{2}(1,1,2) = 1.6;
% HMMstruct_initial.B.sigma{2}(1,1,3) = 1.7;
HMMstruct_initial.B.PDF = cell(N,1);
HMMstruct_initial.B.PDF{1} = gmdistribution(HMMstruct_initial.B.mu{1},HMMstruct_initial.B.sigma{1},HMMstruct_initial.B.weights(1,:));
HMMstruct_initial.B.PDF{2} = gmdistribution(HMMstruct_initial.B.mu{2},HMMstruct_initial.B.sigma{2},HMMstruct_initial.B.weights(2,:));
HMMstruct_initial.initialStateProbability = [0.2 0.8];
%%optimization
model = model.SetModel(HMMstruct_initial);
tic
[model,HMMstructEstimated,stateEstimated,flag,residual] = model.ModelOptimization(observeSequence,stateSequence);
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
subplot(211);
plot(observeSpan,observePDF(1,:),'LineWidth',2);
hold on
plot(observeSpan,observePDFestimated(1,:),'LineWidth',2);
legend('True','Estimated')
title('Observe Gaussian Mixture PDF (state1)')
subplot(212);
plot(observeSpan,observePDF(2,:),'LineWidth',2);
hold on
plot(observeSpan,observePDFestimated(2,:),'LineWidth',2);
legend('True','Estimated')
title('Observe Gaussian Mixture PDF (state2)')

figure(5)
plot(stateSequence(1:100,1),'LineWidth',2)
hold on
plot(stateEstimated(1:100,1),'+','MarkerSize',8)
legend('True','Estimated')
xlabel('samples')
ylabel('state')
title('State Compare')