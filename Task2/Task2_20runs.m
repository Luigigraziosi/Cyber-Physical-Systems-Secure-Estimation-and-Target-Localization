%% ----------------------------------------------
%  Task 2: Secure estimation under sparse sensor attacks
%  Creators: Federico Paglialunga - s328876
%            Luigi Graziosi - s331564
%            Marco Luppino - s333997
%
%  Last modification date:  29/06/2024
% -----------------------------------------------
%% This file is a wrapper for task 2 in the two situations of aware and 
% unaware attacks to collect statisticks about what happens

close all
clc

%% Unaware sparse attacks
clear

times = 20;
cus = 0;                 % Correct Unaware (attacks) Support
dist = 0;                % Distance
estim_rate = zeros(times,1);

for i=1:times
    run("Task2_unaware.m");
    if length(find(a)) == length(find(a_estimated))
        if find(a) == find(a_estimated)
            cus = cus + 1;
        end
    end
    
    dist = dist + norm(x_tilde-x)^2;
end

unaware_rate = cus/times;
mean_dist = dist/times;

fprintf("\tUnaware\nThe rate of correct attacks support is: %.2f\n", unaware_rate);
% The rate of correct attacks support is: 0.85
fprintf("The mean distance is: %.3f\n", mean_dist);
% The mean distance is: 0.029

%% Aware sparse attacks
times = 20;
cas = 0;                 % Correct Aware (attacks) Support
dist = 0;                % Distance
estim_rate = zeros(times,1);

for i=1:times
    run("Task2_aware.m");
    if length(find(a)) == length(find(a_estimated))
        if find(a) == find(a_estimated)
            cas = cas + 1;
        end
    end

    dist = dist + norm(x_tilde-x)^2;
end

aware_rate = cas/times;
mean_dist = dist/times;

fprintf("\n\tAware\nThe rate of correct attacks support is: %.2f\n", aware_rate);
% The rate of correct attacks support is: 0.50
fprintf("The mean distance is: %.3f\n", mean_dist);
% The mean distance is: 0.065

%% Plot
figure(1)
bar(["unaware" "aware"],100*[unaware_rate aware_rate]);
grid on