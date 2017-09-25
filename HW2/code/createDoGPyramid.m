function [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels)
%% Produces DoG Pyramid
% inputs
% Gaussian Pyramid - A matrix of grayscale images of size (size(im), numel(levels))
% levels - the levels of the pyramid where the blur at each level is
% outputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid created by differencing the Gaussian Pyramid input
    DoGPyramid = zeros(size(GaussianPyramid,1), size(GaussianPyramid,2), numel(levels)-1);
    for cnt_lvl = 1:size(DoGPyramid,3)
        DoGPyramid(:,:,cnt_lvl) = GaussianPyramid(:,:,cnt_lvl+1) - GaussianPyramid(:,:,cnt_lvl);
    end
    
    DoGLevels = levels(2:end);
end