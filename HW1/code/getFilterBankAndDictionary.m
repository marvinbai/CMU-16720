function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();

    % TODO Implement your code here
    alpha = 100;
    K = 200;
    
    F = length(filterBank);                                                 % Size of filterBank;
    T = length(imPaths);                                                    % Number of training images.
    FR = zeros(alpha*T,3*F);                                                % Total filter responses for dictionary.
    cnt_FR = 1;
    for cnt_img = 1:length(imPaths)
        img = imread(imPaths{cnt_img});
        H = size(img,1);
        W = size(img,2);
        filterResponses = extractFilterResponses(img, filterBank);
        index_selected = randperm(H*W,alpha);
        filterResponses = filterResponses(index_selected,:);
        FR(cnt_FR:cnt_FR+alpha-1,:) = filterResponses;
        cnt_FR = cnt_FR + alpha;
    end    
    [~,dictionary] = kmeans(FR,K,'EmptyAction','drop');
    dictionary = dictionary';
end
