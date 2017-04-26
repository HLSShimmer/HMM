function gamma = GetGamma(obj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% probability of state at n given by the entire observe sequence
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% obj             input&output   object
% gamma           output         the probabilitym, i.e. the backward result
%% 
gamma = obj.gamma;