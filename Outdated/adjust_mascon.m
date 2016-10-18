function [ mascon_adj ] = adjust_mascon( mascon )
%mascon_adj: Adjust GRACE CRI MASCON to be used in Python code.
%   Adjustments
%   (1) apply land mask
%   (2) alter dimensions so i displays properly as a 2D-geogrpahical map
%   (3) convert ocean values to -1

% load land mask
load ../Data/LAND_MASK.CRIv01.nc.mat

% calculate GRACE MASCON dimensions
[d1, d2, d3] = size(mascon);

% apply land mask
X = mascon;
X = X .* repmat(land_mask,1,1,d3);

% ajust matrix so it displays properly as a 2D-geogrpahy map
X = permute(X,[2,1,3]);
X = flipud(X);

% make ocean values negative
X(X == 0) = -1;

% create adjusted map
mascon_adj = X;

end

