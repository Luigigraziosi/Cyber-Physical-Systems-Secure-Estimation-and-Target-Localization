%% Hyperparameters
q =20;
n = 10;
h = 2;
C = randn(q, n);
eps = 1e-8;
tau = norm(C)^(-2) - eps;
lambda = 2/1000/tau;
nu = 1e-2 * randn(q,1);
delta = 1e-12;
debug = 0;

%% Definition of variables
x_tilde = randn(n,1);
a = unif_funct(h,q);

G = [C eye(q)];
z_tilde = [x_tilde; a];

y = G*z_tilde + nu;
z = zeros(n+q,1);

Gamma = lambda*tau*[zeros(n,1); ones(q,1)];

%% ISTA
T = 0;      % Counter

while 1
    z_new= thresholding(z + tau*G'*(y - G*z), Gamma);
    norm_difference = norm(z_new - z);
    z = z_new;
    T = T + 1;
    if norm_difference < delta
        break
    end
end


%% Debug
x = z_new(1:n);
a_estimated = z_new(n+1:n+q);

if debug == 1
    x_tilde'
    x'
    a'
    a_estimated'
end
