% Aaron Trefler
% Created: 2016-07-07
% analysis_visualize_floods: Creates mascon images that show grid-cells
% that have a value above one standard deviation, that will experience 
% flooding, and where both the above conditions are true.
%
% Note:
% bash command to turn png vides into movie
%   -framerate 1/2.5 -i map_%03d.png -c:v libx264 -r 30 -pix_fmt yuv420p 
%   out_2_5.mp4

%% User Variables 
data_name = 'lwe_rank_norm';

%% Load Data
load directories.mat
load([dir_save,'grace_features.mat'], data_name);
load([dir_save,'LAND_MASK.CRIv01.nc.mat'], 'land_mask');
load([dir_save,'grace_dateVectors.mat'], 'time_datestr_cell')

%% Script Variables
% grace
data = eval(data_name);
dim = size(data);
d1 = dim(1);
d2 = dim(2);
tp = dim(3);

% flood dataframe
flood_records = 2445;

%% Create Mask for GRACE Values Above 1 std
mask_values = (data > 1);
mask_values = double(mask_values);

%% Create Mask for Upcomming Flood Events

% load flood dataframe
data_floods =...
    csvread([dir_python_data,...
    'df_flood_graceLon_graceLat_priorMasconIdx.csv'],...
    1,0);

% rename variables
lon = data_floods(:,2); % first column is flood event indices
lat = data_floods(:,3);
mascon_idx = data_floods(:,4);

% change from zero-index to one-index
lon = lon + 1;
lon(lon > 720) = 720;
lat = lat + 1;
mascon_idx = mascon_idx + 1;

% create empty mask brick
mask_floods = zeros(dim);

% create upcomming flood mask
for i = 1:flood_records
    mask_floods(lon(i),lat(i),mascon_idx(i)) = 1;
end

%% Re-scale Mascons (by a factor of 6)
land_mask_rs = convert_mascon_lowres(land_mask);
mask_values_rs = convert_mascon_brick_lowres(mask_values);
mask_floods_rs = convert_mascon_brick_lowres(mask_floods);

dim_rs = size(land_mask_rs);

%% Binarize Masks
land_mask_rs = double(land_mask_rs > 0);
mask_values_rs = double(mask_values_rs > 0);
mask_floods_rs = double(mask_floods_rs > 0);

%% Visualize Overlayed Maps

% create map visualization brick
vis_brick = zeros(dim_rs);
for i = 1:tp
    vis = land_mask_rs + mask_values_rs(:,:,i);
    vis_brick(:,:,i) = vis + (mask_floods_rs(:,:,i)) .* 2; 
end

% visualize flood-grace maps
for i = 1:tp
    plot_mascon_lowres(vis_brick(:,:,i),time_datestr_cell{i},[0 5])
    
    title_num = sprintf('%3.3d',i);
    saveas(gcf,[dir_figures,'analysis_visualize_floods/',...
        'analysis_visualize_floods_maps_',data_name,'/',...
        num2str(title_num),'.png'])
    close all
end

%% Hit Frequency Maps

% total floods
total_floods = sum(mask_floods_rs,3);
% hits
total_hits = sum(double(vis_brick == 4),3);

% accuracy
acc = (total_hits ./ total_floods) * 100;
acc(isnan(acc)) = -1;

% plots
subplot(2,1,1)
plot_mascon_lowres(acc+land_mask_rs,'Accuracy',[-1 100], 1);
subplot(2,1,2)
plot_mascon_lowres(total_floods+(land_mask_rs*0.3),'Total Floods',...
    [0 25], 1);
