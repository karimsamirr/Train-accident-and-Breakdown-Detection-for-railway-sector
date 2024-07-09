function newtxt =DrawMap(speedup,LinesNum,colorChoice1, colorChoice2)

    % Your script code here

    % Read the image
    image = imread('p8.jpeg');

    % Convert the image from RGB to HSV color space
    hsvImage = rgb2hsv(image);
    hourtimer = datestr(now , 'HH');
    hourtimerstr = str2double(hourtimer);
    m = 0;

    % Define thresholds for detecting colors in HSV space
    redThresholdLow = 0.95;
    redThresholdHigh = 0.05;
    blueThresholdLow = 0.65;
    blueThresholdHigh = 0.75;
     greenThresholdLow = 0.25;
    greenThresholdHigh = 0.45;
    magentaThresholdLow = 0.85;
    magentaThresholdHigh = 0.95;

    % Create binary masks for red, blue, green, and magenta pixels
    redMask = (hsvImage(:,:,1) < redThresholdHigh) | (hsvImage(:,:,1) > redThresholdLow);
    blueMask = (hsvImage(:,:,1) > blueThresholdLow) & (hsvImage(:,:,1) < blueThresholdHigh);
    greenMask = (hsvImage(:,:,1) > greenThresholdLow) & (hsvImage(:,:,1) < greenThresholdHigh);
    magentaMask = (hsvImage(:,:,1) > magentaThresholdLow) & (hsvImage(:,:,1) < magentaThresholdHigh);

    % Clean up the masks using morphological operations
    redMask = bwareaopen(redMask, 100);
    redMask = imclose(redMask, strel('disk', 5));
    blueMask = bwareaopen(blueMask, 100);
    blueMask = imclose(blueMask, strel('disk', 5));
    greenMask = bwareaopen(greenMask, 100);
    greenMask = imclose(greenMask, strel('disk', 5));
    magentaMask = bwareaopen(magentaMask, 100);
    magentaMask = imclose(magentaMask, strel('disk', 5));

    % Trace the color lines
    [redBoundaries, ~] = bwboundaries(redMask, 'noholes');
    [blueBoundaries, ~] = bwboundaries(blueMask, 'noholes');
    [greenBoundaries, ~] = bwboundaries(greenMask, 'noholes');
    [magentaBoundaries, ~] = bwboundaries(magentaMask, 'noholes');
     min=0;
    hour=0;
    sec=0;

    % Display the original image
    imshow(image);
    hold on;
        %num_of_countries = input('Enter the number of your choice: ');
        if(speedup==1)
        if(LinesNum==1)


    % Ask user to choose a color
    disp('Choose number for Governorate you want ');
    disp('from Alexandia to Cairo: 1 (Red)');
    disp('from Luxor to Aswan: 2 (Blue)');
    disp('from Cairo to Luxor: 3 (Merged Green and Blue)');
    disp('from Marsa Matrouh to Alexandria: 4 (Magenta)');
    disp('from Marsa Matrouh to Aswan: 5 (Green)');
    
    % Prompt user to choose the first color
    disp('Select the first color to trace: ');
    %colorChoice1 = input('Enter the number of your choice: ');
    
    % Initialize the black point at the start of the selected color boundary
    switch colorChoice1
        case 1
            chosenBoundary1 = redBoundaries;
            color1 = 'r';
        case 2
            chosenBoundary1 = greenBoundaries;
            color1 = 'g';
            
        case 3
            chosenBoundary1 = blueBoundaries;
            color1 = 'b';
            
        case 4
            chosenBoundary1 = magentaBoundaries;
            color1 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        plot(boundary1(:, 2), boundary1(:, 1), color1, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint1 = chosenBoundary1{1}(1,:);
    blackPoint1 = plot(startPoint1(2), startPoint1(1), 'ko', 'MarkerSize', 5, 'Color', 'black', 'LineWidth', 10);

    % Prompt user to choose the second color
    disp('Select the second color to trace: ');
    %colorChoice2 = input('Enter the number of your choice: ');

    % Initialize the black point at the start of the selected color boundary
    switch colorChoice2
        case 1
            chosenBoundary2 = redBoundaries;
            color2 = 'r';
        case 2
            chosenBoundary2 = greenBoundaries;
            color2 = 'g';
            
        case 3
            chosenBoundary2 = blueBoundaries;
            color2 = 'b';
            
        case 4
            chosenBoundary2 = magentaBoundaries;
            color2 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary2)
        boundary2 = chosenBoundary2{k};
        plot(boundary2(:, 2), boundary2(:, 1), color2, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint2 = chosenBoundary2{1}(1,:);
    blackPoint2 = plot(startPoint2(2), startPoint2(1), 'ko', 'MarkerSize', 5, 'Color', 'black', 'LineWidth', 10);

    % Hold off plotting
    hold off;
    max_y_boundary = max(boundary1(:, 1));
    max_y1 = max_y_boundary-1;
    lastPosition = startPoint2;
    tripTimer = tic;
timefact = 400;
h = text(150, 715, '00:00:00.00','Color', 'red', 'FontSize', 18, 'HorizontalAlignment', 'center');

    % Move the black point along the first color line
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        for i = 2:size(boundary1, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint1, 'XData', boundary1(i, 2), 'YData', boundary1(i, 1));
            drawnow;
            pause(0.01); % Adjust speed of movement if needed
                        if boundary1(i, 1) <=  max_y1
                     
            if ~isequal(lastPosition, boundary1(i,:))
            set(blackPoint2, 'XData', boundary1(i,2), 'YData', boundary1(i,1));
            lastPosition = boundary1(i,:);
            drawnow; % Refresh the plot
              pause(0.1);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);
            end
                        else
                            break;
                        end

        end
    end
    max_y_boundary = max(boundary2(:, 1));
    max_y2 = max_y_boundary-1;

    % Move the black point along the second color line
    for k = 1:length(chosenBoundary2)
        boundary2 = chosenBoundary2{k};
        for i = 2:size(boundary2, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint2, 'XData', boundary2(i, 2), 'YData', boundary2(i, 1));
            drawnow;
            pause(0.01); % Adjust speed of movement if needed
             if boundary2(i, 1) <=  max_y2
                  %      currentTime = datestr(now, 'SS');
            %minToh=datestr(now , 'SS');
            %strminchange=str2double(minToh);
            %x=0;
            %for i = 0:59
             %   if strminchange== 59 && m==0
              %   hourtimerstr=hourtimerstr+1;
               %  m=m+1;
                %end
          %newtxt=hourtimerstr+":"+currentTime+":"+i;
          %pause(0.001)
          %disp(newtxt);
          %x=x+1;
           % end
            % textHandle = text(120, size(image, 1)-150, newtxt, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');

            %pause(0.05); % Show the clock for 1 second
            %delete(textHandle); % Delete the clock text
              if ~isequal(lastPosition, boundary2(i,:))
            set(blackPoint2, 'XData', boundary2(i,2), 'YData', boundary2(i,1));
            lastPosition = boundary2(i,:);
            drawnow; % Refresh the plot
              pause(0.1);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);
              end
            % if(min<=59)
             %   min=min+1;
            %else
             %   min=0;
              %  hour=hour+1;
            %end
            %if(sec<=59)
             %   sec=sec+1;
              %  pause(0.1)
            %else
             %   sec=0;
            %end
            %timer = hour + ":"+min+":"+sec;
            %textHandle = text(120, size(image, 1)-150, timer, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');
            %pause(0.05);
            %delete(textHandle);
                        else
                            break;
                        end
        end
          %sttime = datestr(now, 'HH:MM:SS');
                
    %stdisplay = text(120, size(image, 1)-90, 'Time At Start Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    stdisplay1 = text(120, size(image, 1)-120, 'Time At End Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    stdisplay3 = text(120, size(image, 1)-105, timer, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay2 = text(120, size(image, 1)-70, sttime, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');

    end
        else
            % Ask user to choose a color
    disp('Choose number for Governorate you want ');
    disp('from Alexandia to Cairo: 1 (Red)');
    disp('from Luxor to Aswan: 2 (Blue)');
    disp('from Cairo to Luxor: 3 (Merged Green and Blue)');
    disp('from Marsa Matrouh to Alexandria: 4 (Magenta)');
    disp('from Marsa Matrouh to Aswan: 5 (Green)');
    
    % Prompt user to choose the first color
    disp('Select the first color to trace: ');
    %colorChoice1 = input('Enter the number of your choice: ');
    
    % Initialize the black point at the start of the selected color boundary
    switch colorChoice1
       case 1
            chosenBoundary1 = redBoundaries;
            color1 = 'r';
        case 2
            chosenBoundary1 = greenBoundaries;
            color1 = 'g';
            
        case 3
            chosenBoundary1 = blueBoundaries;
            color1 = 'b';
            
        case 4
            chosenBoundary1 = magentaBoundaries;
            color1 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        plot(boundary1(:, 2), boundary1(:, 1), color1, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint1 = chosenBoundary1{1}(1,:);
    blackPoint1 = plot(startPoint1(2), startPoint1(1), 'ko', 'MarkerSize', 5, 'Color', 'black', 'LineWidth', 10);
      max_y_boundary = max(boundary1(:, 1));
    max_y1 = max_y_boundary-1;
    min=0;
    hour=0;
    sec=0;
    lastPosition = startPoint1;
tripTimer = tic;
timefact = 400;
h = text(150, 715, '00:00:00.00','Color', 'red', 'FontSize', 18, 'HorizontalAlignment', 'center');

    % Move the black point along the first color line
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        for i = 2:size(boundary1, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint1, 'XData', boundary1(i, 2), 'YData', boundary1(i, 1));
            drawnow;
            pause(0.01); % Adjust speed of movement if needed
                        if boundary1(i, 1) <=  max_y1
                               if ~isequal(lastPosition, boundary1(i,:))
            set(blackPoint1, 'XData', boundary1(i,2), 'YData', boundary1(i,1));
            lastPosition = boundary1(i,:);
            drawnow; % Refresh the plot
              pause(0.1);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);

                               end
                           %      currentTime = datestr(now, 'SS');
            %minToh=datestr(now , 'SS');
            %strminchange=str2double(minToh);
            %x=0;
            %for i = 0:59
             %   if strminchange== 59 && m==0
              %   hourtimerstr=hourtimerstr+1;
               %  m=m+1;
                %end
          %newtxt=hourtimerstr+":"+currentTime+":"+i;
          %pause(0.001)
          %disp(newtxt);
          %x=x+1;
           % end
            % textHandle = text(120, size(image, 1)-150, newtxt, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');

            %pause(0.05); % Show the clock for 1 second
            %delete(textHandle); % Delete the clock text
            %if(min<=59)
             %   min=min+1;
            %else
             %   min=0;
              %  hour=hour+1;
            %end
            %if(sec<=59)
             %   sec=sec+1;
              %  pause(0.1)
            %else
             %   sec=0;
            %end
            %timer = hour + ":"+min+":"+sec;
            %textHandle = text(120, size(image, 1)-150, timer, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');
            %pause(0.05);
            %delete(textHandle);

                        else
                            break;
                        end

        end
    end
    %sttime = datestr(now, 'HH:MM:SS');
                
    %stdisplay = text(120, size(image, 1)-90, 'Time At Start Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay1 = text(120, size(image, 1)-120, 'Time At End Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay3 = text(120, size(image, 1)-105, timer, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay2 = text(120, size(image, 1)-70, sttime, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');

        end
        else
             if(LinesNum==1)


    % Ask user to choose a color
    disp('Choose number for Governorate you want ');
    disp('from Alexandia to Cairo: 1 (Red)');
    disp('from Luxor to Aswan: 2 (Blue)');
    disp('from Cairo to Luxor: 3 (Merged Green and Blue)');
    disp('from Marsa Matrouh to Alexandria: 4 (Magenta)');
    disp('from Marsa Matrouh to Aswan: 5 (Green)');
    
    % Prompt user to choose the first color
    disp('Select the first color to trace: ');
    %colorChoice1 = input('Enter the number of your choice: ');
    
    % Initialize the black point at the start of the selected color boundary
    switch colorChoice1
        case 1
            chosenBoundary1 = redBoundaries;
            color1 = 'r';
        case 2
            chosenBoundary1 = greenBoundaries;
            color1 = 'g';
            
        case 3
            chosenBoundary1 = blueBoundaries;
            color1 = 'b';
            
        case 4
            chosenBoundary1 = magentaBoundaries;
            color1 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        plot(boundary1(:, 2), boundary1(:, 1), color1, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint1 = chosenBoundary1{1}(1,:);
     blackPoint1 = plot(startPoint1(2), startPoint1(1), 'ks', 'MarkerSize', 5, 'Color', 'cyan', 'LineWidth', 10);
    % Prompt user to choose the second color
    disp('Select the second color to trace: ');
    %colorChoice2 = input('Enter the number of your choice: ');

    % Initialize the black point at the start of the selected color boundary
    switch colorChoice2
        case 1
            chosenBoundary2 = redBoundaries;
            color2 = 'r';
        case 2
            chosenBoundary2 = greenBoundaries;
            color2 = 'g';
            
        case 3
            chosenBoundary2 = blueBoundaries;
            color2 = 'b';
            
        case 4
            chosenBoundary2 = magentaBoundaries;
            color2 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end
   

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary2)
        boundary2 = chosenBoundary2{k};
        plot(boundary2(:, 2), boundary2(:, 1), color2, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint2 = chosenBoundary2{1}(1,:);
    blackPoint2 = plot(startPoint2(2), startPoint2(1), 'ks', 'MarkerSize', 5, 'Color', 'cyan', 'LineWidth', 10);

    % Hold off plotting
    hold off;
    max_y_boundary = max(boundary1(:, 1));
    max_y1 = max_y_boundary-1;
    count=0;
     lastPosition = startPoint2;
tripTimer = tic;
timefact = 200;
h = text(150, 715, '00:00:00.00','Color', 'red', 'FontSize', 18, 'HorizontalAlignment', 'center');

    % Move the black point along the first color line
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        for i = 2:size(boundary1, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint1, 'XData', boundary1(i, 2), 'YData', boundary1(i, 1));
            drawnow;
            pause(0.0001); % Adjust speed of movement if needed
                        if boundary1(i, 1) <=  max_y1
                      %      currentTime = datestr(now, 'SS');
            %minToh=datestr(now , 'SS');
            %strminchange=str2double(minToh);
            %x=0;
            %for i = 0:59
             %   if strminchange== 59 && m==0
              %   hourtimerstr=hourtimerstr+1;
               %  m=m+1;
                %end
          %newtxt=hourtimerstr+":"+currentTime+":"+i;
          %pause(0.001)
          %disp(newtxt);
          %x=x+1;
           % end
            % textHandle = text(120, size(image, 1)-150, newtxt, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');

            %pause(0.05); % Show the clock for 1 second
            %delete(textHandle); % Delete the clock text
           %  if(min<=59)
            %     if mod(count , 2)==0
             %   min=min+1;
              %   end
            %else
             %   min=0;
              %  hour=hour+1;
            %end
            %if(sec<=59)
             %   sec=sec+1;
              %  pause(0.001)
            %else
             %   sec=0;
            %end
            %count=count+1;
            %timer = hour + ":"+min+":"+sec;
            %textHandle = text(120, size(image, 1)-150, timer, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');
            %pause(0.005);
            %delete(textHandle);
             % Update the position of the black point if it's a new position
        if ~isequal(lastPosition, boundary1(i,:))
            set(blackPoint2, 'XData', boundary1(i,2), 'YData', boundary1(i,1));
            lastPosition = boundary1(i,:);
            drawnow; % Refresh the plot
              pause(0.0001);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);

        end
                        else
                            break;
                        end

        end
    end
    max_y_boundary = max(boundary2(:, 1));
    max_y2 = max_y_boundary-1;

    % Move the black point along the second color line
    for k = 1:length(chosenBoundary2)
        boundary2 = chosenBoundary2{k};
        for i = 2:size(boundary2, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint2, 'XData', boundary2(i, 2), 'YData', boundary2(i, 1));
            drawnow;
            pause(0.001); % Adjust speed of movement if needed
             if boundary2(i, 1) <=  max_y2
                     if ~isequal(lastPosition, boundary2(i,:))
            set(blackPoint2, 'XData', boundary2(i,2), 'YData', boundary2(i,1));
            lastPosition = boundary2(i,:);
            drawnow; % Refresh the plot
              pause(0.001);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);

        end
                  %      currentTime = datestr(now, 'SS');
            %minToh=datestr(now , 'SS');
            %strminchange=str2double(minToh);
            %x=0;
            %for i = 0:59
             %   if strminchange== 59 && m==0
              %   hourtimerstr=hourtimerstr+1;
               %  m=m+1;
                %end
          %newtxt=hourtimerstr+":"+currentTime+":"+i;
          %pause(0.001)
          %disp(newtxt);
          %x=x+1;
           % end
            % textHandle = text(120, size(image, 1)-150, newtxt, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');

            %pause(0.05); % Show the clock for 1 second
            %delete(textHandle); % Delete the clock text
             %if(min<=59)
              %  if mod(count , 2)==0
              %  min=min+1;
               %  end
            %else
             %   min=0;
              %  hour=hour+1;
            %end
            %if(sec<=59)
             %   sec=sec+1;
              %  pause(0.001)
            %else
             %   sec=0;
            %end
            %count=count+1;
            %timer = hour + ":"+min+":"+sec;
            %textHandle = text(120, size(image, 1)-150, timer, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');
            %pause(0.005);
            %delete(textHandle);
                        else
                            break;
                        end
        end
          %sttime = datestr(now, 'HH:MM:SS');
                
    %stdisplay = text(120, size(image, 1)-90, 'Time At Start Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay1 = text(120, size(image, 1)-120, 'Time At End Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay3 = text(120, size(image, 1)-105, timer, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay2 = text(120, size(image, 1)-70, sttime, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');

    end
        else
            % Ask user to choose a color
    disp('Choose number for Governorate you want ');
    disp('from Alexandia to Cairo: 1 (Red)');
    disp('from Luxor to Aswan: 2 (Blue)');
    disp('from Cairo to Luxor: 3 (Merged Green and Blue)');
    disp('from Marsa Matrouh to Alexandria: 4 (Magenta)');
    disp('from Marsa Matrouh to Aswan: 5 (Green)');
    
    % Prompt user to choose the first color
    disp('Select the first color to trace: ');
    %colorChoice1 = input('Enter the number of your choice: ');
    
    % Initialize the black point at the start of the selected color boundary
    switch colorChoice1
       case 1
            chosenBoundary1 = redBoundaries;
            color1 = 'r';
        case 2
            chosenBoundary1 = greenBoundaries;
            color1 = 'g';
            
        case 3
            chosenBoundary1 = blueBoundaries;
            color1 = 'b';
            
        case 4
            chosenBoundary1 = magentaBoundaries;
            color1 = 'm';
            
        otherwise
            error('Invalid choice. Please choose between 1, 2, 3, 4, or 5.');
    end

    % Display the entire boundary of the chosen color
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        plot(boundary1(:, 2), boundary1(:, 1), color1, 'LineWidth', 2);
    end

    % Initialize the black point at the start of the boundary
    startPoint1 = chosenBoundary1{1}(1,:);
    blackPoint1 = plot(startPoint1(2), startPoint1(1), 'ks', 'MarkerSize', 5, 'Color', 'cyan', 'LineWidth', 10);
      max_y_boundary = max(boundary1(:, 1));
    max_y1 = max_y_boundary-1;
    min=0;
    hour=0;
    sec=0;
    count=0;
    lastPosition = startPoint1;
tripTimer = tic;
timefact = 400;
h = text(150, 715, '00:00:00.00','Color', 'red', 'FontSize', 18, 'HorizontalAlignment', 'center');

    % Move the black point along the first color line
    for k = 1:length(chosenBoundary1)
        boundary1 = chosenBoundary1{k};
        for i = 2:size(boundary1, 1) % Start from the second point
            % Update the position of the black point
            set(blackPoint1, 'XData', boundary1(i, 2), 'YData', boundary1(i, 1));
            drawnow;
            pause(0.001); % Adjust speed of movement if needed
                        if boundary1(i, 1) <=  max_y1
                             if ~isequal(lastPosition, boundary1(i,:))
            set(blackPoint1, 'XData', boundary1(i,2), 'YData', boundary1(i,1));
            lastPosition = boundary1(i,:);
            drawnow; % Refresh the plot
            %  pause(0.1);
              elapsedTime = toc(tripTimer)*timefact;
        hours = floor(elapsedTime / 3600);
        minutes = floor(mod(elapsedTime, 3600) / 60);
        seconds = mod(elapsedTime, 60);
        milliseconds = mod(elapsedTime, 1) * 100;
        timeStr = sprintf('%02d:%02d:%02.0f.%02.0f', hours, minutes, seconds, milliseconds);

        % Update the stopwatch display
        set(h, 'String', timeStr);

        end
                           %      currentTime = datestr(now, 'SS');
            %minToh=datestr(now , 'SS');
            %strminchange=str2double(minToh);
            %x=0;
            %for i = 0:59
             %   if strminchange== 59 && m==0
              %   hourtimerstr=hourtimerstr+1;
               %  m=m+1;
                %end
          %newtxt=hourtimerstr+":"+currentTime+":"+i;
          %pause(0.001)
          %disp(newtxt);
          %x=x+1;
           % end
            % textHandle = text(120, size(image, 1)-150, newtxt, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');

            %pause(0.05); % Show the clock for 1 second
            %delete(textHandle); % Delete the clock text
            %if(min<=59)
             %   if mod(count , 2)==0
                               %     min=min+1;

              %  end
            %else
             %   min=0;
              %  hour=hour+1;
            %end
            %if(sec<=59)
             %   sec=sec+1;
              %  pause(0.001)
            %else
             %   sec=0;
            %end
            %count=count+1;
            %timer = hour + ":"+min+":"+sec;
            %textHandle = text(120, size(image, 1)-150, timer, 'Color', 'red', 'FontSize', 15, 'HorizontalAlignment', 'left');
            %pause(0.005);
            %delete(textHandle);

                        else
                            break;
                        end

        end
    end
    %sttime = datestr(now, 'HH:MM:SS');
                
    %stdisplay = text(120, size(image, 1)-90, 'Time At Start Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay1 = text(120, size(image, 1)-120, 'Time At End Of Trip : ', 'Color', 'black', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay3 = text(120, size(image, 1)-105, timer, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');
    %stdisplay2 = text(120, size(image, 1)-70, sttime, 'Color', 'red', 'FontSize', 10, 'HorizontalAlignment', 'left');

    end
end