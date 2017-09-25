function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
    H = size(wordMap,1);                                                    % Height of wordMap.
    W = size(wordMap,2);                                                    % Width of wordMap. 
    L = layerNum - 1;                                                       % 0 to L.
    h = [];
    for l = 0:L
        if l == 0
            h = getImageFeatures(wordMap, dictionarySize);
            h = h*2^(-L);
        else
            row = repmat(H/2^l,1,2^l);
            row(2:end) = round(row(2:end));
            row(1) = H-sum(row(2:end));
            
            col = repmat(W/2^l,1,2^l);
            col(2:end) = round(col(2:end));
            col(1) = W-sum(col(2:end));
            
            WP_cell = mat2cell(wordMap,row,col);
            h_tmp = [];
            for cnt = 1:numel(WP_cell)
                h_tmp = [h_tmp; getImageFeatures(WP_cell{cnt}, dictionarySize)];                
            end
            h_tmp = h_tmp/4^l;
            h_tmp = h_tmp*2^(l-L-1);
            h = [h; h_tmp];            
        end        
        
    end
    
end