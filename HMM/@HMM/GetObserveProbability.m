function observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% with the input of stateIndex and time Index,
%%% get the probability of specific observe given by each hidden state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj                          input&output  object
% state                        input         the state index in the hidden states
% timeIndex                    input         the time index
% observeSequenceProbability   output        the probability of observance at 'timeIndex' given by each hidden state
%% declare some variables
observeSequenceProbability = zeros(length(timeIndex),length(stateIndex));
%% get observe probability
if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
    for i=1:length(timeIndex)
        for j=1:length(stateIndex)
            observeSequenceProbability(i,j) = obj.HMMstruct.B(stateIndex(j),obj.observeSequence(timeIndex(i)));
        end
    end
elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
%     for i=1:length(timeIndex)
%         for j=1:length(stateIndex)
%             observeSequenceProbability(i,j) = obj.HMMstruct.B.PDF{stateIndex(j)}.pdf(obj.observeSequence(timeIndex(i)));
%         end
%     end
    for i=1:length(stateIndex)
        observeSequenceProbability(:,i) = obj.HMMstruct.B.PDF{stateIndex(i)}.pdf(obj.observeSequence(timeIndex));
    end
%     observeSequenceProbability(observeSequenceProbability<eps*eps) = eps*eps;   %the minimum value is eps*eps, in order to avoid the zero result
end