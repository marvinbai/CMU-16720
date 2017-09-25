function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%% Edge Suppression
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each point contains the curvature ratio R for the 
% 					   corresponding point in the DoG pyramid
    [gx, gy] = gradient(DoGPyramid);
    [gxx, gxy] = gradient(gx);
    [gyx, gyy] = gradient(gy);
    PrincipalCurvature = (gxx+gyy).^2./(gxx.*gyy-gxy.*gyx);  
    PrincipalCurvature = abs(PrincipalCurvature);
end