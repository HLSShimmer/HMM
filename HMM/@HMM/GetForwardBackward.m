function [forwardResult,backwardResult] = GetForwardBackward(obj,observeSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calculate&get forward backward result
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj               input&output    object
% observeSequence   input           observe sequence
% forwardResult     output          forward result
% backwardResult    output          backward result
%% declare some variables
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
states = 1:N;
%% forward
observeProbability = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability.*initialStateProbability./sum(observeProbability.*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability = obj.GetObserveProbability(states,i);
    forwardResult(i,:) = observeProbability.*forwardNextState/sum(observeProbability.*forwardNextState);
end
%% backward and ¦Î
backwardResult(observeLength,:) = forwardResult(observeLength,:);
ksai = zeros(N,N,observeLength-1);
for i = observeLength-1:-1:1
    forwardResultMatrix = repmat(forwardResult(i,:).',1,N);
    backwardResultMatrix = repmat(backwardResult(i+1,:),N,1);
    forwardNextState = forwardResult(i,:)*obj.HMMstruct.A;
    forwardNextStateMatrix = repmat(forwardNextState,N,1);
    ksai(:,:,i) = forwardResultMatrix.*obj.HMMstruct.A.*backwardResultMatrix./forwardNextStateMatrix;
    backwardResult(i,:) = sum(ksai(:,:,i),2).';
end