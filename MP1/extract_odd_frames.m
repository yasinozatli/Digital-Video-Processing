
%%%%%%%%%% YASİN ÖZATLI - QUESTION 1 %%%%%%%%%
clc;
clear;
close all;

video_frames = VideoReader('vid3.mp4'); % get video

all_frames = read(video_frames); % read video

[rows, columns, color_channels, number_of_frames] = size(all_frames); % dimensions

odd_frame_index = 1:2:number_of_frames; % odd frame index

new_video = VideoWriter('newreducedVid.mp4', 'MPEG-4'); % create video

open(new_video);

 for k=1:length(odd_frame_index) % indexed for odd frames
    
     current_frame   = read(video_frames,odd_frame_index(k)); % get odd frames
    
     writeVideo(new_video,current_frame); % save video
 end
 close(new_video);
 
