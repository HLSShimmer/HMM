function [x1,x2] = TD_Filter(x1_,x2_,v,h,h1,r)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% TD filter£¬single step %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% x1_,x2_        input       previous state, x1_£ºtracking £»x2_£ºdifferential
% v              input       data input of current time step
% h              input       integration step size
% h1             input       for getting good result of filtering, but bigger value leads to phase delay in x1
% r              input       determine the speed of tracking, bigger leads to faster, but also will be biased by noise
% x1,x2          output      tracking & differential signal at current time step
%% calculation
x1 = x1_ + h*x2_;
delta = h1*r;
delta1 = h1*delta;
y = x1_ - v + h1*x2_;
if abs(y)>=delta1
    g = x2_ + sign(y)*(sqrt(8*r*abs(y)+delta^2)-delta)/2;
else
    g = x2_ + y/h1;
end
if abs(g)>=delta
    sat = sign(g);
else
    sat = g/delta;
end
fst = -r*sat;
x2 = x2_ + h*fst;