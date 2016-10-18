% Aaron Trefler
% 2016-06-09
% create_percentileMaps: converts GRACE values to percentiles

%% Load Data
% data produced by GRACE_import_CRI.m from Geoscience analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02.nc.mat
load ../Data/LAND_MASK.CRIv01.nc.mat

%% Directories
load directories.mat

%% Create Percentile Maps
lwe_thickness_percentiles = zeros(720,360,152);

for i = 1:720
    for j = 1:360
        x = lwe_thickness(i,j,:);
        x = squeeze(squeeze(x));
        p = (tiedrank(x) / length(x)) * 100;
        lwe_thickness_percentiles(i,j,:) = p; 
    end
end

%% Adjust Percentile Maps
lwe_thickness_percentiles_adj = adjust_mascon(lwe_thickness_percentiles);

%% Save Percentile Maps
save_file = [dir_save,...
    'GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02',...
    '_derivedMaps.nc.mat'];

save(save_file,...
    'lwe_thickness_percentiles',...
    'lwe_thickness_percentiles_adj',...
    '-append');