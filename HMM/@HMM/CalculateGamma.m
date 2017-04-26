function gamma = CalculateGamma(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% given the model and observe sequence,
%%% get the probability when state is i at time n
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj        input&output  object
% gamma      output        the probability
%% declare some variables
observeLength = length(obj.observeSequence);
alpha = obj.alpha;
beta = obj.beta;
N = obj.HMMstruct.N;
%% calculate
gamma = zeros(observeLength,N);
for i = 1:observeLength
    gamma(i,:) = alpha(i,:).*beta(i,:)/sum(alpha(i,:).*beta(i,:));
end