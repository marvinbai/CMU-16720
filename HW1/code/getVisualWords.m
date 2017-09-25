function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here
    H = size(img,1);                                                        % Height of the image.
    W = size(img,2);                                                        % Width of the image. 
    filter_response = extractFilterResponses(img,filterBank);               % filter_response is HW x 3F. 
    dictionary = dictionary';                                               % Transpose dictionary to K x 3F.
    D = pdist2(filter_response,dictionary);
    [~,dictIdx] = min(D,[],2);
    wordMap = reshape(dictIdx',H,W);
    
end
