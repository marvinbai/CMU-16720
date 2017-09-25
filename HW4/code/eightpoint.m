function [ F ] = eightpoint( pts1, pts2, M )
%%  eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1 - Todo:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat
%     Write F and display the output of displayEpipolarF in your writeup

    %% Parameter setting. 
    if size(pts1,1)~=size(pts2,1)
        error('Error in correspondence matching!')
    end
    NumOfCor = size(pts1,1);    % Number of correspondence.
    imwidth = M(1);
    imheight = M(2);
    
    %% Normalization of points1 and points2 to [-1,1].
    pts1(:,1) = pts1(:,1)/imwidth;
    pts1(:,2) = pts1(:,2)/imheight;
    pts2(:,1) = pts2(:,1)/imwidth;
    pts2(:,2) = pts2(:,2)/imheight;
    if max([pts2(:); pts1(:)])>1 || min([pts2(:); pts1(:)])<-1
        error('Normalization Error!')
    end
    
    %% Set U. 
    U = zeros(NumOfCor,9);
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
    f = V(:,1);
    F = reshape(f,3,3);    % Get the raw fundamental matrix. 
    [U,S,V] = svd(F); 
    S(3,3) = 0;
    F = U*S*V';     % Enforce singularity. 
    F = refineF(F,pts1,pts2);   % Refine F. 
    
    %% Unscale F.
    T = zeros(3,3);
    T(1,1) = 1/imwidth;
    T(2,2) = 1/imheight;
    T(3,3) = 1;
    F = T'*F*T;    
    
    
    
    
end

