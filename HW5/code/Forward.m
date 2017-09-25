function [output, act_a, act_h] = Forward(W, b, X)
%% [OUT, act_h, act_a] = Forward(W, b, X) performs forward propogation on the
% input data 'X' uisng the network defined by weights and biases 'W' and 'b'
% (as generated by InitializeNetwork(..)).
% This function should return the final softmax output layer activations in OUT,
% as well as the hidden layer pre activations in 'act_a', and the hidden layer post
% activations in 'act_h'.
% X is N x 1.
    if length(b) ~= length(W)
        error('Dimension of weights and bias does not match!');
    end
    NumOfLayer = length(W);     % Number of layers.
    tmp = W{end};
    C = size(tmp,2);    % Output dimension.     
%     N = length(X);  % Input dimension. 
    act_a = cell(NumOfLayer,1);   % Pre-activation.
    act_h = cell(NumOfLayer,1);   % Post-activation. 
    for cnt = 1:NumOfLayer-1
        if cnt == 1
            act_a{cnt} = X' * W{cnt} + b{cnt};   % 1 x T(cnt).
        else
            act_a{cnt} = act_h{cnt-1} * W{cnt} + b{cnt};   % 1 x T(cnt).
        end
        act_h{cnt} = sigmf(act_a{cnt},[1 0]);   % 1 x T(cnt).        
    end
    act_a{NumOfLayer} = act_h{NumOfLayer-1} * W{NumOfLayer} + b{NumOfLayer}; 
    output = zeros(C,1);
    for cnt = 1:C
        tmp = act_a{end};   % 1 x C.
        output(cnt) = exp(tmp(cnt))/sum(exp(tmp));  % Softmax. 
    end
    act_h{NumOfLayer} = output';
end
