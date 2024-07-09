function main
    % Create the main figure
    fig = uifigure('Name', 'Route Selector', 'Position', [100 100 300 150]);

    % Create a button for the first scenario
    btn1 = uibutton(fig, 'push', 'Text', 'Scenario 1', 'Position', [50 60 200 30], ...
                    'ButtonPushedFcn', @(btn,event) runScenario1);

    % Create a button for the second scenario
    btn2 = uibutton(fig, 'push', 'Text', 'Scenario 2', 'Position', [50 20 200 30], ...
                    'ButtonPushedFcn', @(btn,event) runScenario2);
end

function runScenario1
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

    plotRoutes(interp_lat_cairo_to_alex, interp_lon_cairo_to_alex, interp_lat_alex_to_cairo, interp_lon_alex_to_cairo, 'Train', 'Bus');
end

function runScenario2
    % Load data for Cairo to Alexandria
    data_cairo_to_alex = load('RedRealYScenario.mat');
    num_points_interp = 100;

    tdist = sum(distance(data_cairo_to_alex.latitude(1:end-1), data_cairo_to_alex.longitude(1:end-1), data_cairo_to_alex.latitude(2:end), data_cairo_to_alex.longitude(2:end)));
    interpolation_distance = tdist / ((numel(data_cairo_to_alex.latitude) - 1) * num_points_interp);
    [interp_lat_cairo_to_alex, interp_lon_cairo_to_alex] = interpm(data_cairo_to_alex.latitude, data_cairo_to_alex.longitude, interpolation_distance);

    % Load data for Alexandria to Cairo
    data_alex_to_cairo = load('BlueRealYScenario.mat');
    tdist = sum(distance(data_alex_to_cairo.latitude(1:end-1), data_alex_to_cairo.longitude(1:end-1), data_alex_to_cairo.latitude(2:end), data_alex_to_cairo.longitude(2:end)));
    interpolation_distance = tdist / ((numel(data_alex_to_cairo.latitude) - 1) * num_points_interp);
    [interp_lat_alex_to_cairo, interp_lon_alex_to_cairo] = interpm(data_alex_to_cairo.latitude, data_alex_to_cairo.longitude, interpolation_distance);

    plotRoutes(interp_lat_cairo_to_alex, interp_lon_cairo_to_alex, interp_lat_alex_to_cairo, interp_lon_alex_to_cairo, 'Train1', 'Train2');
end

function plotRoutes(interp_lat1, interp_lon1, interp_lat2, interp_lon2, label1Text, label2Text)
    % Create figure and geoaxes
    figure;
    ax = geoaxes('Basemap', 'satellite');

    % Plot the lines
    geoplot(ax, interp_lat1, interp_lon1, 'b', 'LineWidth', 2);
    hold on;
    geoplot(ax, interp_lat2, interp_lon2, 'g', 'LineWidth', 2);

    % Create markers
    marker1 = geoscatter(ax, interp_lat1(1), interp_lon1(1), "red", 'filled');
    marker2 = geoscatter(ax, interp_lat2(1), interp_lon2(1), "blue", 'filled');

    % Initialize labels
    label1 = text(interp_lat1(1), interp_lon1(1), label1Text, 'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
    label2 = text(interp_lat2(1), interp_lon2(1), label2Text, 'Color', 'blue', 'FontSize', 12, 'FontWeight', 'bold');

    % Set initial stopwatch position and start the timer
    h = text(interp_lat1(1), interp_lon1(1), '00:00:00.00', 'FontSize', 15, 'HorizontalAlignment', 'center', 'Color', 'white');
    tic;

    i1 = 1;
    i2 = 1;
    R = 6371;
    speedFactor = 5; % Set the factor to speed up the stopwatch

    for i = 2:length(interp_lat1)
        marker1.XData = interp_lat1(i1); % Update XData for marker1
        marker1.YData = interp_lon1(i1); % Update YData for marker1
        marker2.XData = interp_lat2(i2); % Update XData for marker2
        marker2.YData = interp_lon2(i2); % Update YData for marker2

        % Update label positions
        label1.Position = [interp_lat1(i1), interp_lon1(i1), 0];
        label2.Position = [interp_lat2(i2), interp_lon2(i2), 0];

        % Compute the distance between marker1 and marker2
        dLat = deg2rad(interp_lat2(i2) - interp_lat1(i1));
        dLon = deg2rad(interp_lon2(i2) - interp_lon1(i1));
        a = sin(dLat/2)^2 + cos(deg2rad(interp_lat1(i1))) * cos(deg2rad(interp_lat2(i2))) * sin(dLon/2)^2;
        c = 2 * atan2(sqrt(a), sqrt(1-a));
        dist = R * c;

        % Adjust pause time based on distance between markers
        if dist < 0.0303
            % Slow down both markers
            i1 = i1 + 1; % Increment marker1 index by 1
            i2 = i2 + 3; % Increment marker2 index by 1
        else
            % Normal speed
            i1 = i1 + 2; % Increment marker1 index by 3
            i2 = i2 + 3; % Increment marker2 index by 3
        end

        % Ensure indices don't exceed array bounds
        i1 = min(i1, length(interp_lat1));
        i2 = min(i2, length(interp_lat2));

        % Display elapsed time
        elapsedTime = toc * speedFactor;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);
        set(h, 'String', timeStr);

        pause(0.1);

        % Check if both markers have reached the end of their lines
        if i1 == length(interp_lat1) && i2 == length(interp_lat2)
            disp('Both markers reached the end of their lines.');
            break; % Exit the loop
        end
    end
end
