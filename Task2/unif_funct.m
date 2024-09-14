% This function needs to create k values in the range [-2,-1] U [1,2]
% and insert in a Zero vector of p elements in random positions

function res = unif_funct(k, p)
    res = zeros(p, 1);
    list_of_values = zeros(k, 1);
    
    % Creation of k random values with unifrnd(..) in [-2,-1] U [1,2]
    for i=1:k
        tmp =  2*randi([0,1]) - 1;
        list_of_values(i) = tmp * unifrnd(1, 2);
    end

    % Randomly insert of k values in res vector
    supp_a = sort(randperm(p,k));
    for i=1:k
        res(supp_a(i)) = list_of_values(i);
    end

end