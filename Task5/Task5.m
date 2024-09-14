%% ----------------------------------------------
%  Task 5: Distributed target localization under sparse sensor attacks
%  Creators: Federico Paglialunga - s328876
%            Luigi Graziosi - s331564
%            Marco Luppino - s333997
%
%  Last modification date:  03/05/2024
% -----------------------------------------------
%% ----------------------------------------------
clear
close all
clc

%% Hyperparameters
load("distributed_localization_data.mat");

p = 100;                % #cells
q = 25;                 % #sensors
eps = 1e-8;
delta = 1e-8;
debug = 0;
n_targets = 2;

% Variables
G = [D eye(25)];
tau = 4e-7;
lambda = [10 0.1];
Gamma = tau*[lambda(1)*ones(p,1); lambda(2)*ones(q,1)];
Q = Q_4;

tol = 0.002;

% Substitute the value of flag with 4, 8, 12 or 18 to have the correct
% graph definition. Default definition is Q_4 (and so if the choise of 
% flag is not variable)
graph_num = 4;

%% DIST Algorithm

if graph_num == 4
    Q = Q_4;
elseif graph_num == 8
    Q = Q_8;
elseif graph_num == 12
    Q = Q_12;
elseif graph_num == 18
    Q = Q_18;
end

eigs = sort(eig(Q),'descend', ComparisonMethod='abs');
if (eigs(2) == 1)
    disp("This system cannot reach the consensus")
end

z = zeros(p+q, q);
z_new = z;
T = 0;

while 1
    T = T+1;
    norm_condition = 0;
    for i=1:q
        val = 0;
        for j=1:q
            val = val + Q(i,j)*z(:,j);
        end
        z_new(:,i) = thresholding(val + tau*G(i,:)'*(y(i)-G(i,:)*z(:,i)), Gamma);
        norm_condition = norm_condition + norm(z_new(:,i)-z(:,i))^2;
    end
    
    if norm_condition < delta
        break;
    end

    z = z_new;
end

% Cleaning values
necessary = 1;

if necessary == 1
    for i=1:q
        for j=1:q
            if abs(z_new(p+i,j)) < tol
                z_new(p+i,j) = 0;
            end
        end
    end
    for i=1:q
        z_new(1:p,i) = max_filter(z_new(1:p,i),n_targets,1);
    end
end

%% Plot
S = D;
L = 10;
H = 10;
W = H*L;
room_grid = zeros(2,p);
for i=1:p
    room_grid(1,i) = floor(W/2)+ mod(i-1,L)*W; 
    room_grid(2,i) = floor(W/2)+ floor((i-1)/L)*W;
end
for i = 1:25
        S(i,:) = max_filter(D(i,:),1,0);
        pos(i,1) = find(S(i,:));
    end
for i = 1:25
    occorrenze(i,1) = sum(pos == pos(i));
end

x_obtained = z_new(1:p,1);
target = find(x_obtained);
sensor = z_new(p+1:p+q,1);
our_sensor = find(sensor);
figure(1);
plot(room_grid(1,target), room_grid(2,target),'d','MarkerSize',12, 'MarkerEdgeColor',1/255*[40 208 220])
hold on
grid on
plot(room_grid(1,pos(our_sensor)), room_grid(2,pos(our_sensor)),'*','MarkerSize',12, 'MarkerEdgeColor',[0 1 0])
grid on
pos = plot_sensor(D, room_grid,q,occorrenze);
grid on
legend('Targets','Attacks','Sensors','Location','eastoutside')
xticks(100:100:1000)
yticks(100:100:1000)
axis([0 1000 0 1000])
axis square

figure(2);
% Primo subplot
subplot(2,2,1); % 2 righe, 2 colonne, primo subplot
plot(digraph(Q_4'));
title('Q_4');

% Secondo subplot
subplot(2,2,2); % 2 righe, 2 colonne, secondo subplot
plot(digraph(Q_8'));
title('Q_8');

% Terzo subplot
subplot(2,2,3); % 2 righe, 2 colonne, terzo subplot
plot(digraph(Q_12'));
title('Q_{12}');

% Quarto subplot
subplot(2,2,4); % 2 righe, 2 colonne, quarto subplot
plot(digraph(Q_18'));
title('Q_{18}');



%% Debug

x = z_new(1:p,:);
a = z_new(p+1:p+q,:);

if debug == 1
    x
    a
    T
end
