function [HMMstruct,stateSequence,haltState] = InitializeWalkingModel(data,stateNum,para)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% get an initial HMM model by KMeans with the input data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%data                input           raw data of walking
%stateNum            input           the number of state
%HMMstruct           output          initialized HMM model
%stateSequence       output          re-arranged state sequence from KMeans method
%% declare some values
signalNum = size(data,2);      %% the number of different signals
dataLength = size(data,1);     %% length of data, number of samples
windowSize = 13;               %% window size of determining the current state or next state
if dataLength < 2*windowSize
    error('the volume of data if too short!')
end
jointProbabilityKmeans = zeros(stateNum,stateNum);
jointProbability = zeros(stateNum,stateNum);
transitProbability = zeros(stateNum,stateNum);
stationaryProbabilityKmeans = zeros(1,stateNum);
stationaryProbability = zeros(1,stateNum);
stateSequence = zeros(dataLength,1);
%% initial classification by Kmeans
stateSequenceKmeans = kmeans(data,stateNum);
%% calculate joint/transit/stationary probability
for i=windowSize:dataLength-windowSize
    %get the regarded current state in the window size
    temp = tabulate(stateSequenceKmeans(i-windowSize+1:i));
    [~,index] = max(temp(:,2));
    stateCurrent = temp(index,1);
    %get the regarded next state in the window size
    temp = tabulate(stateSequenceKmeans(i+1:i+windowSize));
    [~,index] = max(temp(:,2));
    stateNext = temp(index,1);
    %dispose for joint and stationary probability
    stationaryProbabilityKmeans(stateCurrent) = stationaryProbabilityKmeans(stateCurrent) + 1;
    jointProbabilityKmeans(stateCurrent,stateNext) = jointProbabilityKmeans(stateCurrent,stateNext) + 1;
end
temp = tabulate(stateSequenceKmeans(end-windowSize+1:end));
[~,index] = max(temp(:,2));
stateCurrent = temp(index,1);
stationaryProbabilityKmeans(stateCurrent) = stationaryProbabilityKmeans(stateCurrent) + 1;
%% divide the summation number
stationaryProbabilityKmeans = stationaryProbabilityKmeans./(dataLength-2*windowSize + 2);
jointProbabilityKmeans = jointProbabilityKmeans./(dataLength-2*windowSize + 1);
transitProbabilityKmeans = jointProbabilityKmeans./repmat(stationaryProbabilityKmeans.',1,stateNum);
%% searching for the state order
stateSeries = 1:stateNum;
stateTransferOrder = zeros(stateNum,1);
[~,stateTransferOrder(1)]=min(stationaryProbabilityKmeans);     %start with the minimum possibility state, it's better
stateSeries(stateSeries==stateTransferOrder(1)) = [];           %when find a correct state order, delete the state in stateSeries
for i = 1:stateNum-1
    temp = transitProbabilityKmeans(stateTransferOrder(i),stateSeries);
    [~,index] = max(temp);
    stateTransferOrder(i+1) = stateSeries(index);
    stateSeries(stateSeries==stateTransferOrder(i+1)) = [];     %when find a correct state order, delete the state in stateSeries
end
%% re-arrange the state according to the order, also change the joint/transit/stationary probability
for i=1:stateNum
    stateSequence(stateSequenceKmeans==stateTransferOrder(i)) = i;
    stationaryProbability(i) = stationaryProbabilityKmeans(stateTransferOrder(i));
end
for i=1:stateNum
    for j=1:stateNum
        jointProbability(i,j) = jointProbabilityKmeans(stateTransferOrder(i),stateTransferOrder(j));
        transitProbability(i,j) = transitProbabilityKmeans(stateTransferOrder(i),stateTransferOrder(j));
    end
end
%% calculate halt state
averageABS =zeros(stateNum,1);
for i=1:stateNum
    temp = data(stateSequence==i,:);
    for j=1:signalNum
        averageABS(i) = averageABS(i) + abs(mean(temp(:,j)));
    end
end
[~,index] = min(averageABS);
haltState = index;
%% genrate HMM struct
selectedSignal = para.selectedSignal;               %the index of selected signal
HMMstruct.N = stateNum;
HMMstruct.M = 1;
HMMstruct.observePDFType = 'CONTINUOUS_GAUSSIAN';   %% CONTINUOUS_GAUSSIAN, DISCRET
HMMstruct.transitMatrixType = 'LEFT2RIGHT';         %% NORMAL, LEFT2RIGHT
HMMstruct.A = transitProbability;
HMMstruct.B.mixtureNum = 1;
HMMstruct.B.weights = ones(stateNum,1);
HMMstruct.B.mu = cell(stateNum,1);
HMMstruct.B.sigma = cell(stateNum,1);
HMMstruct.B.PDF = cell(stateNum,1);
for i=1:stateNum
    HMMstruct.B.mu{i} = mean(data(stateSequence==i,selectedSignal));
    HMMstruct.B.sigma{i} = zeros(1,1,1);
    HMMstruct.B.sigma{i}(1,1,1) = var(data(stateSequence==i,selectedSignal));
    HMMstruct.B.PDF{i} = gmdistribution(HMMstruct.B.mu{i},HMMstruct.B.sigma{i},HMMstruct.B.weights(i,:));
end
HMMstruct.initialStateProbability = stationaryProbability;