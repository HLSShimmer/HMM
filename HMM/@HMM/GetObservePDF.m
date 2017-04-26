function observePDF = GetObservePDF(obj,observeSpan)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% get observe probability pdf for each state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj           input&output    object
% observeSpan   input           range of observe value
% observePDF    output          observe pdf
%% declare some variables
stateNum = obj.HMMstruct.N;
observePDF = zeros(stateNum,length(observeSpan));
%% probability pdf
for i=1:stateNum
    for j=1:length(observeSpan)
        observePDF(i,j) = obj.HMMstruct.B.PDF{i}.pdf(observeSpan(j));
    end
end