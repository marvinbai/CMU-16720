function [outputs] = Classify(W, b, data)
% [predictions] = Classify(W, b, data) should accept the network parameters 'W'
% and 'b' as well as an DxN matrix of data sample, where D is the number of
% data samples, and N is the dimensionality of the input data. This function
% should return a vector of size DxC of network softmax output probabilities.
%% 'data' is D x N. However, 'Forward.m' eats X as N x 1. 
    tmp = W{end};
    C = size(tmp,2);    % Output dimension.
    outputs = zeros(C, size(data,1));
    for cnt = 1:size(data,1)
        [outputs(:,cnt),~,~] = Forward(W, b, data(cnt,:)');
    end
    outputs = outputs'; % Change to D x C. 
end
