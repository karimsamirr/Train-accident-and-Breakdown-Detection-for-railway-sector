% Load data for Cairo to Alexandria
data_cairo_to_alex = load('TrainRealTrainBus.mat');
num_points_interp = 100;

tdist = sum(distance(data_cairo_to_alex.latitude(1:end-1), data_cairo_to_alex.longitude(1:end-1), data_cairo_to_alex.latitude(2:end), data_cairo_to_alex.longitude(2:end)));
interpolation_distance = tdist / ((numel(data_cairo_to_alex.latitude) - 1) * num_points_interp);
[interp_lat_cairo_to_alex, interp_lon_cairo_to_alex] = interpm(data_cairo_to_alex.latitude, data_cairo_to_alex.longitude, interpolation_distance);

% Load data for Alexandria to Cairo
data_alex_to_cairo = load('BusRealTrainBus.mat');
tdist = sum(distance(data_alex_to_cairo.latitude(1:end-1), data_alex_to_cairo.longitude(1:end-1), data_alex_to_cairo.latitude(2:end), data_alex_to_cairo.longitude(2:end)));
interpolation_distance = tdist / ((numel(data_alex_to_cairo.latitude) - 1) * num_points_interp);
[interp_lat_alex_to_cairo, interp_lon_alex_to_cairo] = interpm(data_alex_to_cairo.latitude, data_alex_to_cairo.longitude, interpolation_distance);

figure;
ax = geoaxes('Basemap', 'satellite');

% Plot the line Cairo to Alexandria
geoplot(ax, interp_lat_cairo_to_alex, interp_lon_cairo_to_alex, 'b', 'LineWidth', 2);
hold on;  % Hold the current plot

% Plot the line Alexandria to Cairo
geoplot(ax, interp_lat_alex_to_cairo, interp_lon_alex_to_cairo, 'g', 'LineWidth', 2);

dotSize = 30;

marker1 = geoscatter(ax, interp_lat_cairo_to_alex(1), interp_lon_cairo_to_alex(1),"red", 'filled');
marker2 = geoscatter(ax, interp_lat_alex_to_cairo(1), interp_lon_alex_to_cairo(1),"blue", 'filled');

% Initialize labels
label1 = text(interp_lat_cairo_to_alex(1), interp_lon_cairo_to_alex(1), 'Train', 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
label2 = text(interp_lat_alex_to_cairo(1), interp_lon_alex_to_cairo(1), 'Bus', 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold');




i1=1;
i2=1;
R = 6371;
h = text(interp_lat_cairo_to_alex(1), interp_lon_cairo_to_alex(1), '00:00:00.00', 'FontSize', 25, 'HorizontalAlignment', 'center', 'Color', 'white');
tic;

i1 = 1;
i2 = 1;
R = 6371;
speedFactor = 5;

for i = 2:length(interp_lat_cairo_to_alex)
    marker1.XData = interp_lat_cairo_to_alex(i1); % Update XData
    marker1.YData = interp_lon_cairo_to_alex(i1); % Update YData 
    marker2.XData = interp_lat_alex_to_cairo(i2); % Update XData
    marker2.YData = interp_lon_alex_to_cairo(i2); % Update YData
    
    % Update label positions
    label1.Position = [interp_lat_cairo_to_alex(i1), interp_lon_cairo_to_alex(i1), 0];
    label2.Position = [interp_lat_alex_to_cairo(i2), interp_lon_alex_to_cairo(i2), 0];
    
    % Compute the distance between marker1 and marker2
    dLat = deg2rad(interp_lat_alex_to_cairo(i2) - interp_lat_cairo_to_alex(i1));
    dLon = deg2rad(interp_lon_alex_to_cairo(i2) - interp_lon_cairo_to_alex(i1));
    a = sin(dLat/2)^2 + cos(deg2rad(interp_lat_cairo_to_alex(i1))) * cos(deg2rad(interp_lat_alex_to_cairo(i2))) * sin(dLon/2)^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    dist = R * c;
    
    % Adjust pause time based on distance between markers
    if dist < 0.1928
        i1 = i1; % slow down marker1
    else
        i1 = i1 + 3; % normal speed
    end
    
    % Increment i2 only if it's within the bounds
    if i2 < length(interp_lat_alex_to_cairo)
        i2 = i2 + 2; % increment marker2 index
    end
      elapsedTime = toc * speedFactor;
    hours = floor(elapsedTime / 3600);
    minutes = floor(mod(elapsedTime, 3600) / 60);
    seconds = mod(elapsedTime, 60);
    milliseconds = mod(elapsedTime, 1) * 100;
    timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);
    set(h, 'String', timeStr);
    %disp(dist);
    pause(0.1);
    
    % Check if marker2 has reached the end of its line
    if i2 == length(interp_lat_alex_to_cairo)
        disp('Marker 2 reached the end of the line.');
        % Continue moving marker 1 until it reaches the end of its line
        while i1 < length(interp_lat_cairo_to_alex)
            marker1.XData = interp_lat_cairo_to_alex(i1); % Update XData
            marker1.YData = interp_lon_cairo_to_alex(i1); % Update YData 
            label1.Position = [interp_lat_cairo_to_alex(i1), interp_lon_cairo_to_alex(i1), 0];
            i1 = i1 + 3; % Move marker1 forward
            pause(0.1);
        end
        disp('Marker 1 reached the end of the line after Marker 2.');
        break; % Exit the loop
    end
end