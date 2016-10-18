function [ X_rs ] = convert_mascon_lowres( X )
% convert_mascon_lowres: converts a mascon from 0.5x0.5 to native 3x3 
% degree resolution
%
% Aaron Trefler
% Created: 2016-07-10
%
% Parameters
% (1) X: mascon map

dim = size(X);
d1 = dim(1);
d2 = dim(2);

X_rs = zeros(d1/6,d2/6);
for j = 1:6:d1
    idx_1 = (j+5)/6;

    for k = 1:6:d2  
        idx_2 = (k+5)/6;
        X_rs(idx_1,idx_2) = ...
            mean(mean(X(j:j+5,k:k+5)));
    end
end

end

