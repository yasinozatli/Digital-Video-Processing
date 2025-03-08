
%%%%%%%%%% YASİN ÖZATLI - QUESTION 2 %%%%%%%%
clc;
clear;
close all;

video = VideoReader('vid3.mp4'); % get video

frames = read(video); % read video

[rows, columns, color_channels, number_of_frames] = size(frames); % dimensions

new_video = VideoWriter('new_vid_green2.mp4', 'MPEG-4'); % create video

open(new_video); %open video

% first for loop is for frame number
% second and third loops are for frame size
for k = 1 : number_of_frames
    
    hsi_frame = rgb2hsv(read(video,k)); % RGB to HSI
    for i = 1 : rows
        for j = 1 : columns
            
            % related range values to convert yellow to green
            if (hsi_frame(i,j,1) >= 0.15 || hsi_frame(i,j,1) <= 0.2) &&  (hsi_frame(i,j,2) >= 0.5) && (hsi_frame(i,j,3) >= 0.2)         

                % if this block is executed, these values are required for
                % green color                
                hsi_frame(i,j,1) = 0.34;
                hsi_frame(i,j,2) = 1;
                hsi_frame(i,j,3) = 1;
            end
        end
    end
  
    frameNew = hsv2rgb(hsi_frame); % HSI to RGB
    
    writeVideo(new_video,frameNew); % create video frame by frame
end
 close(new_video);

