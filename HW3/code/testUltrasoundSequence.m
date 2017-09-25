%% Ultrasound.
clear
close all
load('../data/usseq.mat')
rects = zeros(size(frames,3),4);
rect_init = [255, 105, 310, 170];
rects(1,:) = rect_init;
figure;
imshow(im2double(frames(:,:,1)));
hold on
rectangle('Position',[rect_init(1:2) rect_init(3:4)-rect_init(1:2)],'Curvature',0.2,'EdgeColor','r','LineWidth',1.5)
hold off
pause(0.001)
rect = rect_init;
for cnt = 2:size(frames,3)
    imshow(im2double(frames(:,:,cnt)));
    hold on
    [u,v] = LucasKanadeInverseCompositional(im2double(frames(:,:,cnt-1)), im2double(frames(:,:,cnt)), rect);
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
    rects(cnt,:) = rect;
    rect = round(rect);
    rectangle('Position',[rect(1:2) rect(3:4)-rect(1:2)],'Curvature',0.2,'EdgeColor','r','LineWidth',1.5)
    hold off
    pause(0.001)
    if cnt==5 || cnt==25 || cnt==50 || cnt==75 || cnt==100
        title(num2str(cnt),'FontSize',12)
        saveas(gcf,['usseq_' num2str(cnt) '.jpg'],'jpg')
    end
end
save('usseqrects.mat','rects');

