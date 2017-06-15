function stationaryProbability = GetStationaryProbability(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% based on gamma, get stationary probability of each state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obj                      input            object
%stationaryProbability    output           stationary probability
%% judge before calculate
if isempty(obj.gamma)
    warning('¦Ã has not been calculated before!')
    stationaryProbability = [];
    return;
end
%% declare some variables
N = obj.HMMstruct.N;
stationaryProbability = zeros(N,1);
%% calculate stationary probability
for i=1:N
    stationaryProbability(i) = sum(obj.gamma(:,i))/size(obj.gamma,1);
end