clear all;close all;clc;
%% generate model
N = 5;M = 50;
HMMstruct.N = N;
HMMstruct.M = M;
HMMstruct.observePDFType = 'DISCRET';
for i=1:N
    temp = rand(1,N);
    HMMstruct.A(i,:) = temp/sum(temp);
end
for i=1:N
    temp = rand(1,M);
    HMMstruct.B(i,:) = temp/sum(temp);
end
temp = rand(1,N);
HMMstruct.initialStateProbability = temp/sum(temp);
% HMMstruct.A = [0.4 0.3 0.3;
%                0.2 0.6 0.2;
%                0.8 0.1 0.1];
% HMMstruct.B = [0.15 0.12 0.08 0.36 0.29;
%                0.33 0.05 0.22 0.30 0.10;
%                0.07 0.11 0.26 0.30 0.26];
% HMMstruct.initialStateProbability = [1/3 1/3 1/3];
model = HMM();
model = model.SetModel(HMMstruct);
%% generate observe sequence
observeLength = 800000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
%% calculate forward&backward result
[forwardResult,backwardResult] = model.GetForwardBackward(observeSequence);
%% analyse result
bestForwardState = zeros(observeLength,1);
bestBackwardState = zeros(observeLength,1);
for i=1:observeLength
    [~,bestForwardState(i)] = max(forwardResult(i,:));
    [~,bestBackwardState(i)] = max(backwardResult(i,:));
end
correctRatio_forward = sum(stateSequence==bestForwardState)/observeLength
correctRatio_backward = sum(stateSequence==bestBackwardState)/observeLength