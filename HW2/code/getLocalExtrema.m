function locs = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature,th_contrast, th_r)
%% Detecting Extrema
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a DoG response magnitude above this threshold
% th_r - remove any edge-like points that have too large a principal curvature ratio
% output
% locs - N x 3 matrix where the DoG pyramid achieves a local extrema in both scale and space, and also satisfies the two thresholds.
    index_LocEx = zeros(size(DoGPyramid,1),size(DoGPyramid,2),length(DoGLevels));   
                                                                            % m x n matrix containing boolean value of whether a point is local extrema. 
    %% Find raw local extremas. 
    for cnt_lvl = 1:length(DoGLevels)
        if cnt_lvl == 1 || cnt_lvl == length(DoGLevels)
            mat_curr = zeros(size(DoGPyramid,1),size(DoGPyramid,2),10);
        else
            mat_curr = zeros(size(DoGPyramid,1),size(DoGPyramid,2),11);
        end
        mat_curr(:,:,1) = DoGPyramid(:,:,cnt_lvl);                          % Take the current DoG layer. [m x n]
        mat_curr(:,:,2:9) = NeighborMatrix(mat_curr(:,:,1));                % 8 neighbor matrix. [m x n x 8]
        if cnt_lvl == 1
            mat_curr(:,:,10) = DoGPyramid(:,:,2);
        elseif cnt_lvl == length(DoGLevels)
            mat_curr(:,:,10) = DoGPyramid(:,:,length(DoGLevels)-1);
        else
            mat_curr(:,:,10) = DoGPyramid(:,:,cnt_lvl-1);
            mat_curr(:,:,11) = DoGPyramid(:,:,cnt_lvl+1);
        end
        [~, index_min] = min(mat_curr,[],3);
        [~, index_max] = max(mat_curr,[],3);
        index_min(index_min~=1) = 0;
        index_max(index_max~=1) = 0;
        index_LocEx(:,:,cnt_lvl) = index_min | index_max;         
    end
    
    %% Remove edge-like points which have large principal curvature value. 
    index_LocEx(PrincipalCurvature>th_r) = 0;
    
    %% Remove points which do not have enough DoG response magnitude. 
    index_LocEx(abs(DoGPyramid)<th_contrast) = 0;
    
    %% Output index of interesting points. 
    locs = zeros(sum(sum(sum(index_LocEx))),3);
    cnt_locs = 0;
    for cnt_lvl = 1:length(DoGLevels)
        N = sum(sum(index_LocEx(:,:,cnt_lvl)));                             % Number of local extremas in this layer. 
        [locs(cnt_locs+1:cnt_locs+N,2), ...
            locs(cnt_locs+1:cnt_locs+N,1)] = find(index_LocEx(:,:,cnt_lvl)~=0);
        locs(cnt_locs+1:cnt_locs+N,3) = cnt_lvl;            
        cnt_locs = cnt_locs + N;
    end
    
    
    
end

function [ mat_out ] = NeighborMatrix( mat_ori )
%% This help function creates 8 matrices with 1 pixel shift. 
% Up-left, up, up-right, left, right, bottom-left, down, down-right. 
% Input
% mat_ori(m x n): a matrix with certain size whose neighbor matrices to be calculated.
% Output
% mat_out(m x n x 8): a 8-layer matrix with same size as input. 
    mat_out = zeros(size(mat_ori,1),size(mat_ori,2),8);
    % Up-left, mat_out(:,:,1)
    mat_out(1,1,1) = mat_ori(1,1);
    mat_out(1,2:end,1) = mat_ori(1,1:end-1);
    mat_out(2:end,1,1) = mat_ori(1:end-1,1);
    mat_out(2:end,2:end,1) = mat_ori(1:end-1,1:end-1);
    % Up, mat_out(:,:,2)
    mat_out(1,:,2) = mat_ori(1,:);
    mat_out(2:end,:,2) = mat_ori(1:end-1,:);
    % Up-right, mat_out(:,:,3)
    mat_out(1,end,3) = mat_ori(1,end);
    mat_out(1,1:end-1,3) = mat_ori(1,2:end);
    mat_out(2:end,end,3) = mat_ori(1:end-1,end);
    mat_out(2:end,1:end-1,3) = mat_ori(1:end-1,2:end);
    % Left, mat_out(:,:,4)
    mat_out(:,1,4) = mat_ori(:,1);
    mat_out(:,2:end,4) = mat_ori(:,1:end-1);
    % Right, mat_out(:,:,5)
    mat_out(:,end,5) = mat_ori(:,end);
    mat_out(:,1:end-1,5) = mat_ori(:,2:end);
    % Bottom-left, mat_out(:,:,6)
    mat_out(end,1,6) = mat_ori(end,1);
    mat_out(1:end-1,1,6) = mat_ori(2:end,1);
    mat_out(end,2:end,6) = mat_ori(end,1:end-1);
    mat_out(1:end-1,2:end,6) = mat_ori(2:end,1:end-1);
    % Bottom, mat_out(:,:,7)
    mat_out(end,:,7) = mat_ori(end,:);
    mat_out(1:end-1,:,7) = mat_ori(2:end,:);
    % Bottom-right, mat_out(:,:,8)
    mat_out(end,end,8) = mat_ori(end,end);
    mat_out(1:end-1,end,8) = mat_ori(2:end,end);
    mat_out(end,1:end-1,8) = mat_ori(end,2:end);
    mat_out(1:end-1,1:end-1,8) = mat_ori(2:end,2:end);    
end
