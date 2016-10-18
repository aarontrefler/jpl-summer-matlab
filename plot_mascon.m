function [ ] = plot_mascon( X, ttl, clims, clr_ttl )
% Aaron Trefler
% 2016-06-17
% plot_mascon: Plots a GRACE Mascon data matrix for entire world.
%
% Parameters
% (1) X: data
% (2) ttl: title (opt)
% (3) clims: color range (opt)
% (4) clr_ttl: colorbar title (opt)

% new figure
%figure;

% fill in unset optional values.
switch nargin
    case 1
        ttl = 'GRACE MASCON';
end

% apply landmask
load(['/Users/aarontrefler_temp2/Documents/',...
    'Work : Education/Education/School_Post_UCLA_Pre_UCSD/',...
    'CSULA/NASA-STEM JPL/JPL/Work_Matlab/Data/LAND_MASK.CRIv01.nc.mat']);
X = X .* land_mask;
X(X==0) = NaN;

% alter matrix
X = X';         %swith x and y axis
X = flipud(X);  %flip matrix about horizontal

% make NaN values plot as grey
ddd=[0.9 0.9 0.9;jet(10000)];

% set plotting parameters
plot_titleSize = 15;
colormap(ddd);

% plot
if (exist('clims','var'))
    imagesc(X, clims);
else
    imagesc(X);
end
title(ttl, 'FontSize', plot_titleSize);
%xlabel('Longitude');
%ylabel('Latitude');
h = colorbar;
if (exist('clr_ttl', 'var'))
    ylabel(h, clr_ttl);
end
grid;
grid minor;

%{
% set axes tiks
ax = gca;
ax.XTick = 1:40:360;
ax.XTickLabel = {'20E' '40E' '60E' '80E' '100E' '120E' '140E'...
    '160E' '180'};
ay = gca;
ay.YTick = 1:10:81;
ay.YTickLabel = {'80N' '75N' '70N' '65N' '60N' '55N' '50N' '45N' '40N'};
%}

% grid line style
ax = gca;
ax.GridLineStyle = '--';

end

