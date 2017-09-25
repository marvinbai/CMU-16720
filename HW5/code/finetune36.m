%%
clear
num_epoch = 5;
classes = 36;
layers = [32*32, 800, classes];
learning_rate = 0.01;

load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels')
load('../data/nist36_valid.mat', 'valid_data', 'valid_labels')

acc_train = zeros(num_epoch,1);
acc_valid = zeros(num_epoch,1);
loss_train = zeros(num_epoch,1);
loss_valid = zeros(num_epoch,1);

%% Initialize only the first layer of W and b.
[W_init, b_init] = InitializeNetwork(layers);
load('../data/nist26_model_60iters.mat')
W_tmp = cell(2,1);
b_tmp = cell(2,1);
W_tmp{1} = W{1}';
W_tmp{2} = W{2}';
b_tmp{1} = b{1}';
b_tmp{2} = b{2}';
W_init{1} = W_tmp{1};
b_init{1} = b_tmp{1};
W = W_init;
b = b_init;
clear W_tmp b_tmp W_init b_init

%% Train.
for j = 1:num_epoch
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);
    [train_acc, train_loss] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc, valid_loss] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);   
    acc_train(j) = train_acc;
    acc_valid(j) = valid_acc;
    loss_train(j) = train_loss;
    loss_valid(j) = valid_loss;
    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc, valid_acc, train_loss, valid_loss)
end

figure;
plot([1:num_epoch],acc_train,'LineWidth',2,'Color','blue');
set(gca,'FontSize',15)
grid on
hold on
plot([1:num_epoch],acc_valid,'LineWidth',2,'Color','red');
leg = legend('Training Accuracy','Valid Accuracy','Location','SouthEast');
set(leg,'FontSize',13)
saveas(gcf,'Accuracy.fig','fig')

figure;
plot([1:num_epoch],loss_train,'LineWidth',2,'Color','blue');
set(gca,'FontSize',15)
grid on
hold on
plot([1:num_epoch],loss_valid,'LineWidth',2,'Color','red');
leg = legend('Training Loss','Valid Loss','Location','NorthEast');
set(leg,'FontSize',13)
saveas(gcf,'Loss.fig','fig')

save('AccLoss.mat','acc_train','acc_valid','loss_train','loss_valid');
save('nist36_model.mat', 'W', 'b')
