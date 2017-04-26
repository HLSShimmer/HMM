function [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% most likely individual state in timeIndex given by the model and observe sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                    input&output  object
% observeSequence        input         observe sequence
% timeIndex              input         the time index
% stateIndex             output        the state index in the hidden states
% stateProbability       output        the probability of the possible state
%% declare some variables
obj.observeSequence = observeSequence;    %observe sequence
% obj = obj.CalculateAlpha();               %forward
% obj = obj.CalculateBeta();                %backward
% obj = obj.CalculateGamma();               
%% make forward and backward procedure
obj = obj.ForwardBackwardProcedure();
number = length(timeIndex);
stateIndex = zeros(number,1);
stateProbability = zeros(number,1);
%% get probability
for i=1:number
    [stateProbability(i),stateIndex(i)] = max(obj.gamma(timeIndex(i),:));
end