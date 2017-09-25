function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
%%
% input
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
% output
% bestH - homography model with the most inliers found during RANSAC
    p1 = zeros(2,size(matches,1));
    p2 = zeros(2,size(matches,1));
    for cnt = 1:size(matches,1)
        p1(:,cnt) = locs1(matches(cnt,1),1:2)';
        p2(:,cnt) = locs2(matches(cnt,2),1:2)'; 
    end 
    NumOfInlier = zeros(nIter,1);                                           % Store the number of inliers for each iteration. 
    Index_p = zeros(nIter,4);                                               % Store the index of selected 4 points in p1 and p2(the same). 
    for cnt = 1:nIter
        Index_p(cnt,:) = randsample(size(matches,1),4)';                    % Randomly pick 4 samples. 
        H = computeH(p1(:,Index_p(cnt,:)),p2(:,Index_p(cnt,:)));
        tmp = H*[p2; ones(1,size(p2,2))];
        tmp(1,:) = tmp(1,:)./tmp(3,:);
        tmp(2,:) = tmp(2,:)./tmp(3,:);
        tmp = tmp(1:2,:);
        dist = sum((tmp - p1).^2);
        NumOfInlier(cnt) = sum(dist<tol);
    end
    if sum(NumOfInlier)==0
        error('Tolerance too small!')
    end   
    [~,index_pick] = max(NumOfInlier);                                      % Index of which has most inliers. 
    bestH = computeH(p1(:,Index_p(index_pick,:)),p2(:,Index_p(index_pick,:)));
    
end
