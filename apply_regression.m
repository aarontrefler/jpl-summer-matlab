function [ intercept, slope ] = GRACE_regression( grace_data )
% GRACE_regression: This function takes a GRACE dataset (3 dimensions: 
% lat, long, time) and outputs the slopes and intercepts derived from 
% running a linear regression showing the relationship for each lat-x- 
% long value with time.
%
%   Input:
%   X: 3-dimensional dataset
%   
%   Output:
%   intercept: 2-dimensional matrix of intercepts values
%   slope: 2-dimensional matrix of slope values

[lat,lon,tps] = size(grace_data);

X = [ones(tps,1),(1:tps)'];

slope = zeros(lat,lon);
intercept = zeros(lat,lon);

for i=1:lat
    for j=1:lon
        y = squeeze(grace_data(i,j,:));
        b = X\y;
        intercept(i,j) = b(1);
        slope(i,j) = b(2);
    end
end

end

