clear
close all
%%
load('../data/sylvseq.mat')
load('../data/sylvbases.mat')
rects_prev = zeros(size(frames,3),4);
rects = zeros(size(frames,3),4);
rect_init = [102,62,156,108];                                               % [x1, y1, x2, y2]
rects_prev(1,:) = rect_init;
figure;
imshow(im2double(frames(:,:,1)));
hold on
rectangle('Position',[rect_init(1:2) rect_init(3:4)-rect_init(1:2)],'Curvature',0.2,'EdgeColor','r','LineWidth',1.5)
hold off
pause(0.001)
rect_prev = rect_init;
rect = rect_init;
for cnt = 2:size(frames,3)
    imshow(im2double(frames(:,:,cnt)));
    hold on
    [u_prev,v_prev] = LucasKanadeInverseCompositional(im2double(frames(:,:,cnt-1)), im2double(frames(:,:,cnt)), rect_prev);
    rect_prev = [rect_prev(1)+u_prev, rect_prev(2)+v_prev, rect_prev(3)+u_prev, rect_prev(4)+v_prev];
    [u,v] = LucasKanadeBasis(im2double(frames(:,:,cnt-1)), im2double(frames(:,:,cnt)), rect, bases);
    rect = [rect(1)+u, rect(2)+v, rect(3)+u, rect(4)+v];
    rects_prev(cnt,:) = rect_prev;
    rect_prev = round(rect_prev);                                           % Round to integer coordinates. 
    rects(cnt,:) = rect;
    rect = round(rect);
    rectangle('Position',[rect_prev(1:2) rect_prev(3:4)-rect_prev(1:2)],'Curvature',0.2,'EdgeColor','r','LineWidth',1.5)
    rectangle('Position',[rect(1:2) rect(3:4)-rect(1:2)],'Curvature',0.2,'EdgeColor','g','LineWidth',1.5)
    hold off
    pause(0.001)
    if cnt==2 || cnt==200 || cnt==250 || cnt==300 || cnt==400
        title(num2str(cnt),'FontSize',15)
        saveas(gcf,['sylvbases_' num2str(cnt) '.jpg'],'jpg')
    end
end
save('sylvseqrects.mat','rects');