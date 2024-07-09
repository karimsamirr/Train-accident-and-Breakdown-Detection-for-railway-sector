% Load the data
data = load('alex2cairo.mat');

% Define parameters
num_points_interp = 100;
break_threshold = 50; % Assume the track will break after 50 movements

% Calculate total distance and interpolation distance
tdist = sum(distance(data.latitude(1:end-1), data.longitude(1:end-1), data.latitude(2:end), data.longitude(2:end)));
interpolation_distance = tdist / ((numel(data.latitude) - 1) * num_points_interp);

% Interpolate the route
[interp_lat, interp_lon] = interpm(data.latitude, data.longitude, interpolation_distance);

% Initialize the geoplayer
player1 = geoplayer(data.latitude(1), data.longitude(1), 10, 'Basemap', 'satellite');

% Plot the interpolated route
plotRoute(player1, interp_lat, interp_lon, "Color", "m");

% Initialize movement counter
movement_count = 0;

% Loop through the movements
for movement = 1:100 % Simulate 100 movements for example
    % Increment the movement counter
    movement_count = movement_count + 1;

    % Plot the train movement
    for i = 1:length(interp_lat)
        plotPosition(player1, interp_lat(i), interp_lon(i), "Marker", "square", "Label", 'train 1', "Color", "r", "MarkerSize", 7);
        % pause(0.001); % Uncomment if you want to visualize the movements in real-time
    end

    % Check if the break threshold is reached
    if movement_count >= break_threshold
        disp('Warning: Track is at risk of breaking due to repeated movements!');
        break; % Stop further movements
    end
end
