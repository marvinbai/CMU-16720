function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../dat/traintest.mat');

	% TODO Implement your code here
    NumOfTest = length(test_labels);                                        % Number of test samples. 
    K = 200;
    NumOfLayer = 3;
    
    conf = zeros(8,8);
    
    for cnt = 1:NumOfTest
        tmp = test_imagenames{cnt};
        tmp(end-2:end) = 'mat';
        load(['../dat/' tmp]);
        wordHist = getImageFeaturesSPM(NumOfLayer, wordMap, K);        
        HistSim = distanceToSet(wordHist, train_features);
        [~,index_train] = max(HistSim);
        conf(test_labels(cnt),train_labels(index_train)) = conf(test_labels(cnt),train_labels(index_train)) + 1; 
    end
    accuracy = trace(conf)/sum(conf(:));
    disp(['Accuracy is ' num2str(accuracy)]);
end