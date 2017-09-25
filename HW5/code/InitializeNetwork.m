function [W, b] = InitializeNetwork(layers)
%%  InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.
    NumOfLayer = length(layers)-1;    % Number of layers in neural network. 
    if NumOfLayer <= 1
        error('At least three layers (Input hidden and output)!')
    end
    W = cell(NumOfLayer,1);
    b = cell(NumOfLayer,1);
    for cnt = 1:NumOfLayer
%         W{cnt} = rand(layers(cnt),layers(cnt+1));
%         b{cnt} = rand(1,layers(cnt+1));       
        W{cnt} = normrnd(0,0.1,[layers(cnt), layers(cnt+1)]);
        b{cnt} = normrnd(0,0.1,[1,layers(cnt+1)]);
    end
end
