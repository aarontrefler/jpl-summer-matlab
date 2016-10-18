function [ ] = plot_mascon_lowres( X, ttl, clims, clr_cont )
% Aaron Trefler
% 2016-06-17
% plot_mascon: Plots a GRACE Mascon data matrix for entire world.
%
% Parameters
% (1) X: data
% (2) ttl: title (opt)
% (3) clims: color range (opt)
% (4) clr_ttl: colorbar title (opt)

% fill in unset optional values.
switch nargin
    case 1
        ttl = 'GRACE MASCON';
end

% apply landmask
load(['/Users/aarontrefler_temp2/Documents/',...
    'Work : Education/Education/School_Post_UCLA_Pre_UCSD/',...
    'CSULA/NASA-STEM JPL/JPL/Work_Matlab/Data/LAND_MASK.CRIv01.nc.mat']);
%X(X==0) = NaN;

% alter matrix
X = X';         %swith x and y axis
X = flipud(X);  %flip matrix about horizontal

% define color map
if (exist('clr_cont','var'))
    cmap = [1 1 1; 0.9 0.9 0.9; jet(101)];
else
    cmap = [1 1 1; 0.9 0.9 0.9; 0 1 1; 0 0 0; 1 0 0];
end

% set plotting parameters
plot_titleSize = 15;
colormap(cmap);

% plot
if (exist('clims','var'))
    imagesc(X, clims);
else
    imagesc(X);
end
title(ttl, 'FontSize', plot_titleSize);
h = colorbar;
grid;
grid minor;

% grid line style
ax = gca;
ax.GridLineStyle = '--';

end

