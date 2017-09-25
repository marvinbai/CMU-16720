function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
%% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q2.6 - Todo:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q2_6.mat
%
%           Explain your methods and optimization in your writeup
    im1 = double(im1);
    im2 = double(im2);

    %% Parameter settings. 
    window_size_half = 7;   % Half squared window size to compare.  
    sigma = 2;  % Sigma of Gaussian kernel. 
    search_range_half = 25; % Search range around the point in image1. 
    isPlot = 0;
    
    mask = fspecial('gaussian',[2*window_size_half+1 2*window_size_half+1],sigma);
    tmp = zeros(2*window_size_half+1, 2*window_size_half+1, 3);
    tmp(:,:,1) = mask;
    tmp(:,:,2) = mask;
    tmp(:,:,3) = mask;
    mask = tmp;
    
    
    %% Get the rough starting point in image2.
    if size(im1,1)>=size(im1,2)
        error('Image width needs to be larger than height!')
    end
    p1 = [x1 y1 1]';
    epiLine = F*p1;
    epiLine = epiLine/epiLine(3);   
    patch1 = im1(y1-window_size_half:y1+window_size_half, x1-window_size_half:x1+window_size_half, :);     % (2 x window_size_half+1) x (2 x window_size_half+1).
%     range_row = window_size_half+1:size(im1,1)-window_size_half;
    range_row = max(window_size_half+1, y1-search_range_half):min(size(im1,1)-window_size_half, y1+search_range_half);
    epiPoints = zeros(length(range_row), 2);
    epiErr = zeros(length(range_row), 1);
    cnt = 0;
    for row = range_row
        cnt = cnt + 1;
        col = (-epiLine(3)-epiLine(2)*row)/epiLine(1);  % epiLine(1)*col + epiLine(2)*row + epiLine(3) = 0.
        col = round(col);
        epiPoints(cnt,:) = [col, row];
        patch2 = im2(row-window_size_half:row+window_size_half, col-window_size_half:col+window_size_half,:);
        if isPlot == 1
            subplot(1,2,1)
            imshow(patch1)
            subplot(1,2,2)
            imshow(patch2)
            pause(0.01)
        end
        tmp = (patch1-patch2).^2.*mask;
        epiErr(cnt) = sum(tmp(:))/numel(tmp);
    end
    [~, index] = min(epiErr);
    x2 = epiPoints(index, 1);
    y2 = epiPoints(index, 2);
end

