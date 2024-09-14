%% ----------------------------------------------
%  Task 4: Sparse observer
%  Creators: Federico Paglialunga - s328876
%            Luigi Graziosi - s331564
%            Marco Luppino - s333997
%
%  Last modification date:  16/06/2024
% -----------------------------------------------
%% ----------------------------------------------
clear
close all
clc


%% Hyperparameters
p = 100;                % #cells
q = 25;                 % #sensors
eps = 1e-8;
delta = 1e-12;
n_iter = 50;
debug = 0;

% Controls on aware attacks
aware = 1;
change_sensors = 1;

% Loading data
load("tracking_moving_targets.mat");
load("z_estim.mat");
init_cond = z_estim(1:100);

% Variables
G = normalize([D eye(q)]);
tau = norm(G)^(-2) - eps;
lambda = [10 20];
Gamma = tau * [lambda(1)*ones(p, 1); lambda(2)*ones(q, 1)];
n_targets = 3;
n_attacks = 15;

%% Aware attack
% ---In this part we define x_true with 3 (n_targets) targets and 
% 2 (n_attacks) aware attacks on sensors

if aware
    noise = 1e-2*randn(q,1);
    
    supp_x_true = randperm(p,n_targets);
    x_true = zeros(p,1);
    x_true(supp_x_true) = 1;
    init_cond = x_true;
    x_true = A*x_true;                  % Strictly for plot reasons
    supp_a_true = sort(randperm(q,n_attacks));
    
    Y = zeros(size(Y));
    % n = randperm(n_iter,1);

    for i=1:n_iter
       Y(:,i) = D*x_true+noise;
       Y(:,i) = aware_attack(2, q, Y(:,i), supp_a_true);
       x_true = A*x_true;
       if change_sensors && i==n_iter/2
           supp_a_true = randperm(q,n_attacks);
       end
    end
end


%% Sparse observer
z_hat = zeros(p+q,1);
Z_matrix = zeros(p+q, n_iter);

for i=1:n_iter
    z_plus = thresholding(z_hat+tau*G'*(Y(:,i)-G*z_hat), Gamma);

    % Create matrix with max-three values filter for graphical
    % representation
    Z_matrix(:,i) = [
        max_filter(z_hat(1:p),n_targets,1); 
        max_filter(z_hat(p+1:p+q),n_attacks,1)
        ];

    % Update of x_hat and a_hat
    z_hat = [A*z_plus(1:p); z_plus(p+1:p+q)];
end


%% Debug
x_hat = A*Z_matrix(1:p, n_iter);
a_hat = Z_matrix(p+1:p+q, n_iter);

if debug == 1
    Z_matrix
    x_hat'
    a_hat'
end


%% Plot position matrix
plot_field(p, q, 10, 10, Z_matrix, n_iter, find(init_cond));

% Note: it converges at time 24
