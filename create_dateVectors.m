% Aaron Trefler
% 2016-06-06
% Convert GRACE monthly time values to associated date vectors

% data produced by GRACE_import_CRI.mat from Geoscience analysis
load ../Data/GRCTellus.JPL.200204_201603.GLO.RL05M_1.MSCNv02CRIv02.nc.mat

% create date vector
time_datenum = ones(length(time),1) .*  datenum('00:00:00 01-01-2002');
for i = 1:length(time)
    time_datenum(i,1) = addtodate(time_datenum(i), int64(time(i)), 'day');
end
time_datestr = datestr(time_datenum(:));
time_datestr_cell = cellstr(time_datestr);

DV = datevec(time_datenum);
DV = DV(:, 1:3); %extract year, month, day

DV2 = DV;
DV2(:, 2:3) = 0; %set all values to be beginning of respective year

time_dayOfYear = datenum(DV) - datenum(DV2); %number of days since the beginning of year
time_year = DV(:,1);
time_month = DV(:,2);