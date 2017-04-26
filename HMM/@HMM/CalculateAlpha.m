function obj = CalculateAlpha(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calculate joint probability of observe from 1 to n and state at n given by the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj             input&output   object
%% declare some variables
A = obj.HMMstruct.A;
N = obj.HMMstruct.N;
observeLength = length(obj.observeSequence);
alpha = zeros(observeLength,N);
states = 1:N;
observeProbabilityTemp = obj.GetObserveProbability(states,1);
alpha(1,:) = obj.HMMstruct.initialStateProbability.*observeProbabilityTemp;
%% propagate forward
for i = 2:observeLength
    observeProbabilityTemp = obj.GetObserveProbability(states,i);
    for j=1:N
        alpha(i,j) = sum(alpha(i-1,:).*A(:,j).')*observeProbabilityTemp(j);
    end
end
%% update alpha
obj.alpha = alpha;