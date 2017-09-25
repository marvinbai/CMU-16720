function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');
	load('../dat/traintest.mat');

	% TODO create train_features
    K = 200;                                                                % Dictionary size. 
    NumOfLayer = 3;                                                         % Number of layers of spatial pyramid matching. 
    NumOfTrain = length(train_labels);
    train_features = zeros(K*(4^NumOfLayer-1)/3,NumOfTrain);                    % Histogram of training images. 
     
    for cnt = 1:length(train_imagenames)
        tmp = train_imagenames{cnt};
        tmp(end-2:end) = 'mat';
        load(['../dat/' tmp]);
        train_features(:,cnt) = getImageFeaturesSPM(NumOfLayer,wordMap,K);
    end    
    cd ../matlab

	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');

end