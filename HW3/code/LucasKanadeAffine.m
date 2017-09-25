function M = LucasKanadeAffine(It, It1)
%% This function calculates transform matrix from It to It1.
% input - image at time t, image at t+1 
% output - M affine transformation matrix
    It = im2double(It);
    It1 = im2double(It1);
    
    %% Parameters
    thr = 1e-3;                                                             % Threshold for dp.
    Iter_max = 100;                                                          % Maximum number of iteration. 
    p = zeros(6,1);                                                         % Initial guess of p, 6 x 1.
    
    %% Implement inverse compositional L-K algorithm. 
    T = It;    
    n = numel(T);                                                           % Number of pixels in the rectangle.
    X = repmat([1:size(T,2)], size(T,1), 1);
    Y = repmat([1:size(T,1)]', 1, size(T,2));
    X_vec = reshape(X, n, 1);                                               % n x 1.
    Y_vec = reshape(Y, n, 1);                                               % n x 1.
        
    for iter = 1:Iter_max
        M = [1+p(1), p(2), p(3); p(4), 1+p(5), p(6); 0 0 1];                % Update M. 
        X_warp = M(1,1)*X + M(1,2)*Y + M(1,3);
        Y_warp = M(2,1)*X + M(2,2)*Y + M(2,3);
        I = interp2(X, Y, It1, X_warp, Y_warp);                             % Warp image.
        I(isnan(I)) = 0;
        % Create mask to select common area. 
        mask = (X_warp >=1 & X_warp <= size(It,2)) & (Y_warp >=1 & Y_warp <= size(It,1));
        % Compute difference (error).
        dif = I - T;                                                        % size(T,1) x size(T,2).
        dif = dif .* mask;
        dif = dif(:);                                                       % n x 1.
        % Compute gradient.
        [dIdx, dIdy] = gradient(I);
        dIdx = mask .* dIdx;
        dIdy = mask .* dIdy;
        dIdx = dIdx(:);                                                     % n x 1.
        dIdy = dIdy(:);                                                     % n x 1.
        % Compute steepest descent.
        SD = [dIdx.*X_vec, dIdx.*Y_vec, dIdx, dIdy.*X_vec, dIdy.*Y_vec, dIdy];              % n x 6.
        % Compute Hessian matrix.
        H = SD'*SD;
        % Compute dp.
        dp = H\(SD'*dif);                                                   % 6 x 1.
        
        if norm(dp)<thr
            break;
        end
        p = p - dp;
        if iter == Iter_max
            disp('Max Number of Iteration Reached!')
        end
    end
    M = [1+p(1), p(2), p(3); p(4), 1+p(5), p(6); 0 0 1];                    % Final M. 
end
