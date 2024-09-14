%% Hyperparameters

if mod(runs,20) == 0
    q = q+1;
end
p = 20;
C = randn(q, p);
% load("Datatask1.mat");
eps = 1e-8;
tau = norm(C) ^(-2)- eps;

k = 2;
lambda = 1/(100*tau);
% lambda = 0.1*rand(1); 
gamma = (lambda*ones(1,p))*tau;
nu = 1e-2 * randn(q,1);
debug = 0;

%% Definition of variables
% S = unifrnd(1,2,k,1);
% x_tilde = [S; zeros(p-k , 1)];
x_tilde= unif_funct(k,p);

x=zeros(p,1);
delta=1e-12;
y = C * x_tilde + nu;

%% ISTA
T = 0;          % Counter

while 1
    x_new= thresholding(x + tau*C'*( y - C*x ) , gamma);
    norm_difference = norm(x_new - x);
    x = x_new;
    T = T + 1;
    if norm_difference < delta
        break
    end
end

% Zerofying numbers under a threshold (tol)
tol = 0.05;
necessary = 1;

if necessary == 1
    for i=1:p
       if abs(x_new(i)) < tol
            x_new(i)=0;
        end
    end
end


%% Debug
if debug == 1
    x_new'
    x_tilde'
end

runs = runs+1;