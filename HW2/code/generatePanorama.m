function im3 = generatePanorama( im1, im2 )
%% This function generates panorama of two images
    [locs1, desc1] = briefLite(im1);
    [locs2, desc2] = briefLite(im2);
    [matches] = briefMatch(desc1, desc2);
    bestH = ransacH(matches, locs1, locs2, 1e4, 2);                         % Run 1e4 iterations. Pixel location mismatch tolerance is 2. 
    im3 = imageStitching_noClip(im1, im2, bestH);
end

