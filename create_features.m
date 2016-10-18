% Aaron Trefler
% Created: 2016-06-22
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
lwe = lwe_thickness;

%% Calculate LWE Ranked
lwe_rank = zeros(720,360,tps);
for i = 1:720
    for j = 1:360
        x = lwe(i,j,:);
        x = squeeze(squeeze(x));
        rank = tiedrank(x);
        lwe_rank(i,j,:) = rank; 
    end
end

%% Calculate LWE Climatology

% calculate monthly climatology
climatology_monthly = zeros(720,360,12);

for i=1:12
    % create logical vector for month
    climatology_monthly_idx = (time_month == i);

    % average all monthly maps
    climatology_monthly_mascons = ...
        lwe_thickness(:,:,climatology_monthly_idx);
    climatology_monthly_mascons_mean = mean(climatology_monthly_mascons,3);

    % add monthly map to brick
    climatology_monthly(:,:,i) = climatology_monthly_mascons_mean;
end

% calculate LWE Climatology
lwe_clim = zeros(720,360,tps);
for i=1:tps
    % add monthly map to climatology brick
    lwe_clim(:,:,i) = climatology_monthly(:,:,time_month(i));
end

%% Calculate LWE Climatology Ranked
lwe_clim_rank = zeros(720,360,tps);
for i = 1:720
    for j = 1:360
        x = lwe_clim(i,j,:);
        x = squeeze(squeeze(x));
        [~,~,rank] = unique(x);
        lwe_clim_rank(i,j,:) = rank; 
    end
end

%% Calculate LWE - Climatology
lwe_noClim = lwe - lwe_clim;

%% Calculate LWE - Climatology Ranked
lwe_noClim_rank = zeros(720,360,tps);
for i = 1:720
    for j = 1:360
        x = lwe_noClim(i,j,:);
        x = squeeze(squeeze(x));
        rank = tiedrank(x);
        lwe_noClim_rank(i,j,:) = rank; 
    end
end

%% Calculate LWE Derivative
lwe_dt = diff(lwe,1,3);

%% Normalize LWE Metrics
lwe_norm = normalize_grace_metric(lwe);
lwe_rank_norm = normalize_grace_metric(lwe_rank);
lwe_clim_norm = normalize_grace_metric(lwe_clim);
lwe_clim_rank_norm = normalize_grace_metric(lwe_clim_rank);
lwe_noClim_norm = normalize_grace_metric(lwe_noClim);
lwe_noClim_rank_norm = normalize_grace_metric(lwe_noClim_rank);
lwe_dt_norm = normalize_grace_metric(lwe_dt);

%% Apply Land Mask

% continous
lwe = apply_land_mask(lwe, land_mask);
lwe_norm = apply_land_mask(lwe_norm, land_mask);
lwe_clim_norm = apply_land_mask(lwe_clim_norm, land_mask);
lwe_noClim_norm = apply_land_mask(lwe_noClim_norm, land_mask);
lwe_dt = apply_land_mask(lwe_dt, land_mask);
lwe_dt_nrom = apply_land_mask(lwe_dt_norm, land_mask);

% ranked
lwe_rank = apply_land_mask(lwe_rank, land_mask);
lwe_rank_norm = apply_land_mask(lwe_rank_norm, land_mask);
lwe_clim_rank = apply_land_mask(lwe_clim_rank, land_mask);
lwe_noClim_rank = apply_land_mask(lwe_noClim_rank, land_mask);
lwe_clim_rank_norm = apply_land_mask(lwe_clim_rank_norm, land_mask);
lwe_noClim_rank_norm = apply_land_mask(lwe_noClim_rank_norm, land_mask);


%% Save Maps
save_file = [dir_save,...
    'grace_features.mat'];

save(save_file,...
    'lwe',...
    'lwe_clim',...
    'lwe_noClim',...
    'lwe_norm',... 
    'lwe_clim_norm',...
    'lwe_noClim_norm',...
    'lwe_dt',...
    'lwe_dt_norm',...
    'lwe_rank',... 
    'lwe_rank_norm',...
    'lwe_clim_rank',...
    'lwe_clim_rank_norm',...
    'lwe_noClim_rank',...
    'lwe_noClim_rank_norm')
