function [lines, bw] = findLetters(img)
%% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.
    %% Parameters.
    min_pixel = 400;    % Minimum number of pixels to form a character. 
    gap_pixel = 100;    % Gap value to judge whether it is same line or not.    

    %% Convert to gray and binary. 
    img = im2double(rgb2gray(img));
    thr = graythresh(img);     % Threshold to judge whether there is an ink pixel or not. 
    img = ~im2bw(img,thr);    % Opposite. 0 for back ground and 1 for ink.
    bw = double(~img);
    img = double(img);      % Convert logical to double.
    
    %% Gaussian blur.
    img = imgaussfilt(img,2);
    
    %% Remove all object containing fewer than 'min_pixel' pixels.
    img = bwareaopen(img,min_pixel);
    
    %% Label connected components.
    [L, NumOfChar] = bwlabel(img,8);
    
    %% Measure properties of image regions.
    prop = regionprops(L,'BoundingBox');
    
    %% Calculate how many lines are there.
    cnt_line = 1;
    y = zeros(NumOfChar,1); % y axis.
    rect = prop(1).BoundingBox;
    y(1) = rect(2);
    for cnt = 2:NumOfChar
        rect = prop(cnt).BoundingBox;   % [x1, y1, w, h].
        y(cnt) = rect(2);
        tmp = abs(y(1:cnt-1)-y(cnt)) < gap_pixel; % (cnt-1) x 1, logical.
        if sum(tmp) == 0
            cnt_line = cnt_line + 1;
        end
    end
    
    %% Count number of character for each line. 
    NumOfLine = cnt_line;
    lines = cell(NumOfLine,1);
    [y_sort, index] = sort(y);
    counter = zeros(NumOfLine,1);   % Number of characters for each line.
    cnt_line = 1;
    for cnt = 2:NumOfChar
        if y_sort(cnt) - y_sort(cnt-1) > gap_pixel
            if cnt_line == 1
                counter(cnt_line) = cnt-1;
            else
                counter(cnt_line) = cnt - 1 - sum(counter(1:cnt_line-1));
            end
            cnt_line = cnt_line + 1;
        end
        if cnt == NumOfChar
            counter(cnt_line) = cnt - sum(counter(1:cnt_line-1));
        end
    end
    for cnt = 1:NumOfLine
        lines{cnt} = zeros(counter(cnt),4);
    end
    
    %% Write data into 'lines'.
    cnt_line = 1;
    cnt_char = 1;
    for cnt = 1:NumOfChar
        rect = prop(index(cnt)).BoundingBox;   % [x1, y1, w, h].
        lines{cnt_line}(cnt_char,:) = [rect(1), rect(2), rect(1)+rect(3), rect(2)+rect(4)]';    % [x1, y1, x2, y2].
        if cnt_char == counter(cnt_line)
            cnt_char = 1;
            cnt_line = cnt_line + 1;
        else
            cnt_char = cnt_char + 1;
        end       
    end
    
    %% Sort each line from left to right. 
    for cnt_line = 1:NumOfLine
        x = zeros(1,counter(cnt_line));
        for cnt_char = 1:counter(cnt_line)
            x(cnt_char) = lines{cnt_line}(cnt_char,1);            
        end
        [~,index] = sort(x);
        lines{cnt_line} = lines{cnt_line}(index,:);        
    end
    
end
