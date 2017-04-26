function obj = ForwardBackwardProcedure(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% forward and backward procedure
%%% calculate the needed ¦Ãand ¦Î in Baum-Welch Algorithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    object
% gamma         output          probability of state at n given by the entire observe sequence
% ksai          output          probability of state at n and n+1 given by the entire observe sequence
%% declare some variables
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
backwardResult = zeros(observeLength,N);
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
obj.ksai = zeros(N,N,observeLength-1);
for i = observeLength-1:-1:1
    forwardResultMatrix = repmat(forwardResult(i,:).',1,N);
    backwardResultMatrix = repmat(backwardResult(i+1,:),N,1);
    forwardNextState = forwardResult(i,:)*obj.HMMstruct.A;
    forwardNextStateMatrix = repmat(forwardNextState,N,1);
    obj.ksai(:,:,i) = forwardResultMatrix.*obj.HMMstruct.A.*backwardResultMatrix./forwardNextStateMatrix;
    backwardResult(i,:) = sum(obj.ksai(:,:,i),2).';
end
%% ¦Ã
obj.gamma = backwardResult;