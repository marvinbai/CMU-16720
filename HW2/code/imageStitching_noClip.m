function [panoImg_noClip] = imageStitching_noClip(im1, im2, H2to1)
%% 
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image
%
% To prevent clipping at the edges, we instead need to warp both image 1 and image 2 into a common third reference frame 
% in which we can display both images without any clipping.
    if length(size(im1))~=length(size(im2))
        error('Two images must be both gray or both colored!')
    end
    pano_size = [0 0];                                                      % Height and width of the output panoroma image. 
    pano_size(2) = 1000;                                                    % Fix the width of the output and then compute the height.    
    ExtremPt_2 = [1 1 1; size(im2,2),1,1; 1,size(im2,1),1; size(im2,2),size(im2,1),1]';
    ExtremPt_2 = H2to1 * ExtremPt_2;                                        % Corner points for figure 2 after transformation. 
    ExtremPt_2(1,:) = ExtremPt_2(1,:)./ExtremPt_2(3,:);
    ExtremPt_2(2,:) = ExtremPt_2(2,:)./ExtremPt_2(3,:);
    ExtremPt_1 = [1 1 1; size(im1,2),1,1; 1,size(im1,1),1; size(im1,2),size(im1,1),1]';
                                                                            % Corner points for figure 1. 
    vert = max([ExtremPt_1(2,:),ExtremPt_2(2,:)]) - min([ExtremPt_1(2,:),ExtremPt_2(2,:)]);
    hori = max([ExtremPt_1(1,:),ExtremPt_2(1,:)]) - min([ExtremPt_1(1,:),ExtremPt_2(1,:)]);
    
    %% Do translation first. 
    tx = -min([ExtremPt_1(1,:),ExtremPt_2(1,:)])+1;
    ty = -min([ExtremPt_1(2,:),ExtremPt_2(2,:)])+1;
    M_trans = [1 0 tx; 0 1 ty; 0 0 1];
    
    %% Then do scaling. 
    S = pano_size(2)/hori;
    pano_size(1) = ceil(vert*S);
    M_scale = [S 0 0; 0 S 0; 0 0 1];
    
    %% Transform. S*T*H.
    im1_warp = warpH(im1, M_scale*M_trans, pano_size);
    im2_warp = warpH(im2, M_scale*M_trans*H2to1, pano_size);
    
    %% Stitch two images together. 
    mask1 = zeros(size(im1,1), size(im1,2));
    mask1(1,:) = 1; mask1(end,:) = 1; mask1(:,1) = 1; mask1(:,end) = 1;
    mask1 = bwdist(mask1, 'city');
    mask1 = mask1/max(mask1(:));
    mask1 = warpH(mask1, M_scale*M_trans, pano_size);
    if length(size(im1))==3
        mask1 = repmat(mask1,1,1,3);
    end
    mask2 = zeros(size(im2,1), size(im2,2));
    mask2(1,:) = 1; mask2(end,:) = 1; mask2(:,1) = 1; mask2(:,end) = 1;
    mask2 = bwdist(mask2, 'city');
    mask2 = mask2/max(mask2(:));
    mask2 = warpH(mask2, M_scale*M_trans*H2to1, pano_size);
    if length(size(im2))==3
        mask2 = repmat(mask2,1,1,3);
    end 
        
    panoImg_noClip = im2single(im1_warp).*mask1./(mask1+mask2) + im2single(im2_warp).*mask2./(mask1+mask2);
    figure;
    imshow(panoImg_noClip)
    
end