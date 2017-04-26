clear all;close all;clc;
%% generate model
N = 3;M = 5;
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
observeLength = 500000;
[stateSequence,observeSequence] = model.GenerateObserveSequence(observeLength);
%% analyse and verify if generated observe sequence is consistent with model
%A
ksaiNumber = zeros(N,N);
gammaNumber = zeros(N,1);
gammaNumber(1) = sum(stateSequence==1);
gammaNumber(2) = sum(stateSequence==2);
gammaNumber(3) = sum(stateSequence==3);
for i=1:observeLength-1
    indexPre = stateSequence(i);
    indexAft = stateSequence(i+1);
    ksaiNumber(indexPre,indexAft) = ksaiNumber(indexPre,indexAft) + 1;
end
A = ksaiNumber./repmat(gammaNumber,1,N)
HMMstruct.A
%B
B = zeros(N,M);
for i=1:observeLength
    B(stateSequence(i),observeSequence(i)) = B(stateSequence(i),observeSequence(i)) + 1;
end
B = B./repmat(gammaNumber,1,M)
HMMstruct.B