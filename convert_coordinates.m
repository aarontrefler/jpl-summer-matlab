function [ lat, lon ] = convert_coordinates( d1, d2 )
%convert_coordinates: Converts (x,y) coordinates from GRACE MASCON to
%latitude and longitude values.
%   Parameters
%   d1: lon-coordinate (1 to 720)
%   d2: lat-coordinate (1 to 360)

% latitude conversion
lat = ((d2/2) - 90) * -1;

% longitude conversion
lon = d1/2;
if lon > 180
    lon = lon - 360;
end

% display input
disp(['GRACE d1-coordinate: ', num2str(d1)]);
disp(['GRACE d2-coordinate: ', num2str(d2)]);

% display output
disp(['latitude: ', num2str(lat)]);
disp(['longitude: ', num2str(lon)]);

end

