%% This program tests the matching rate after rotation.
clear
close all
im = imread('model_chickenbroth.jpg');
im = im2double(rgb2gray(im));
[locs, desc] = briefLite(im);
angle_rng = 0:10:360;
match_result = zeros(1,length(angle_rng));
figure;
for cnt = 1:length(angle_rng)
    angle = angle_rng(cnt);
    im_rot = imrotate(im,angle);
    [locs_rot, desc_rot] = briefLite(im_rot);
    matches = briefMatch(desc,desc_rot);
    if angle == 10 || angle == 20 || angle == 30
        subplot(3,1,cnt-1);
        plotMatches(im, im_rot, matches, locs, locs_rot); 
        title(['Rotation of ' num2str(angle) ' degrees'])
    end        
    match_result(cnt) = size(matches,1); 
end

figure;
bar(angle_rng,match_result);
set(gca,'FontSize',12)
xlim([-10,370])
xlabel('Rotation Angle (degree)','FontSize',15)
ylabel('Number of Matches','FontSize',15)







