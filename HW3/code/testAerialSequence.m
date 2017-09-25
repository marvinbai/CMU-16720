%%
clear
load('../data/aerialseq.mat')
for cnt = 1:size(frames,3)-1
    image1 = im2double(frames(:,:,cnt));
    image2 = im2double(frames(:,:,cnt+1));
    mask = SubtractDominantMotion(image1, image2);
    im_fuse = imfuse(image1,mask);
    imshow(im_fuse);
    if cnt==30 || cnt==60 || cnt==90 ||cnt==120
        title(num2str(cnt),'FontSize',18)
        saveas(gcf,['aerialseq_' num2str(cnt) '.jpg'],'jpg')
    end   
end











