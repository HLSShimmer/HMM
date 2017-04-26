function beta = CalculateBeta(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% probability of observance from n+1 to N given by state at n and the model
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj            input&output   object
% beta           output         the probability
%% declare some variables
A = obj.HMMstruct.A;
observeLength = length(obj.observeSequence);
beta = zeors(observeLength,N);
states = 1:N;
beta(observeLength,:) = 1;
%% propagate backward
for i = observeLength-1:-1:1
    observeProbabilityTemp = obj.GetObserveProbability(states,i+1);
    for j = 1:N
        temp = A(j,:).*observeProbabilityTemp;
        temp = temp.*beta(i+1,:);
        beta(i,j) = sum(temp);
    end
end