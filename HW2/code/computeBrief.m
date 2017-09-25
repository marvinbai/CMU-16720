function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB)
%% Compute Brief feature
% input
% im - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors
%
% output
% locs - an m x 3 vector, where the first two columns are the image coordinates of keypoints and the third column is 
%		 the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of valid descriptors in the image and will vary
    % This function is not good since patchwidth should be in the input. 
    % Here we assume that the patch width is 9. 
    patchWidth = 9;                                                         % patchWidth must be an odd value. 
    if length(compareA) ~= length(compareB)
        error('Pattern number does not match!')
    end
    %% First check if the interesting points are valid to make a patch (not too close to edges).
    checker = zeros(size(locsDoG,1),1);                                     % Mark 1 if the point is valid to make a patch, 0 if not.
    for cnt = 1:length(checker)
        x = locsDoG(cnt,1);
        y = locsDoG(cnt,2);
        if x<(patchWidth+1)/2 || (x+(patchWidth-1)/2)>size(im,2) || y<(patchWidth+1)/2 || (y+(patchWidth-1)/2)>size(im,1)
            checker(cnt) = 0;
        else
            checker(cnt) = 1;
        end
    end
    locs = locsDoG;
    locs(checker==0,:) = [];
    %% Calculate descriptor test. 
    [DoGPyramid, ~] = createDoGPyramid(GaussianPyramid, levels);
    desc = zeros(size(locs,1),length(compareA));
    for cnt_pt = 1:size(locs,1)                                             % Loop over each valid point. 
        x = locs(cnt_pt,1);
        y = locs(cnt_pt,2);
        z = locs(cnt_pt,3);
%         pat = im(y-(patchWidth-1)/2:y+(patchWidth-1)/2,...                  
%             x-(patchWidth-1)/2:x+(patchWidth-1)/2);                         % patchWidth x patchWidth pattern. 
        pat = DoGPyramid(y-(patchWidth-1)/2:y+(patchWidth-1)/2,...                  
            x-(patchWidth-1)/2:x+(patchWidth-1)/2, z); 
        tmp = pat(compareA) - pat(compareB);
        index_1 = tmp<0;
        index_0 = tmp>=0;
        tmp(index_1) = 1;
        tmp(index_0) = 0;
        desc(cnt_pt,:) = tmp';
    end
    
    
    
end