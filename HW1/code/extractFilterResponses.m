function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses

	% TODO Implement your code here
    F = size(filterBank,1);
    img = im2double(img);
    H = size(img,1);
    W = size(img,2);
    if size(img,3) == 3                                                     % Colored picture.
        img1 = img(:,:,1);
        img2 = img(:,:,2);
        img3 = img(:,:,3);
    elseif size(img,3) == 1                                                 % Gray scale picture.
        img1 = img;
        img2 = img;
        img3 = img;
    else
        error('Image size not correct!')
    end
    [Lab, a, b] = RGB2Lab(img1,img2,img3);
    filterResponses = zeros(H*W,3*F);
    for cnt = 1:F      
        filterResponses(:,(cnt-1)*3+1) = reshape(imfilter(Lab,filterBank{cnt},'conv'),H*W,1); 
        filterResponses(:,(cnt-1)*3+2) = reshape(imfilter(a,filterBank{cnt},'conv'),H*W,1);
        filterResponses(:,(cnt-1)*3+3) = reshape(imfilter(b,filterBank{cnt},'conv'),H*W,1);
    end
    
end
