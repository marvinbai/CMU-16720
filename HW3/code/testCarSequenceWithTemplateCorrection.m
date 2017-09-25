%% Q1.4
%% Car.
clear
close all
load('../data/carseq.mat')
thr = 5.75;
rects = zeros(size(frames,3),4);
rect_init = [60,117,146,152];                                               % [x1, y1, x2, y2]
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
    if norm([u, v])>=thr
        disp(['At ' num2str(cnt) ', we use template 1.'])
        [u,v] = LucasKanadeInverseCompositional(im2double(frames(:,:,1)), im2double(frames(:,:,cnt)), rect_init);
    end
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
    rects(cnt,:) = rect;
    rect = round(rect);                                                     % Round to integer coordinates. 
    rectangle('Position',[rect(1:2) rect(3:4)-rect(1:2)],'Curvature',0.2,'EdgeColor','g','LineWidth',1.5)
    hold off
    pause(0.001)
    if cnt==2 || cnt==100 || cnt==200 || cnt==300 || cnt==400
        title(num2str(cnt),'FontSize',12)
        saveas(gcf,['carseq_' num2str(cnt) 'TemplateCorrection.jpg'],'jpg')
    end
end




