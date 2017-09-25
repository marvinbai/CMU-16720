%% 
clear 
close all
load('../data/usseq.mat')
load('usseqrects.mat')
for cnt = 2:size(frames,3)
    image1 = im2double(frames(:,:,cnt-1));
    image2 = im2double(frames(:,:,cnt));
    mask1 = SubtractDominantMotion(image1, image2);
    x1 = rects(cnt,1);
    y1 = rects(cnt,2);
    x2 = rects(cnt,3);
    y2 = rects(cnt,4);
    mask2 = zeros(size(image1,1),size(image1,2));
    mask2(round(y1:y2),round(x1:x2)) = 1;
    mask = mask1 & mask2;
    im_fuse = imfuse(image1,mask);
    imshow(im_fuse);
    if cnt==5 || cnt==25 || cnt==50 || cnt==75 || cnt==100
        title(num2str(cnt),'FontSize',18)
        saveas(gcf,['usseq_' num2str(cnt) '_Affine.jpg'],'jpg')
    end  

end

