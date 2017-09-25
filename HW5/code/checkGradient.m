%% This program serves as gradient checker to debug backward propagation.
clear
%% Prepare sample. 
eps = 1e-4;
load('../data/nist26_train.mat')
lucky = randi(size(train_data,1));
X = train_data(lucky,:);
X = X';
Y = train_labels(lucky,:);
Y = Y';
[W, b] = InitializeNetwork([1024 400 26]);
disp('This demo neural network has 3 layers with nodes of 1024-400-26.')
%% First layer in W. 
disp('Checking W in first layer (5 tests)...')
for cnt = 1:5
    lucky = randi(size(W{1},1)*size(W{1},2));
    W_plus = W;
    W_plus{1}(lucky) = W_plus{1}(lucky) + eps;
    W_minus = W;
    W_minus{1}(lucky) = W_minus{1}(lucky) - eps;
    [~, loss1] = ComputeAccuracyAndLoss(W_plus, b, X', Y');
    [~, loss2] = ComputeAccuracyAndLoss(W_minus, b, X', Y');
    right_side = (loss1-loss2)/(2*eps);     
    [~, act_a, act_h] = Forward(W, b, X);
    [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h);
    left_side = grad_W{1}(lucky);
    disp(['Difference is ' num2str(left_side-right_side)]);    
end

%% Second layer in W. 
disp('Checking W in second layer (5 tests)...')
for cnt = 1:5
    lucky = randi(size(W{2},1)*size(W{2},2));
    W_plus = W;
    W_plus{2}(lucky) = W_plus{2}(lucky) + eps;
    W_minus = W;
    W_minus{2}(lucky) = W_minus{2}(lucky) - eps;
    [~, loss1] = ComputeAccuracyAndLoss(W_plus, b, X', Y');
    [~, loss2] = ComputeAccuracyAndLoss(W_minus, b, X', Y');
    right_side = (loss1-loss2)/(2*eps); 
    [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h);
    left_side = grad_W{2}(lucky);
    disp(['Difference is ' num2str(left_side-right_side)]);    
end

%% First layer in b. 
disp('Checking b in first layer (5 tests)...')
for cnt = 1:5
    lucky = randi(size(b{1},1)*size(b{1},2));
    b_plus = b;
    b_plus{1}(lucky) = b_plus{1}(lucky) + eps;
    b_minus = b;
    b_minus{1}(lucky) = b_minus{1}(lucky) - eps;   
    [~, loss1] = ComputeAccuracyAndLoss(W, b_plus, X', Y');
    [~, loss2] = ComputeAccuracyAndLoss(W, b_minus, X', Y');
    right_side = (loss1-loss2)/(2*eps); 
    [output, act_a, act_h] = Forward(W, b, X);
    [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h);
    left_side = grad_b{1}(lucky);
    disp(['Difference is ' num2str(left_side-right_side)]);    
end

%% Second layer in b. 
disp('Checking b in second layer (5 tests)...')
for cnt = 1:5
    lucky = randi(size(b{1},1)*size(b{1},2));
    b_plus = b;
    b_plus{1}(lucky) = b_plus{1}(lucky) + eps;
    b_minus = b;
    b_minus{1}(lucky) = b_minus{1}(lucky) - eps;
    [~, loss1] = ComputeAccuracyAndLoss(W, b_plus, X', Y');
    [~, loss2] = ComputeAccuracyAndLoss(W, b_minus, X', Y');
    right_side = (loss1-loss2)/(2*eps);   
    [output, act_a, act_h] = Forward(W, b, X);
    [grad_W, grad_b] = Backward(W, b, X, Y, act_a, act_h);
    left_side = grad_b{1}(lucky);
    disp(['Difference is ' num2str(left_side-right_side)]);    
end







