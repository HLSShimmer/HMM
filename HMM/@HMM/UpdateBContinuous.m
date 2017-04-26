function Bupdated = UpdateBContinuous(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% update the GMM struct, used in each iteration of baum-welch algo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj          input&output    object
% Bupdated     output          updated GMM struct
%% declare some variables
observeLength = length(obj.observeSequence);                %length of  observe sequence
stateNum = size(obj.HMMstruct.B.mu,1);                      %state number
gaussianDimension = size(obj.observeSequence,2);            %dimension of each gaussian distribution , i.e. the dimension of observance
mixtureNum = obj.HMMstruct.B.mixtureNum;                    %mixture number
weights = zeros(stateNum,mixtureNum);                       %weights
mu = cell(stateNum,1);                                      %mean value of GMM for each hidden state
sigma = cell(stateNum,1);                                   %covariance of GMM for each hidden state
PDF = cell(stateNum,1);                                     %pdf of GMM for each hidden state
gammaSaparate = zeros(stateNum,mixtureNum,observeLength);   %gamma value for each different gaussian mixture component
%% calculate gammaSaparate
for i=1:observeLength
    %get the pdf value of different gaussian mixture component of different state
    temp = zeros(stateNum,mixtureNum);
    for j=1:stateNum
        for k=1:mixtureNum
            temp(j,k) = mvnpdf(obj.observeSequence(i,:),obj.HMMstruct.B.mu{j}(k,:),obj.HMMstruct.B.sigma{j}(:,:,k));
        end
    end
    %calculate current gammaSaparate
    gammaSaparate(:,:,i) = repmat(obj.gamma(i,:).'/sum(obj.gamma(i,:)),1,mixtureNum);
    temp = obj.HMMstruct.B.weights.*temp;
    temp = temp./repmat(sum(temp,2),1,mixtureNum);
    gammaSaparate(:,:,i) = gammaSaparate(:,:,i).*temp;
end
%% update
for i=1:stateNum
    mu{i} = zeros(mixtureNum,gaussianDimension);
    sigma{i} = zeros(gaussianDimension,gaussianDimension,mixtureNum);
    for j=1:mixtureNum
        %weights
        weights(i,j) = sum(gammaSaparate(i,j,:))/sum(sum(gammaSaparate(i,:,:)));
        %mean
        temp = repmat(reshape(gammaSaparate(i,j,:),observeLength,1),1,gaussianDimension);
        mu{i}(j,:) = sum(temp.*obj.observeSequence,1)/sum(gammaSaparate(i,j,:));
        %covariance
        for t=1:observeLength
            sigma{i}(:,:,j) = sigma{i}(:,:,j) + gammaSaparate(i,j,t).*(obj.observeSequence(t,:)-mu{i}(j,:)).'*(obj.observeSequence(t,:)-mu{i}(j,:));
        end
        sigma{i}(:,:,j) = sigma{i}(:,:,j)/sum(gammaSaparate(i,j,:));
    end
end
for i=1:stateNum
    PDF{i} = gmdistribution(mu{i},sigma{i},weights(i,:));
end
Bupdated.mixtureNum = mixtureNum;
Bupdated.weights = weights;
Bupdated.mu = mu;
Bupdated.sigma = sigma;
Bupdated.PDF = PDF;