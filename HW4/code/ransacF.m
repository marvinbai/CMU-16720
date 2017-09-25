function [ F ] = ransacF( pts1, pts2, M )
%% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.X - Extra Credit:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using sevenpoint
%          - using ransac

%     In your writeup, describe your algorith, how you determined which
%     points are inliers, and any other optimizations you made
    %% Parameter settings. 
    iter_max = 500;  % Maximum iteration number in RANSAC.
    tol = 0.5;    % [pixels].
    
    %% RANSAC
    N = size(pts1,1);
    points1x = zeros(iter_max,7);
    points1y = zeros(iter_max,7);
    points2x = zeros(iter_max,7);
    points2y = zeros(iter_max,7);
    NumIn = zeros(iter_max,1);    % Number of in-lier for each iteration. 
    pts_rec = zeros(iter_max,7);
    for iter = 1:iter_max
        disp(['In iteration ' num2str(iter)]);
        shuffled = randperm(N);      % 1 x N. 
        selected = shuffled(1:7);     % 1 x 7. Randomly draw 7 points. 
        pts1_iter = pts1(selected,:);    % 7 x 2. 
        pts2_iter = pts2(selected,:);
        [ F ] = sevenpoint( pts1_iter, pts2_iter, M );      % Imagenary Number?  
        if size(F,2) == 3
            NumIn_iter = zeros(1,3);
            for cnt_F = 1:3
                F_tmp = F{cnt_F};
                if isreal(F_tmp)
                    cnt_in = 0;
                    for cnt_pt = shuffled(8:end)
                        epiLine = F_tmp * [pts1(cnt_pt,:), 1]'; % 3 x 1.
                        epiLine = epiLine/sqrt(epiLine(1)^2+epiLine(2)^2);  % Normalize line. 
%                         disp(num2str([pts2(cnt_pt,:), 1]*epiLine))
                        if abs([pts2(cnt_pt,:), 1]*epiLine) < tol
                            cnt_in = cnt_in + 1;
                        end                    
                    end
                else
                    cnt_in = 0;
                end
                NumIn_iter(cnt_F) = cnt_in;
            end
            NumIn(iter) = max(NumIn_iter);                   
        elseif size(F,2) == 1
            cnt_in = 0;
            for cnt_pt = shuffled(8:end)
                epiLine = F{1} * [pts1(cnt_pt,:), 1]'; % 3 x 1.
                epiLine = epiLine/sqrt(epiLine(1)^2+epiLine(2)^2);  % Normalize line. 
                if abs([pts2(cnt_pt,:), 1]*epiLine) < tol
                    cnt_in = cnt_in + 1;
                end                    
            end
            NumIn(iter) = cnt_in; 
        else
            error('F dimension error!')
        end
        pts_rec(iter,:) = selected;
        points1x(iter,:) = pts1_iter(:,1)';
        points1y(iter,:) = pts1_iter(:,2)';
        points2x(iter,:) = pts2_iter(:,1)';
        points2y(iter,:) = pts2_iter(:,2)';
        
    end
    [val, index] = max(NumIn);
    disp(['Max inlier number is ' num2str(val)])
    disp(['Number of points selected are ' num2str(pts_rec(index,:))])
    pts1_iter = pts1(pts_rec(index,:),:);
    pts2_iter = pts2(pts_rec(index,:),:);
    [ F ] = sevenpoint( pts1_iter, pts2_iter, M ); 
    if size(F,2) == 3
        NumIn_iter = zeros(1,3);
        for cnt_F = 1:3
            F_tmp = F{cnt_F};
            cnt_in = 0;
            for cnt_pt = shuffled(8:end)
                epiLine = F_tmp * [pts1(cnt_pt,:), 1]'; % 3 x 1.
                epiLine = epiLine/sqrt(epiLine(1)^2+epiLine(2)^2);  % Normalize line. 
                if abs([pts2(cnt_pt,:), 1]*epiLine) < tol
                    cnt_in = cnt_in + 1;
                end                    
            end
            NumIn_iter(cnt_F) = cnt_in;
        end
        [~, index] = max(NumIn_iter); 
        F = F{index};
    elseif size(F,2) == 1
        % Do Nothing. 
    else
        error('F dimension error!')
    end

end

