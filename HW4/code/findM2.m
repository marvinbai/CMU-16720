% Q2.5 - Todo:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q2_5.mat

%% Solve for essential matrix. 
clear
close all
img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
load('../data/some_corresp.mat');
if(size(img1)~=size(img2))
    error('Image matching error!')
end
M = [size(img1,2); size(img1,1)];
F = eightpoint( pts1, pts2, M );
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);

%% Solve 4 solutions for M2. 
M1 = K1*[eye(3) zeros(3,1)];
M2s = camera2(E);       % 3 x 4 x 4.

%% Using triangulation to choose right M2.
for cnt = 1:4
    [P_tmp, Err] = triangulate(M1, pts1, K2*M2s(:,:,cnt), pts2);   % P is N x 3.
    if all(P_tmp(:,3)>0)
        disp([num2str(cnt) ' is the correct M2.'])
        P = P_tmp;
        M2 = M2s(:,:,cnt);
        break
    end    
end
p1 = pts1;
p2 = pts2;

%% Save files.
save('q2_5.mat','M2','p1','p2','P')













