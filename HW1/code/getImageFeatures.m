function [h] = getImageFeatures(wordMap, dictionarySize)
% Compute histogram of visual words
% Inputs:
% 	wordMap: WordMap matrix of size (h, w)
% 	dictionarySize: the number of visual words, dictionary size
% Output:
%   h: vector of histogram of visual words of size dictionarySize (l1-normalized, ie. sum(h(:)) == 1)

	% TODO Implement your code here
	wordMap = reshape(wordMap,1,size(wordMap,1)*size(wordMap,2));           % Change wordMap from H x W into 1 x HW.
    h = hist(wordMap,[1:dictionarySize])';                                  % h is dictionarySize x 1 (column vector). 
    h = h/sum(h);                                                           % L1 normalized. 
    
	assert(numel(h) == dictionarySize);
end