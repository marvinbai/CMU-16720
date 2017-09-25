function [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h)
%% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_a' and 'act_h' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'
    NumOfLayer = size(W,1);
%     C = size(W{end},2);    % Output dimension.
    grad_W = cell(NumOfLayer,1);
    grad_b = cell(NumOfLayer,1);
    
    for cnt = NumOfLayer:-1:1
        if cnt == NumOfLayer    % Output node.  
            h_this = act_h{cnt}; % // 1x3.
            dLda_this = h_this'-Y;    % // 3x1.
            dzdw = act_h{cnt-1};      % // 1x4.
            grad_W{cnt} = (dLda_this*dzdw)';     % // 4x3.
            grad_b{cnt} = dLda_this';    % // 1x3.
        elseif cnt == 1
            dLda_next = dLda_this;
            tmp = dLda_next'*W{cnt+1}'; % // 1x4.
            tmp = tmp'; % //4x1.
            a_this = act_a{cnt};    % // 1x4.
            h_prev = X';    % // 1x5.
            dLda_this = tmp.*(sigmoid(a_this').*(1-sigmoid(a_this')));  % // 4x1.
            grad_W{cnt} = dLda_this*h_prev; % // 4x5.
            grad_W{cnt} = grad_W{cnt}'; % // 5x4.
            grad_b{cnt} = dLda_this';   % // 1x4.
        else
            dLda_next = dLda_this;
            tmp = dLda_next'*W{cnt+1}';
            tmp = tmp';
            a_this = act_a{cnt};
            h_prev = act_h{cnt-1};
            dLda_this = tmp.*(sigmoid(a_this').*(1-sigmoid(a_this')));
            grad_W{cnt} = dLda_this*h_prev;
            grad_W{cnt} = grad_W{cnt}';
            grad_b{cnt} = dLda_this';
        end
    end
    

end

function [y] = sigmoid(x)
    y = sigmf(x,[1 0]); 
end

