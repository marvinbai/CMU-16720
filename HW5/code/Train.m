function [W, b] = Train(W, b, train_data, train_label, learning_rate)
%% [W, b] = Train(W, b, train_data, train_label, learning_rate) trains the network
% for one epoch on the input training data 'train_data' and 'train_label'. This
% function should returned the updated network parameters 'W' and 'b' after
% performing backprop on every data sample.


% This loop template simply prints the loop status in a non-verbose way.
% Feel free to use it or discard it

%% Shuffle Data. 
order = randperm(size(train_data,1));

%% Train.
cnt = 0;
for i = order
    cnt = cnt + 1;
    X = train_data(i,:);
    Y = train_label(i,:);
    X = X';
    Y = Y';
    [~, act_a, act_h] = Forward(W, b, X);
    [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h);
    [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);
%     if mod(cnt, 500) == 0
%         fprintf('Done %.2f %%', cnt/size(train_data,1)*100)
%         fprintf('\n')
%     end
end

end
