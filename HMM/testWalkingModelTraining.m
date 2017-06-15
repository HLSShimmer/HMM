clear all;clc;close all;
%% 载入数据，基本参数
%data
load DataBase_WalkArround_10min_1_Disposed footMotion
data = [footMotion.Accel_WideRange,footMotion.Gyro];
dataLength = size(data,1);
signalNum = size(data,2);
selectedSignal = 4;
para.dt = 1/100.51;             %sample step
%filter paras
para.h1 = 8*para.dt;
para.r = 8000;
para.windowSize = 3;
filterMode = 2;
%HMM struct paras
stateNum = 4;                %state number
observeDimension = 1;        %dimension of observance
%% 滤波
dataFiltered = FilterData(data,para.dt,filterMode,para);
% tSpan = 15000:1:19000;
% for i=1:signalNum
%     figure(i)
%     plot(tSpan,dataFiltered(tSpan,i),'r');
%     hold on
%     plot(tSpan,data(tSpan,i),'b');
% end
observeSequence = dataFiltered(:,selectedSignal);
%% generate HMM struct
[HMMstruct,stateSequenceKmeans,haltState] = InitializeWalkingModel(dataFiltered,stateNum);
%% HMM model optimization
model = HMM();
model = model.SetModel(HMMstruct);
%% optimal para settings
optPara.maxIter = 15;
optPara.ErrorTolerance = 0.01;
optPara.ChangingTolerance = 1.7e-5;
model = model.SetOptPara(optPara);
%% optimize model
model = model.SetModel(HMMstruct);
tic
[model,HMMstructEstimated,stateEstimated,flag] = model.ModelOptimization(observeSequence);
toc
%% plot result
tSpan = 10000:11000;
figure(1)
subplot(311)
plot(tSpan,observeSequence(tSpan),'k')
hold on
plot(tSpan,data(tSpan,selectedSignal),'b--')
legend('filtered data','original data')
title('Data of Gyro X axis')
subplot(312)
plot(tSpan,stateSequenceKmeans(tSpan),'r')
title('state classified by kmeans')
subplot(313)
plot(tSpan,stateEstimated(tSpan),'b')
title('state classified by HMM')
tSpan = 13000:13500;
figure(2)
subplot(311)
plot(tSpan,observeSequence(tSpan),'k')
hold on
plot(tSpan,data(tSpan,selectedSignal),'b--')
legend('filtered data','original data')
title('Data of Gyro X axis')
subplot(312)
plot(tSpan,stateSequenceKmeans(tSpan),'r')
title('state classified by kmeans')
subplot(313)
plot(tSpan,stateEstimated(tSpan),'b')
title('state classified by HMM')
tSpan = 33000:33500;
figure(3)
subplot(211)
plot(tSpan,observeSequence(tSpan),'k')
hold on
plot(tSpan,data(tSpan,selectedSignal),'b--')
legend('filtered data','original data')
title('Data of Gyro X axis')
subplot(212)
plot(tSpan,stateEstimated(tSpan),'b','LineWidth',2)
axis([tSpan(1) tSpan(end) 0 5])
title('state classified by HMM')
figure(4)
plot(observeSequence,'k')
hold on
plot(data(:,selectedSignal),'b--')
legend('filtered data','original data')