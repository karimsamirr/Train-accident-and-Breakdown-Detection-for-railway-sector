data = load('aaa.mat');

num_points_interp = 10;

tdist = sum(distance(data.latitude(1:end-1), data.longitude(1:end-1), data.latitude(2:end), data.longitude(2:end)));
interpolation_distance = tdist / ((numel(data.latitude) - 1) * num_points_interp);
[interp_lat, interp_lon] = interpm(data.latitude, data.longitude, interpolation_distance);

player1 = geoplayer(data.latitude(1), data.longitude(1), 15, 'Basemap', 'satellite');

plotRoute(player1, interp_lat, interp_lon, "Color", "m");

target_lat = 30.4605;
target_lon = 31.1824;
tolerance = 1e-4; % Define a tolerance for comparison
random_number = randi([0, 2]);
for i = 1:length(interp_lat)
    plotPosition(player1, interp_lat(i), interp_lon(i), "Marker", "square", "Label", 'train 1', "Color", "r", "MarkerSize", 7);
    
    % Check if the current interpolated point is close to the target point
    if abs(interp_lat(i) - target_lat) < tolerance && abs(interp_lon(i) - target_lon) < tolerance
       % random_number = randi([0, 2]);
        switch random_number
            case 0
                % Change the color of the line to red
                plotRoute(player1, interp_lat, interp_lon, "Color", "r");
                disp("railway sector must be change ")
                break

            case 1
                % Change the color of the line to yellow
                plotRoute(player1, interp_lat, interp_lon, "Color", "y");
                disp("railway sector should be change ")
            case 2
                % Change the color of the line to green
                plotRoute(player1, interp_lat, interp_lon, "Color", "g");
                disp("railway sector in good condition")
        end
    end
    
    % Shorten the pause time to make the point move faster
    pause(0.0001);
end
