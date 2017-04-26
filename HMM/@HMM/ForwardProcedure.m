function forwardResult = ForwardProcedure(obj,observeSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 根据观测序列计算前向推倒结果 %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj               input&output    对象
% observeSequence   input           观测序列
% forwardResult     output          前向结果
%% 基本参数
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
states = 1:N;
%% 前向
observeProbability = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability.*initialStateProbability./sum(observeProbability.*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability = obj.GetObserveProbability(states,i);
    forwardResult(i,:) = observeProbability.*forwardNextState/sum(observeProbability.*forwardNextState);
end