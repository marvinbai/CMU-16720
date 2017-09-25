function [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate)
%% [W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate) computes and returns the
% new network parameters 'W' and 'b' with respect to the old parameters, the
% gradient updates 'grad_W' and 'grad_b', and the learning rate.
    W_new = cell(size(W));
    b_new = cell(size(b));
    for cnt = 1:length(W)
        W_new{cnt} = W{cnt} - learning_rate * grad_W{cnt};
        b_new{cnt} = b{cnt} - learning_rate * grad_b{cnt};       
    end
    W = W_new;
    b = b_new;

end

