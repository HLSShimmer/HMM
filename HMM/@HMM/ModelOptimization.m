function [obj,HMMstruct,stateEstimated,flag,residual] = ModelOptimization(obj,observeSequence,stateSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% model optimization function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                  input&output     object
% observeSequence      input            observe sequence¹Û²âÐòÁÐ
% stateSequence        input            state sequence
% HMMstructEstimated   output           estimated HMM model
% residual             output           error ratio of estimation×´Ì¬¹À¼Æ´íÎóÂÊ
% flag                 output           flag, 0:reach the max iteration, 1:error ratio below tolerance
%% declare some variables
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
N = obj.HMMstruct.N;
M = obj.HMMstruct.M;
residual = [];
flag = 1;
%% loop to optimization£¬Baum-Welch algorithm
if nargin==2
    tolerance = obj.optPara.ChangingTolerance;
    criteriaValue = 0;
    count = 0;
elseif nargin==3
    tolerance = obj.optPara.ErrorTolerance;
    criteriaValue = 0;
    count = 0;
end
stateEstimated = zeros(observeLength,1);
while criteriaValue <= (1-tolerance)
% while true
    %% make forward and backward procedure
    obj = obj.ForwardBackwardProcedure2();
    %% calculate the update value of model
    [A,B,initialStateProbability] = obj.CalculateUpdateInformation();
    A
    %% calculate and analyze the result, based on some criteria
    if nargin==2
        %%if there is no ground truth of state sequence
        bestBackwardStateCurrent = zeros(observeLength,1);
        for i=1:observeLength
            [~,bestBackwardStateCurrent(i)] = max(obj.gamma(i,:));
        end
        criteriaValue = sum(bestBackwardStateCurrent==stateEstimated)/observeLength
        stateEstimated = bestBackwardStateCurrent;
    elseif nargin==3
        %%if there is ground truth of state sequence
        bestBackwardStateCurrent = zeros(observeLength,1);
        for i=1:observeLength
            [~,bestBackwardStateCurrent(i)] = max(obj.gamma(i,:));
        end
        stateEstimated = bestBackwardStateCurrent;
        correctRatio = sum(bestBackwardStateCurrent==stateSequence)/observeLength;
        criteriaValue = correctRatio;
        residual = [residual;1 - correctRatio];
    end
    %% model update
    obj.HMMstruct.initialStateProbability = initialStateProbability;
    obj.HMMstruct.A = A;
    obj.HMMstruct.B = B;
    count = count + 1
    if count>obj.optPara.maxIter
        break;
    end
end
%% optimization result
HMMstruct = obj.HMMstruct;
if count>obj.optPara.maxIter
    flag = 0;
end