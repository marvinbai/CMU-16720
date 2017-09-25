function [compareA, compareB] = makeTestPattern(patchWidth, nbits)  
%% 
% input
% patchWidth - the width of the image patch (usually 9)
% nbits - the number of tests n in the BRIEF descriptor
% output
% compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors. 
%
% Run this routine for the given parameters patchWidth = 9 and n = 256 and save the results in testPattern.mat.

% This implementation takes the 2nd approach in the paper, which is X,Y~iid Gaussian(0,patchWidth^2/25).  
    
    if rem(patchWidth,2) ~= 1
        error('patchWidth must be an odd value!')
    end
    mu = (patchWidth+1)/2;                                                  % Mean of Gaussian in 1D.
    sigma = patchWidth/5;                                                   % Sigma of Gaussian in 1D. 
    rng('shuffle')
    X = round(normrnd(mu,sigma,[nbits,1]));
    rng('shuffle')
    Y = round(normrnd(mu,sigma,[nbits,1]));
    X(X>9)=9;
    X(X<1)=1;
    Y(Y>9)=9;
    Y(Y<1)=1;
    compareA = (X-1)*patchWidth + Y;
    X = round(normrnd(mu,sigma,[nbits,1]));
    Y = round(normrnd(mu,sigma,[nbits,1]));
    X(X>9)=9;
    X(X<1)=1;
    Y(Y>9)=9;
    Y(Y<1)=1;    
    compareB = (X-1)*patchWidth + Y;
    
    
end