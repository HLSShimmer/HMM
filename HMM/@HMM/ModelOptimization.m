function [obj,HMMstruct,residual,flag] = ModelOptimization(obj,observeSequence,stateSequence)
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
%% loop to optimization£¬Baum-Welch algorithm
tolerance = obj.optPara.tolerance;
criteriaValue = inf;
correctRatioPrevious = 0;
count = 0;
while correctRatioPrevious <= (1-tolerance)
    tic
    %% make forward and backward procedure
    obj = obj.ForwardBackwardProcedure();
    %% calculate the update value of model
    initialStateProbability = zeros(1,N);
    A = zeros(N,N);
    B = zeros(N,M);
    for i=1:N
        %% initial state probability distribution
        initialStateProbability(i) = obj.gamma(1,i);
        %% state transfer matrix
        for j=1:N
            A(i,j) = sum(obj.ksai(i,j,:))/sum(obj.gamma(1:observeLength-1,i));
        end
        %% observe probability distribution or pdf
        if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
            for j=1:M
                B(i,j) = sum(obj.gamma(observeSequence==j,i))/sum(obj.gamma(:,i));
            end
        elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
            B = obj.UpdateBContinuous();
        end
    end
    %% calculate and analyze the result, based on some criteria
%     initialStateProbabilityError = max(abs((initialStateProbability - obj.HMMstruct.initialStateProbability)./obj.HMMstruct.initialStateProbability));
%     Aerror = max(max(abs((A - obj.HMMstruct.A)./obj.HMMstruct.A)));
%     Berror = max(max(abs((B - obj.HMMstruct.B)./obj.HMMstruct.B)));
%     toc
%     criteriaValue = max([initialStateProbabilityError Aerror Berror])
    bestBackwardStateCurrent = zeros(observeLength,1);
    for i=1:observeLength
        [~,bestBackwardStateCurrent(i)] = max(obj.gamma(i,:));
    end
    correctRatio = sum(bestBackwardStateCurrent==stateSequence)/observeLength;
    criteriaValue = abs(correctRatio-correctRatioPrevious)/correctRatioPrevious;
    correctRatioPrevious = correctRatio
    %% model update
    obj.HMMstruct.initialStateProbability = initialStateProbability;
    obj.HMMstruct.A = A;
    obj.HMMstruct.B = B;
    if mod(count,50)==0
        initialStateProbability
        A
        B
    end
    count = count + 1;
    if count>obj.optPara.maxIter
        break;
    end
end
%% optimization result
HMMstruct = obj.HMMstruct;
if count>obj.optPara.maxIter
    flag = 0;
end
residual = correctRatioPrevious;
