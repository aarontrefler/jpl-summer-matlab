% Aaron Trefler
% 2016-06-21
% create_climRemMaps: Removes climatology from GRACE values.

%% Load Data

% data produced by GRACE_import_CRI.m from Geoscience analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02.nc.mat
load ../Data/LAND_MASK.CRIv01.nc.mat

% data produced by create_dateVectors.m from JPL analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02_dateVectors.nc.mat

% directories
load directories.mat

%% Script Variables
tps = length(time_month);

%% Create Average Monthly Maps
% create empty monthly climatology brick
climatology_monthly = zeros(720,360,12);

for i=1:12
    % create binary vector for january
    climatology_monthly_idx = (time_month == i);

    % average all monthly maps
    climatology_monthly_mascons = ...
        lwe_thickness(:,:,climatology_monthly_idx);
    climatology_monthly_mascons_mean = mean(climatology_monthly_mascons,3);

    % save monthly map
    climatology_monthly(:,:,i) = climatology_monthly_mascons_mean;
end
clear climatology_monthly_mascons
clear climatology_monthly_mascons_mean
clear climatology_monthly_idx


%% Match Monthly Climatology Maps with GRACE MASCONS
% create empty climatology brick
climatology = zeros(720,360,tps);

% add monthly maps to climatology brick
for i=1:tps
    climatology(:,:,i) = climatology_monthly(:,:,time_month(i));
end
% rename climatology brick
lwe_thickness_climatology = climatology;

%% Remove Climatolgy from GRACE Values
lwe_thickness_climRem = lwe_thickness - climatology;


%% Adjust Climatology Maps
lwe_thickness_climRem_adj = adjust_mascon(lwe_thickness_climRem);
lwe_thickness_climatology_adj = adjust_mascon(lwe_thickness_climatology);

%% Save Maps


save_file = [dir_save,...
    'GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02',...
    '_derivedMaps.nc.mat'];

save(save_file,...
    'lwe_thickness_climRem',...
    'lwe_thickness_climRem_adj',...
    'lwe_thickness_climatology',...
    'lwe_thickness_climatology_adj',...
    '-append');


 
 
 