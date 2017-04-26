function B = GenerateBContinuous(N,M,observeDimension)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% randomly generate GMM struct %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N       input      stateNum
% M       input      mixtureNum
% B       output     GMM struct
%% declare some variances
weights = zeros(N,M);          %��״̬��Ϸֲ���Ȩ��
mu = cell(N,1);                %ÿ��״̬�Ļ�Ϸֲ��ľ�ֵ
sigma = cell(N,1);             %ÿ��״̬�Ļ�Ϸֲ���Э����
PDF = cell(N,1);               %ÿ��״̬�Ļ�Ϸֲ��ĸ����ܶ�
%% generate weights
for i=1:N
    weights(i,:) = rand(1,M);
    weights(i,:) = weights(i,:)./sum(weights(i,:));
end
%% mean value
for i=1:N
    mu{i} = -1 + 2*rand(M,observeDimension);
end
%% covariance
for i=1:N
    sigma{i} = zeros(observeDimension,observeDimension,M);
    for j=1:M
        sigma{i}(:,:,j) = 1.5*rand(observeDimension,observeDimension);
    end
end
%% pdf of GMM
for i=1:N
    PDF{i} = gmdistribution(mu{i},sigma{i},weights(i,:));
end
%% output
B.mixtureNum = M;
B.weights = weights;
B.mu = mu;
B.sigma = sigma;
B.PDF = PDF;