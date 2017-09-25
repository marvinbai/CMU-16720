function [ F ] = sevenpoint( pts1, pts2, M )
%% sevenpoint:
%   pts2 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts2, pts2 to q2_2.mat
%     Write recovered F and display the output of displayEpipolarF in your writeup

    %% Parameter setting. 
    if size(pts1,1)~=size(pts2,1)
        error('Error in correspondence matching!')
    end
    
    imwidth = M(1);
    imheight = M(2);
    
    %% Normalization of points1 and points2 to [-1,1].
    pts1(:,1) = pts1(:,1)/imwidth;
    pts1(:,2) = pts1(:,2)/imheight;
    pts2(:,1) = pts2(:,1)/imwidth;
    pts2(:,2) = pts2(:,2)/imheight;
    if max([pts1(:); pts2(:)])>1 || min([pts1(:); pts2(:)])<-1
        error('Normalization Error!')
    end
    
    %% Set U.
    U = zeros(size(pts1,1),9);
    U(:,1) = pts1(:,1).*pts2(:,1);
    U(:,2) = pts1(:,1).*pts2(:,2);
    U(:,3) = pts1(:,1);
    U(:,4) = pts1(:,2).*pts2(:,1);
    U(:,5) = pts1(:,2).*pts2(:,2);
    U(:,6) = pts1(:,2);
    U(:,7) = pts2(:,1);
    U(:,8) = pts2(:,2);
    U(:,9) = 1;
    
    %% Calculate F. 
    [V, ~] = eig(U'*U);
%     V = null(U);
    f1 = V(:,1);
    F1 = reshape(f1,3,3);    % Get the raw fundamental matrix. 
    f2 = V(:,2);
    F2 = reshape(f2,3,3);
    syms lambda;
    poly = sym2poly(det((1-lambda)*F1+lambda*F2));
    if length(poly)~=4
        error('Poly error!')
    end
    lambda_sol = roots(poly);  
    if length(lambda_sol)==1
        F = cell(1,1);
        F{1} = (1-lambda_sol)*F1 + lambda_sol*F2;
        F{1} = refineF(F{1},pts1,pts2);
    elseif length(lambda_sol)==3
        F = cell(1,3);
        F{1} = (1-lambda_sol(1))*F1 + lambda_sol(1)*F2;
        F{2} = (1-lambda_sol(2))*F1 + lambda_sol(2)*F2;
        F{3} = (1-lambda_sol(3))*F1 + lambda_sol(3)*F2;
        if isreal(F{1})
            F{1} = refineF(F{1},pts1,pts2);
        end
        if isreal(F{2})
            F{2} = refineF(F{2},pts1,pts2);
        end
        if isreal(F{3})
            F{3} = refineF(F{3},pts1,pts2);
        end
    else
        error('Roots error!')
    end
    
    %% Unscale F.
    T = zeros(3,3);
    T(1,1) = 1/imwidth;
    T(2,2) = 1/imheight;
    T(3,3) = 1;  
    if length(lambda_sol)==1
        F{1} = T'*F{1}*T;
    elseif length(lambda_sol)==3
        F{1} = T'*F{1}*T;
        F{2} = T'*F{2}*T;
        F{3} = T'*F{3}*T;
    end
end

