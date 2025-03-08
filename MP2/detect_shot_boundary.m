%% YASİN ÖZATLI MP-2 QUESTION 3

% RESULT: In noise-free video, threshold is 0.15, there is no problem.
% In Noisy Video, frame 68 is under threshold 0.365 but some frames are
% over threshold even if there is no shot boundary at those frames.
% So, in noisy video there is not a threshold that meets criteria for
% all frames.

clc;
clear;
close all;

mean = 0; % gaussian distributioon parameter
variance = 0.2;  % gaussian distributioon parameter
Threshold_noise_free = 0.15; % threshold to find shot boundaries
Threshold_noise_gaussian = 0.3650;

videofromFile = VideoReader('EE583MP2-Video1.mp4');   % Create object to read video files
frame_indexsOfVideo = read(videofromFile);        % Read video frame_index by frame_index and store
[rows, columns, size, number_of_frame_indexs] = size(frame_indexsOfVideo);   % dimensions, size is 3 because it is RGB
total_pixel_number = rows*columns;

figure_index = 1; % this is needed because when a shot boundary found,
                  % new scene will be shown on a new figure


for noisy_2_not_1 = 1 : 2 
  
    for frame_index = 1 : number_of_frame_indexs-2 % because of frame_index+1
                                                   % and ı dont want the
                                                   % last frame   
            Image_current = im2double(rgb2gray(read(videofromFile, frame_index)));          
            Image_next   = im2double(rgb2gray(read(videofromFile,frame_index+1)));         

            if (noisy_2_not_1 == 2) 
                Image_current = imnoise(Image_current,'gaussian',mean,variance);
                Image_next = imnoise(Image_next,'gaussian',mean,variance);
            end % 
        
            
            change_in_frame(frame_index) = sum(sum(abs((Image_next - Image_current))))/total_pixel_number;
            % change between consecutive frames is calculated. array is
            % filled to make comparison

            if (noisy_2_not_1 == 1) % show noise-free images
                figure(figure_index);
                imshow(Image_current);
                title('NOISE-FREE: Each shot is shown on new figure');
                hold on;
               
                if(change_in_frame(frame_index) > Threshold_noise_free) % check if a shot boundary exists               
                    fprintf('frame %d \n',frame_index);
                    figure; % shot found, new figure create
                    imshow(Image_current);
                    figure_index = figure_index + 1;
                end 
            else %show noisy images
                    % if (frame_index == 100 || frame_index == 68 || frame_index == 166 || frame_index == 281)
                     %   fprintf('frame %d \n',frame_index);
                      %  fprintf('%d\n', change_in_frame(frame_index))
                     %end
                    figure(figure_index);
                    imshow(Image_current);
                    %title('NOISY: Each shot is shown on new figure');
                    
                    if(change_in_frame(frame_index) > Threshold_noise_gaussian) % threshold check to find shot change
                        fprintf('frame noisy %d\n',frame_index);
                        figure; % create new figure after shot finding
                        imshow(Image_current);
                        title('NOISY: Each shot is shown on new figure');
                        hold on
                        figure_index = figure_index + 1;
                    end
             end
    end

end

