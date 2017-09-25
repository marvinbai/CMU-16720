function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
%% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.
% labels is D x C.
% Assuming labels has form of [0 1 0 0; 1 0 0 0; 0 0 0 1; ...]
% data is D x N, where D is number of data, and N is input dimension.     
    [outputs] = Classify(W, b, data);   % D x C, where D is number of data and C is output dimension. 
    [~, fx_hard] = max(outputs,[],2);    % fx_hard is D x 1. 
    [~, label_hard] = max(labels,[],2);  % D x 1.
    accuracy = sum(fx_hard==label_hard)/length(label_hard);
    if sum(sum(outputs==0)) ~= 0
        disp('Outputs has zero values!')
    end
    outputs(outputs==0) = 1e-12;    % Prevent the occurence of log(0).
    loss = -sum(sum(labels.*log(outputs),2));
    
end
