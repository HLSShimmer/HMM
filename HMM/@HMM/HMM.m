classdef HMM
    %% public member variable
    properties
        
    end
    %% private member variable
    properties (Access = 'private')
        HMMstruct;                  %HMM struct
        optPara;                    %optimization paras
        observeSequence;            %observe sequence
        alpha;                      %joint probability of observe from 1 to n and state at n given by the model
        beta;                       %probability of observance from n+1 to N given by state at n and the model
        gamma;                      %probability of state at n given by the entire observe sequence
        ksai;                       %probability of state at n and n+1 given by the entire observe sequence
        observeSequenceProbability; %probability or pdf of the observance at n given by the state
    end
    %% constructor
    methods
        function obj = HMM()
            obj.HMMstruct = struct('N',0,'M',0,'A',0,'B',0,'initialStateProbability',0,'observePDFType',0,'transitMatrixType',0);
            obj.optPara = struct('maxIter',1000,'tolerance',1e-3);
            obj.observeSequence = [];
            obj.alpha = [];
            obj.beta = [];
            obj.gamma = [];
            obj.ksai = [];
            obj.observeSequenceProbability = [];
        end
    end
    %% public method
    methods
        %set model function
        obj = SetModel(obj,HMMstruct);
        %get model function
        HMMstruct = GetModel(obj);
        %model optimization function
        [obj,HMMstruct,stateEstimated,flag,residual] = ModelOptimization(obj,observeSequence,stateSequence);
        %most likely individual state in timeIndex given by the model and observe sequence
        [stateIndex,stateProbability] = MostLikelyIndividualState(obj,observeSequence,timeIndex);
        %get alpha function
        alpha = GetAlpha(obj);
        %get beta function
        beta = GetBeta(obj);
        %get gamma function
        gamma = GetGamma(obj);
        %get kesai function
        ksai = GetKsai(obj);
        %generate observe sequence function
        [stateSequence,observeSequence] = GenerateObserveSequence(obj,observeLength);
        %optimization paras setting function
        obj = SetOptPara(obj,optPara);
        %calculate&get forward backward result
        [forwardResult,backwardResult] = GetForwardBackward(obj,observeSequence);
        %get observe discrete probability distribution or pdf for each state
        observePDF = GetObservePDF(obj,observeSpan);
        %get stationary probability of each state
        stationaryProbability = GetStationaryProbability(obj);
        %get joint probability between two state in consecutive
        jointProbability = GetJointProbability(obj);
    end
    %% private methods
    methods (Access = 'private')
        %calculate alpha
        obj = CalculateAlpha(obj);
        %calculate beta
        obj = CalculateBeta(obj);
        %forward and bcanward procedure
        obj = ForwardBackwardProcedure(obj);
        obj = ForwardBackwardProcedure2(obj);
        %given the model and observe sequence, get the probability when state is i at time n
        obj = CalculateGamma(obj);
        %get probability or pdf of the observance at n given by the state
        observeSequenceProbability = GetObserveProbability(obj,stateIndex,timeIndex);
        %calculate update information, A, B, ¦Ð
        [A,B,initialStateProbability] = CalculateUpdateInformation(obj);
        %update the GMM struct, used in each iteration of baum-welch algo
        B = UpdateBContinuous(obj);
    end
end