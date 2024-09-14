% This function compares the values of x with the corresponding ones 
% of gamma in order to compute S_gamma in the ista algorithm 

function out = thresholding(x,gamma)
    l = length(x);
    out = zeros(l,1);
    
    for i= 1:length(x)
        gamma(i);
       if x(i)>gamma(i)
           out(i)= x(i) - gamma(i);
       
       elseif x(i) < -gamma(i)
           out(i)= x(i) + gamma(i);
       
       else 
           out(i)=0;
       end        
    end
end

