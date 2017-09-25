function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
%     figure(1);
%     displayPyramid(GaussianPyramid);
    [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
%     figure(2);
%     displayPyramid(DoGPyramid);
    PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
    locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature,th_contrast, th_r);
    
end

