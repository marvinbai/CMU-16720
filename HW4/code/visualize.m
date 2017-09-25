% Q2.7 - Todo:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3
%% 
clear 
img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
load('../data/some_corresp.mat');
if(size(img1)~=size(img2))
    error('Image matching error!')
end
M = [size(img1,2); size(img1,1)];
F = eightpoint( pts1, pts2, M );

load('../data/templeCoords.mat');
N = size(x1,1); % Number of correspondence to solve. 
x2 = zeros(N,1);
y2 = zeros(N,1);
for cnt = 1:N
    [ x2(cnt), y2(cnt) ] = epipolarCorrespondence( img1, img2, F, x1(cnt), y1(cnt) );       
end

%% Plot 2-D correspondence. 
figure;
subplot(1,2,1)
imshow(img1);
hold on
scatter(x1, y1,'LineWidth',2)

subplot(1,2,2)
imshow(img2);
hold on
scatter(x2, y2,'LineWidth',2)

%% Reconstruct 3-D model. 
load('../data/intrinsics.mat');
E = essentialMatrix(F, K1, K2);
M1 = K1*[eye(3) zeros(3,1)];
M2s = camera2(E);       % 3 x 4 x 4.
p1 = [x1, y1];
p2 = [x2, y2];
for cnt = 1:4
    [P_tmp, Err] = triangulate(M1, p1, K2*M2s(:,:,cnt), p2);   % P is N x 3.
    if all(P_tmp(:,3)>0)
        disp([num2str(cnt) ' is the correct M2.'])
        disp(['Error is ' num2str(Err)])
        P = P_tmp;
        M2 = M2s(:,:,cnt);
        break
    end    
end

%% Plot 3-D model. 
figure;
scatter3(P(:,1), P(:,2), P(:,3))
xlabel('x')
ylabel('y')
zlabel('z')

%% Save files.
save('q2_7.mat','F','M1','M2')














