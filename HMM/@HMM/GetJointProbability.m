function jointProbability = GetJointProbability(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% based on ksai, get joint probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obj                      input            object
%jointProbability         output           joint probability
%% judge before calculate
if isempty(obj.ksai)
    warning('¦Î has not been calculated before!')
    jointProbability = [];
    return;
end
%% declare some variables
N = obj.HMMstruct.N;
jointProbability = zeros(N,N);
%% calculate joint probability
for i = 1:N
    for j = 1:N
        jointProbability(i,j) = sum(obj.kesai(i,j,:))/size(obj.kesai,3);
    end
end