function forwardResult = ForwardProcedure(obj,observeSequence)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% ���ݹ۲����м���ǰ���Ƶ���� %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj               input&output    ����
% observeSequence   input           �۲�����
% forwardResult     output          ǰ����
%% ��������
N = obj.HMMstruct.N;
initialStateProbability = obj.HMMstruct.initialStateProbability;
obj.observeSequence = observeSequence;
observeLength = length(obj.observeSequence);
forwardResult = zeros(observeLength,N);
states = 1:N;
%% ǰ��
observeProbability = obj.GetObserveProbability(states,1);
forwardResult(1,:) = observeProbability.*initialStateProbability./sum(observeProbability.*initialStateProbability);
for i = 2:observeLength
    forwardNextState = forwardResult(i-1,:)*obj.HMMstruct.A;
    observeProbability = obj.GetObserveProbability(states,i);
    forwardResult(i,:) = observeProbability.*forwardNextState/sum(observeProbability.*forwardNextState);
end