function [ X_rs ] = convert_mascon_brick_lowres( X )
% convert_mascon_brick_lowres: converts a mascon brick from 0.5x0.5 to 
% native 3x3 degree resolution
%
% Aaron Trefler
% Created: 2016-07-10
%
% Parameters
% (1) X: mascon data brick

dim = size(X);
d1 = dim(1);
d2 = dim(2);
tp = dim(3);

X_rs = zeros(d1/6,d2/6,tp);
for i = 1:tp
    for j = 1:6:d1
        idx_1 = (j+5)/6;

        for k = 1:6:d2  
            idx_2 = (k+5)/6;
            
            X_rs(idx_1,idx_2,i) = ...
                mean(mean(X(j:j+5,k:k+5,i)));
        end
    end
end

end

