%% YASİN ÖZATLI MP-2 QUESTION 1
% Result: Noisy video is barely understandable. 
% Background subtraction is a fundamental technique in computer vision for isolating moving objects from the background in a video stream.

clc;
clear;
close all;

% I tried T values, 0.1 has True-Negative results. T = 0.2 has False-Positive results.
% I thought that T=0.15 is suitable
T = 0.15; %  T can be a global image threshold, specified as a scalar luminance value
video_after_gaussian_noise = VideoWriter('video_gaussian_que1.mp4', 'MPEG-4'); 
video_before_gaussian_noise = VideoWriter('video_pure_que1.mp4', 'MPEG-4'); 
videofromFile = VideoReader('vid3.mp4');    % Create object to read video files
frame_indexsOfVideo = read(videofromFile);     % Read video frame_index by frame_index and store
[rows, columns, color_channels, number_of_frame_indexs] = size(frame_indexsOfVideo);   % dimensions, size is 3 because it is RGB
open(video_after_gaussian_noise);
open(video_before_gaussian_noise);

% In for loop, convert rgb to grayscale 
% With respect to T, binarize the difference image
% Now we have noise-free video
% With imnoise() function, adding Gaussian noise to frames
% With imbinarize() function, get a binarized noisy video
% Now we have noisy and noise-free video
for frame_index = 1 : number_of_frame_indexs-2
	
    Image_next   = rgb2gray(read(videofromFile,frame_index+1));
	Image_current = rgb2gray(read(videofromFile, frame_index));
     
    binarized =  imbinarize(Image_next-Image_current, T);
    writeVideo(video_before_gaussian_noise,double(binarized));
               
    Image_gaussian_current  = imnoise(Image_current,'gaussian',0,0.2); % Gaussian (normal) distribution has mean and variance as parameters
    Image_gaussian_next = imnoise(Image_next,'gaussian',0,0.2);   % Here, mean is 0, variance is 0.2 
         
    noisy_and_binary_frames =  imbinarize(Image_gaussian_next-Image_gaussian_current, T);
    writeVideo(video_after_gaussian_noise,double(noisy_and_binary_frames));
end
close(video_before_gaussian_noise);
close(video_after_gaussian_noise);