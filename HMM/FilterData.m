function dataFiltered = FilterData(data,dt,mode,para)
%%%%%%%%%%%%%%%%%%%%%%
%%%%% filter data %%%%
%%%%%%%%%%%%%%%%%%%%%%
% data          input    data, each column is a data serie
% dt            input    sample step
% mode          input    method of filtering£¬1-TD,2-average
% para          input    some parameters be used depending on method mode
% dataFiltered  output   result of data filtering

%% data dimension
dataNum = size(data,1);
dataCols = size(data,2);
%% filter
dataFiltered = zeros(size(data));
if mode == 1          % TD filter
    for i=1:dataCols
        X1 = zeros(size(data,1),1);
        X2 = zeros(size(data,1),1);
        x1 = data(1,i);x2 = 0;
        X1(1) = data(1,i);
        for j=2:dataNum
            [x1,x2] = TD_Filter(x1,x2,data(j,i),dt,para.h1,para.r);
            X1(j) = x1;
            X2(j) = x2;
        end
        dataFiltered(:,i) = X1;
    end
elseif mode == 2     %average smooth
        windowSize = para.windowSize;  %odd
        for i= 1:dataNum
            if i<=(windowSize-1)/2
                dataFiltered(i,:) = mean(data(1:windowSize,:));
            elseif i>=dataNum-(windowSize-1)/2+1
                dataFiltered(i,:) = mean(data(end-windowSize+1:end,:));
            else
                dataFiltered(i,:) = mean(data(i-(windowSize-1)/2:i+(windowSize-1)/2,:));
            end
        end
end