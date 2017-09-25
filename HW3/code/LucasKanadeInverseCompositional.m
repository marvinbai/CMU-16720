function [u,v] = LucasKanadeInverseCompositional(It, It1, rect)
%% This function calculates translation of rectangle between two image frames. 
% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u,v] in the x- and y-directions.
    It = im2double(It);
    It1 = im2double(It1);
    
    %% Parameters
    thr = 0.1;                                                              % Threshold for [du, dv].
    Iter_max = 50;                                                          % Maximum number of iteration. 
    p = [0;0];                                                              % Initial guess of [u; v], 2 x 1.
    
    %% Implement inverse compositional L-K algorithm. 
    x1 = rect(1);
    y1 = rect(2);
    x2 = rect(3);
    y2 = rect(4);
    [Xq, Yq] = meshgrid([x1:x2],[y1:y2]);
    T = interp2(It,Xq,Yq);    
    n = numel(T);                                                           % Number of pixels in the rectangle.
    [dTdx, dTdy] = gradient(T);                                             % deltaT. 
    dTdx = reshape(dTdx,n,1);                                               % n x 1.
    dTdy = reshape(dTdy,n,1);                                               % n x 1.
    H = [dTdx, dTdy]'*[dTdx, dTdy];                                         % 2 x 2. Pre-computed Hersian matrix. 
    H_inv = inv(H);
    
    x1_new = x1+p(1);
    y1_new = y1+p(2);
    x2_new = x2+p(1);
    y2_new = y2+p(2);
    for iter = 1:Iter_max
        [Xq, Yq] = meshgrid([x1_new:x2_new],[y1_new:y2_new]);
        I = interp2(It1,Xq,Yq);
        I = reshape(I, n, 1);
        dp = H_inv*([dTdx, dTdy]'*(I-reshape(T,n,1)));                      % 2 x 1.
        if norm(dp)<thr
            break;
        end
        p = p - dp;
        x1_new = x1 + p(1);
        y1_new = y1 + p(2);
        x2_new = x2 + p(1);
        y2_new = y2 + p(2);
        if iter == Iter_max
            disp('Max Number of Iteration Reached!')
        end
    end
    u = p(1);
    v = p(2);
end
