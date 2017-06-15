function obj = ForwardBackwardProcedure2(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% forward and backward procedure
%%%% calculate the needed ¦Ãand ¦Î in Baum-Welch Algorithm
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
Sn = zeros(observeLength-1,1);
observeProbability = zeros(observeLength,N);
states = 1:N;
%% forward
observeProbability(1,:) = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability(1,:).*initialStateProbability./sum(observeProbability(1,:).*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability(i,:) = obj.GetObserveProbability(states,i);
    temp = observeProbability(i,:).*forwardNextState/sum(observeProbability(i,:).*forwardNextState);
%     temp(temp<eps) = eps;            %the minimum value is eps, in order to avoid the zero result
    forwardResult(i,:) = temp;
    Sn(i-1) = sum(observeProbability(i,:).*forwardNextState);
end
%% backward
backwardResult(observeLength,:) = 1;
for i=observeLength-1:-1:1
    observeProbabilityMatrix = repmat(observeProbability(i+1,:),N,1);
    backwardResultMatrix = repmat(backwardResult(i+1,:),N,1);
    temp = sum(obj.HMMstruct.A.*observeProbabilityMatrix.*backwardResultMatrix,2).'/Sn(i);
%     temp(temp<eps) = eps;            %the minimum value is eps, in order to avoid the zero result
    backwardResult(i,:) = temp;
end
%% ¦Ã, ¦Î
obj.gamma = zeros(observeLength,N);
obj.ksai = zeros(N,N,observeLength-1);
for i=1:observeLength
    obj.gamma(i,:) = forwardResult(i,:).*backwardResult(i,:);
    if i<observeLength
        forwardResultMatrix = repmat(forwardResult(i,:).',1,N);
        backwardResultMatrix = repmat(backwardResult(i+1,:),N,1);
        observeProbabilityMatrix = repmat(observeProbability(i+1,:),N,1);
        obj.ksai(:,:,i) = (forwardResultMatrix.*obj.HMMstruct.A.*backwardResultMatrix.*observeProbabilityMatrix)./Sn(i);
    end
end