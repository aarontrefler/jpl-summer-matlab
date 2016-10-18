function [ ] = plot_gridPoint_timeSeries( d1, d2 )
% Aaron Trefler
% 2016-06-21
% plot_gridPoint_timeSeries: Plots GRACE time series for given grid value.
%
% Notes:
% - Plots time series for several steps of prcoessing

%% Load Data
% raw grace data
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02.nc.mat

% derived grace data maps
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02_derivedMaps.nc.mat

%%
figure;
subplot(4,1,1)
plot(squeeze(lwe_thickness(d1,d2,:)))
title('LWE')

subplot(4,1,2)
plot(squeeze(lwe_thickness_climatology(d1,d2,:)))
title('Climatology')
subplot(4,1,3)
plot(squeeze(lwe_thickness_climRem(d1,d2,:)))
title('LWE - Climatology')
subplot(4,1,4)
plot(squeeze(lwe_thickness_climRemStd(d1,d2,:)))
title('Normalized: LWE - Climatology')