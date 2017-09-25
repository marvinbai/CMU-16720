%%
clear
img = imread('../images/01_list.jpg');
[lines, ~] = findLetters(img);
figure;
imshow(img);
hold on
for cnt_line = 1:length(lines)
    tmp = lines{cnt_line};
    for cnt_char = 1:size(tmp,1)
        rect = tmp(cnt_char,:); % [x1, y1, x2, y2].
        rect(3:4) = [rect(3)-rect(1), rect(4)-rect(2)];
        rectangle('Position',rect,'EdgeColor','g','LineWidth',2)
    end        
end
hold off

img = imread('../images/02_letters.jpg');
[lines, ~] = findLetters(img);
figure;
imshow(img);
hold on
for cnt_line = 1:length(lines)
    tmp = lines{cnt_line};
    for cnt_char = 1:size(tmp,1)
        rect = tmp(cnt_char,:); % [x1, y1, x2, y2].
        rect(3:4) = [rect(3)-rect(1), rect(4)-rect(2)];
        rectangle('Position',rect,'EdgeColor','g','LineWidth',2)
    end        
end
hold off

img = imread('../images/03_haiku.jpg');
[lines, ~] = findLetters(img);
figure;
imshow(img);
hold on
for cnt_line = 1:length(lines)
    tmp = lines{cnt_line};
    for cnt_char = 1:size(tmp,1)
        rect = tmp(cnt_char,:); % [x1, y1, x2, y2].
        rect(3:4) = [rect(3)-rect(1), rect(4)-rect(2)];
        rectangle('Position',rect,'EdgeColor','g','LineWidth',2)
    end        
end
hold off

img = imread('../images/04_deep.jpg');
[lines, ~] = findLetters(img);
figure;
imshow(img);
hold on
for cnt_line = 1:length(lines)
    tmp = lines{cnt_line};
    for cnt_char = 1:size(tmp,1)
        rect = tmp(cnt_char,:); % [x1, y1, x2, y2].
        rect(3:4) = [rect(3)-rect(1), rect(4)-rect(2)];
        rectangle('Position',rect,'EdgeColor','g','LineWidth',2)
    end        
end
hold off
