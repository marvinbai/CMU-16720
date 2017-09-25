function [ P, error ] = triangulate( M1, p1, M2, p2 )
%% triangulate:
%       M1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       M2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

% Q2.4 - Todo:
%       Implement a triangulation algorithm to compute the 3d locations
%       See Szeliski Chapter 7 for ideas

%% Pre-checking   
    N = size(p1,1);
    
%% Projection matrix decomposition
    KR1 = M1(:,1:end-1);     % M = K[R|-RC], 3 x 3.
%     C = inv(-KR)*M1(:,end);
    C1 = -KR1\M1(:,end);    % 3 x 1.
%     [~,~,V] = svd(M1);
%     C1 = V(:,end);
%     [K1 R1] = rq(KR1);
    
    KR2 = M2(:,1:end-1); 
    C2 = -KR2\M2(:,end);
%     [~,~,V] = svd(M2);
%     C2 = V(:,end);
%     [K2 R2] = rq(KR1);
    
%% Find 3D point that lies closest to 2D matching rays of two cameras.
    P = zeros(N,3);
    for cnt = 1:N
        v1 = KR1\[p1(cnt,:),1]';    % 3 x 1.
        v1 = v1/norm(v1);
        v2 = KR2\[p2(cnt,:),1]';    % 3 x 1.
        v2 = v2/norm(v2);
        tmp = eye(3)*2 - v1*v1' - v2*v2';   % 3 x 3.
        tmp = tmp\((eye(3)-v1*v1')*C1+(eye(3)-v2*v2')*C2);  % 3 x 1.
        P(cnt,:) = tmp';        
    end    

%% Calculate error. 
    tmp1 = M1*[P'; ones(1,N)];    % 3 x N.
    tmp1 = tmp1(1:2,:)./repmat(tmp1(3,:),2,1);  % 2 x N.
    tmp1 = tmp1';   % N x 2.
    tmp2 = M2*[P'; ones(1,N)];
    tmp2 = tmp2(1:2,:)./repmat(tmp2(3,:),2,1);
    tmp2 = tmp2';
    error = sqrt(sum((tmp1 - p1).^2,2)) + sqrt(sum((tmp2 - p2).^2,2));
    error = sum(error);

    
end


function [R, Q] = rq(M)
    [Q,R] = qr(flipud(M)');
    R = fliplr(flipud(R'));  
    Q = flipud(Q');
end