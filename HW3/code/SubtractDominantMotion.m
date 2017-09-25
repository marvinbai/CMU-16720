function mask = SubtractDominantMotion(image1, image2)
%%
% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
    %% Parameters.
    thr = 0.1;
    %% Calculation.
    image1 = im2double(image1);
    image2 = im2double(image2);
    M = LucasKanadeAffine(image1,image2);
    image1_warp = warpH(image1, M, [size(image1,1), size(image2,2)]);
    image1_warp = im2double(image1_warp);
    mask = abs(image2-image1_warp);
    mask(mask>=thr) = 1;
    mask(mask<thr) = 0;
       
    se = strel('disk',8);    
    mask = bwareaopen(mask,10);
    mask = imdilate(mask, se);
    mask = imerode(mask, se);
    mask = medfilt2(mask);
    mask = double(mask);
    
    
end

