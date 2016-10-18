% Aaron Trefler
% 2016-06-22
% calculate_grace_features: Calculates derived values of lwe thickness.

%% Load Data
% data produced by GRACE_import_CRI.m from Geoscience analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02.nc.mat
load ../Data/LAND_MASK.CRIv01.nc.mat
% data produced by create_dateVectors.m from JPL analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02_dateVectors.nc.mat
load directories.mat

%% Script Variables
tps = length(time_month);

%% Calculate Percentiles
lwe_thickness_percentiles = zeros(720,360,tps);
for i = 1:720
    for j = 1:360
        x = lwe_thickness(i,j,:);
        x = squeeze(squeeze(x));
        p = (tiedrank(x) / length(x)) * 100;
        lwe_thickness_percentiles(i,j,:) = p; 
    end
end

%% Calculate Monthly Climatology
% create empty monthly climatology brick
climatology_monthly = zeros(720,360,12);
for i=1:12
    % create binary vector for month
    climatology_monthly_idx = (time_month == i);

    % average all monthly maps
    climatology_monthly_mascons = ...
        lwe_thickness(:,:,climatology_monthly_idx);
    climatology_monthly_mascons_mean = mean(climatology_monthly_mascons,3);

    % add monthly map to brick
    climatology_monthly(:,:,i) = climatology_monthly_mascons_mean;
end

%% Calculate Climatology (match MASCON timeseries)
% create empty climatology brick
climatology = zeros(720,360,tps);
for i=1:tps
    % add monthly map to climatology brick
    climatology(:,:,i) = climatology_monthly(:,:,time_month(i));
end

%% Calculate LWE - Climatology Standard Devs
lwe_thickness_climRem = lwe_thickness - climatology;
lwe_thickness_climRemStd = lwe_thickness_climRem ./ ...
    repmat(std(lwe_thickness,0, 3),1,1,tps);

%% Apply Naming Conventions
lwe = lwe_thickness;
lwe_perc = lwe_thickness_percentiles;
lwe_clim = climatology;
lwe_noClim = lwe_thickness_climRem;
lwe_noClim_std = lwe_thickness_climRemStd;

%% Apply Land Mask (move to a function)
land_mask_brick = repmat(land_mask,1,1,tps);

lwe = lwe .* land_mask_brick;
lwe(lwe==0) = NaN;
lwe_perc = lwe_perc .* land_mask_brick;
lwe_perc(lwe_perc==0) = NaN;
lwe_clim = lwe_clim .* land_mask_brick;
lwe_clim(lwe_clim==0) = NaN;
lwe_noClim = lwe_noClim .* land_mask_brick;
lwe_noClim(lwe_noClim==0) = NaN;
lwe_noClim_std = lwe_noClim_std .* land_mask_brick;
lwe_noClim_std(lwe_noClim_std==0) = NaN;

%% Save Maps
save_file = [dir_save,...
    'grace_features.mat'];

save(save_file,...
    'lwe',...
    'lwe_perc',...
    'lwe_clim',...
    'lwe_noClim',...
    'lwe_noClim_std');