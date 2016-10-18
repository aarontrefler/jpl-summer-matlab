% Aaron Trefler
% JPL
% Created: 2016/07/06

%% load variaables
load directories.mat
load([dir_save,'grace_features.mat'], 'lwe_noClim_norm')
load([dir_save,'grace_land_mask.mat'], 'land_mask')

%% script variables
data = lwe_noClim_norm;
dim = size(data);
d1 = dim(1);
d2 = dim(2);
tp = dim(3);

%% calculate line of best fit for each grid cell
[intercept, slope] = apply_regression(data);

%% calculate estimates
est = ones(dim);
for i = 1:tp
    est(:,:,i) = est(:,:,i) * i;
end

slope_brick = repmat(slope,1,1,tp);
intercept_brick = repmat(slope,1,1,tp);
est = est .* slope_brick + intercept_brick;

%% calculate residuals
res = data - est;

%% preprocessing visualization for single grid cell
%{
% grid point: Aripuana, State of Mato Grosso, Brazil
% latitude: -10  (300)
% longitude: -60 (250)
grace_lat = 300;
grace_lon = 250;

data_ts = squeeze(squeeze(data(grace_lon,grace_lat,:)));
est_ts = squeeze(squeeze(est(grace_lon,grace_lat,:)));
res_ts = squeeze(squeeze(res(grace_lon,grace_lat,:)));

subplot(3,1,1);
plot(data_ts)
ylim([-3, 3])
title('GRACE Normalized with Climatology Removed')
subplot(3,1,2);
plot(est_ts)
ylim([-3, 3])
title('Linear Fit')
subplot(3,1,3);
plot(res_ts)
ylim([-3, 3])
title('Residuals')
%}

%% auto-correlate residuals
num_lags = 12;
num_lags_ts = num_lags + 1;
xcorr_brick = zeros(d1,d2,num_lags_ts);

for i = 1:d1
    for j = 1:d2
        ts = squeeze(squeeze(res(i,j,:)));
        r = xcorr(ts, ts, num_lags, 'coeff');
        r = r(end-num_lags:end);
        xcorr_brick(i,j,:) = r;
    end
end

%% visualize auto-correlational results
subplot(2,3,1)
plot_mascon(xcorr_brick(:,:,1),'Residual Auto-Correlation: Time Lag 0',[0 1],'R-Value')
subplot(2,3,2)
plot_mascon(xcorr_brick(:,:,2),'Residual Auto-Correlation: Time Lag 1',[0 1],'R-Value')
subplot(2,3,3)
plot_mascon(xcorr_brick(:,:,3),'Residual Auto-Correlation: Time Lag 2',[0 1],'R-Value')
subplot(2,3,4)
plot_mascon(xcorr_brick(:,:,4),'Residual Auto-Correlation: Time Lag 3',[0 1],'R-Value')
subplot(2,3,5)
plot_mascon(xcorr_brick(:,:,5),'Residual Auto-Correlation: Time Lag 4',[0 1],'R-Value')
subplot(2,3,6)
plot_mascon(xcorr_brick(:,:,6),'Residual Auto-Correlation: Time Lag 5',[0 1],'R-Value')

%% visualize time-series of auto-correlational drop off
xcorr_perc_above_thresh = zeros(num_lags_ts,1);
num_land_cells = sum(sum(land_mask));

figure;
plt_idx = 1;
for thresh = [0.9 0.8 0.7 0.6 0.5 0.4 0.3 0.2 0.1]
    for i = 1:num_lags_ts
        xcorr_perc_above_thresh(i) = ...
            (sum(sum(xcorr_brick(:,:,i) > thresh)) / num_land_cells) * 100;
    end
    subplot(3,3,plt_idx);
    plt_idx = plt_idx + 1;
    
    % plot auto-correlational drop-off time-series
    plot(0:num_lags , xcorr_perc_above_thresh,...
        'LineWidth', 1.5,...
        'Marker','.','MarkerSize',25);
    xlim([0 num_lags])
    ylim([0 100])
    title(['Residual Auto-Correlation R-Value > ',num2str(thresh)])
    xlabel('Time Lag')
    ylabel('Percent of Land Cells Above Threshold')
    
    
end




%% Calculate Covariance Matrix
%{
% reshape residual matrix
res_2d = reshape(res,[259200,1,152]);
res_2d = squeeze(res_2d);

% calcualte covariance matrix
res_coVar = res_2d * res_2d';
%}