function H2to1 = computeH(p1,p2)
%% 
% inputs:
% p1 and p2 should be 2 x N matrices of corresponding (x, y)' coordinates between two images
%
% outputs:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
    if size(p1)~=size(p2)
        error('Vector size does not match!')
    end
    A = zeros(2*size(p1,2),9);
    for cnt = 1:size(p1,2)
        x1 = p1(1,cnt);
        y1 = p1(2,cnt);
        x2 = p2(1,cnt);
        y2 = p2(2,cnt);
        A((cnt-1)*2+1:(cnt-1)*2+2,:) = [x2 y2 1 0 0 0 -x1*x2 -x1*y2 -x1; ...
            0 0 0 x2 y2 1 -y1*x2 -y1*y2 -y1];        
    end
%     [~,~,V] = svd(A);
%     H2to1 = reshape(V(:,end),3,3)';
    [V,~] = eig(A'*A);
    H2to1 = reshape(V(:,1),3,3)';
    
end