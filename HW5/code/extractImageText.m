function [text] = extractImageText(fname)
%%
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.
    %% Load image and locate characters.
    img = imread(fname);
    [lines, bw] = findLetters(img);
    H = size(bw,1);     % Height of image. 
    
    %% Display image with located character.
    figure;
    imshow(bw);
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
    load('nist36_model.mat')    
    
    %%
    text = [];
    for cnt_line = 1:length(lines)
        for cnt_char = 1:size(lines{cnt_line},1)
            rect = lines{cnt_line}(cnt_char,:); % [x1,y1,x2,y2].
            img = bw(round(rect(2)):round(rect(4)),round(rect(1)):round(rect(3)));
            X = scale(img);
            [outputs] = Classify(W, b, X);
            [~, label_predict] = max(outputs,[],2);
            text_out = Num2Char(label_predict);
            text = [text, text_out];
        end        
        text = [text, '\n'];
    end
    disp('Reading Characters:')
    fprintf(text);
end

%% Helper function. 
%% Convert a binary character image into 1024x1 vector to feed neural network.
function X = scale(img)
    X = imresize(img, [32 32]);
    X = reshape(X,1,1024);
end

%% Convert output class into text.
function text_out = Num2Char(label)
    if label>=1 && label<=26
        text_out = char('A'+label-1);        
    elseif label>=27 && label<=35
        text_out = char('1'+(label-26)-1);
    elseif label==36
        text_out = '0';
    else
        disp(['label is ' num2str(label)])
        error('Wrong Label!')
    end
end








