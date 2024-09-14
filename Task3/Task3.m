%% ----------------------------------------------
%  Task 3: Target localization under sparse sensor attacks
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
p = 100;                % #cells
q = 25;                 % #sensors
eps = 1e-8;
delta = 1e-12;
debug = 0;

load("localization.mat");

% x_tilde = randn(p,1);
G = normalize([D eye(q)]);
tau = norm(G)^(-2) - eps;
lambda = [10 20];
Gamma = tau * [lambda(1)*ones(p, 1); lambda(2)*ones(q, 1)];
z = zeros(q+p,1);

%% ISTA
while 1
    z_new = thresholding(z + tau*G'*( y - G*z ) , Gamma);
    norm_difference_squared = norm(z_new - z);
    z = z_new;

    if norm_difference_squared < delta
        break
    end
end

% Zerofying numbers under a threshold (tol)
tol = 4;
necessary = 1;

if necessary == 1
    for i=1:(p+q)
       if abs(z_new(i)) < tol
            z_new(i)=0;
        end
    end
end


%% Debug

if debug == 1
    z_new
end

x = z_new(1:p);             % supp(x) = [23, 36, 87]
a = z_new(p+1:p+q);         % supp(a) = [12, 16]


%% K-NN Algorithm
% We consider the system as attacks-free because k-NN requires to know
% apriori how any attacks there are, but this is not realistic

k = 3;
min = 9999999999;
argmin = [-1, -1, -1]';

for i=1:p
    for j=1:p
        for l=1:p
            val = norm(D(:,i) + D(:,j) + D(:,l) - y)^2;
            if val < min
                min = val;
                argmin = [i, l, j]'; 
            end
        end
    end
end

% Note that instead of support equal to [23, 36, 87] just like ISTA, k-NN
% algorithm has suppport [23, 46, 87]. This is because it consider the
% state of sensor like they were attacks-free
