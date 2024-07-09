data = load('aaa.mat');

num_points_interp = 30;

tdist = sum(distance(data.latitude(1:end-1), data.longitude(1:end-1), data.latitude(2:end), data.longitude(2:end)));
interpolation_distance = tdist / ((numel(data.latitude) - 1) * num_points_interp);
[interp_lat, interp_lon] = interpm(data.latitude, data.longitude, interpolation_distance);

player1 = geoplayer(data.latitude(1), data.longitude(1), 15, 'Basemap', 'satellite');

plotRoute(player1, interp_lat, interp_lon, "Color", "m");

% Function to calculate Haversine distance
haversine_distance = @(lat1, lon1, lat2, lon2) ...
    6371 * 2 * asin(sqrt(sin(deg2rad((lat2 - lat1) / 2)).^2 + cos(deg2rad(lat1)) .* cos(deg2rad(lat2)) .* sin(deg2rad((lon2 - lon1) / 2)).^2));

% Define the target latitude and longitude
target_lat = 30.4605;
target_lon = 31.1824;

% Define a threshold distance (e.g., 0.01 km)
threshold_distance = 0.01;

for i = 1:length(interp_lat)
    plotPosition(player1, interp_lat(i), interp_lon(i), "Marker", "square", "Label", 'train 1', "Color", "r", "MarkerSize", 7);
    pause(0.001);

    % Calculate the distance to the target point
    dist_to_target = haversine_distance(interp_lat(i), interp_lon(i), target_lat, target_lon);
    
    % If the distance is within the threshold, generate a random value
    if dist_to_target < threshold_distance
        random_value = rand;
        fprintf('Random value at point (%f, %f): %f\n', interp_lat(i), interp_lon(i), random_value);
    end
end
