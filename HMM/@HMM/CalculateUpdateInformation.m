function [A,B,initialStateProbability] = CalculateUpdateInformation(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Calculate Update of A, B, ¦Ð %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obj                       input       object
%A                         output      updated transition matrix
%B                         output      updated discret observe distribute or GMM struct
%initialStateProbability   output      updated initialState probability
%% declare some variables
N = obj.HMMstruct.N;
M = obj.HMMstruct.M;
observeLength = length(obj.observeSequence);
initialStateProbability = zeros(1,N);
A = zeros(N,N);
B = zeros(N,M);
%% Update A
if strcmp(obj.HMMstruct.transitMatrixType,'NORMAL')
    for i=1:N
        for j=1:N
            A(i,j) = sum(obj.ksai(i,j,:))/sum(obj.gamma(1:observeLength-1,i));
        end
    end
elseif strcmp(obj.HMMstruct.transitMatrixType,'LEFT2RIGHT')
    DELTA = zeros(4,1);
    for i=1:N-1
        DELTA(i) = sum(obj.ksai(i,i+1,:))/(sum(obj.ksai(i,i,:))+sum(obj.ksai(i,i+1,:)));
        A(i,i) = 1 - DELTA(i);
        A(i,i+1) = DELTA(i);
    end
    DELTA(N) = sum(obj.ksai(N,1,:))/(sum(obj.ksai(N,N,:))+sum(obj.ksai(N,1,:)));
    A(N,N) = 1 - DELTA(N);
    A(N,1) = DELTA(N);
end
%% Update B
if strcmp(obj.HMMstruct.observePDFType,'DISCRET')
    for i=1:N
        for j=1:M
            B(i,j) = sum(obj.gamma(observeSequence==j,i))/sum(obj.gamma(:,i));
        end
    end
elseif strcmp(obj.HMMstruct.observePDFType,'CONTINUOUS_GAUSSIAN')
    B = obj.UpdateBContinuous();
end
%% Update ¦Ð
for i=1:N
    initialStateProbability(i) = obj.gamma(1,i)/sum(obj.gamma(1,:));
end