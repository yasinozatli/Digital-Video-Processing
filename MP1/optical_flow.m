
%%%%%%%%%% YASİN ÖZATLI - QUESTION 3 %%%%%%%%
clc;
clear;
close all;

%%% CONSTANTS %%%

MaskX  = [-1/4, 1/4; -1/4, 1/4]; % these masks were more successful
MaskY  = [1/4, 1/4; -1/4, -1/4];
%MaskX = [-1 1; -1 1];
%MaskY = [1 1; -1 -1];

MaskLaplace = [1/12, 2/12, 1/12; 2/12, -12/12, 2/12; 1/12, 2/12, 1/12]; % mask laplacian

% alfa value random
alfa = 5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

video = VideoReader('vid3.mp4'); % get video

frames = read(video); % read video

[rows, columns, color_channels, no_of_frames] = size(frames); % extract proprties

u    = zeros(rows-1, columns-1); % u = u_1 = u_1_ / u_2
u_1  = zeros(rows-1, columns-1);
u_1_ = zeros(rows-1, columns-1); % Initialize u matrixes as zero vectors
u_2  = zeros(rows-1, columns-1);

v    = zeros(rows-1, columns-1); % v = v_1 = v_1_/v_2
v_1   = zeros(rows-1, columns-1);
v_1_ = zeros(rows-1, columns-1); % Initialize v matrixes as zero vectors
v_2  = zeros(rows-1, columns-1);


vid_new = VideoWriter('OF_vid_new3.mp4', 'MPEG-4'); % create video

open(vid_new); %open video


Ex = zeros(rows-1, columns-1); % define and initialize with zeros
Ey = zeros(rows-1, columns-1); % Ex Ey Et definition here
Et = zeros(rows-1, columns-1); 


  % read frames
 for k = 1 : no_of_frames-1 
     
     frame_first   = read(video,k);
     frame_second   = read(video,k+1);
    
     frame_first_gray = double(rgb2gray(frame_first)); % conversion to grayscale
     frame_second_gray = double(rgb2gray(frame_second));
     
     
     for i = 1 : rows-1
        for j = 1 : columns-1
           
            Ex(i,j) = 0.25*( sum(sum(frame_first_gray(i:i+1,j:j+1).*MaskX)) + sum(sum(frame_second_gray(i:i+1,j:j+1).*MaskX))); 
            Ey(i,j) = 0.25*( sum(sum(frame_first_gray(i:i+1,j:j+1).*MaskY)) + sum(sum(frame_second_gray(i:i+1,j:j+1).*MaskY)));
            Et(i,j) = sum(sum(frame_second_gray(i:i+1,j:j+1) - frame_first_gray(i:i+1,j:j+1)));
        end % Calculate Ex Ey Et 
     end
     
     for z = 1 : 20
        for i = 2 : rows-3 % avoid boundary pixels
            for j = 2 : columns-3
               
                % Calculate u and v matrixes
                u_ = sum(sum(u(i-1:i+1,j-1:j+1).*MaskLaplace)) + u(i,j);
                v_ = sum(sum(v(i-1:i+1,j-1:j+1).*MaskLaplace)) + v(i,j);
                            
                u_1_(i,j) = ((alfa^2 + Ey(i,j)^2) * u_) - (Ex(i,j) * Ey(i,j) * v_) - (Ex(i,j) * Et(i,j));
                u_2(i,j) = alfa^2 + Ex(i,j)^2 + Ey(i,j)^2;
                v_1_(i,j) = ((alfa^2 + Ex(i,j)^2) * v_) - (Ex(i,j) * Ey(i,j) * u_) - (Ey(i,j) * Et(i,j));
                v_2(i,j) = alfa^2 + Ex(i,j)^2 + Ey(i,j)^2;
               
                u_1(i,j) = u_1_(i,j) / u_2(i,j);
                v_1(i,j) = v_1_(i,j) / v_2(i,j);
            end
        end
        
        u = u_1;
        v = v_1;
     end
     
     % show current frame to check if there is a problem
       
     f1 = figure;
     imshow(frame_first, 'InitialMagnification', 'fit'); 
     f1.WindowState = 'normal'; 
     hold on

     % the quiver function is used to plot vectors as arrows.
     quiver(u,v);
     hFig.WindowState = 'maximized';
     hold on
     
     % get current frame
     this_frame = getframe();

     % these frames will be joined, so lets save them
     path = sprintf('./output/im_%g.png', k);
     imwrite(this_frame.cdata,path);

     % add frame to video
     writeVideo(vid_new,this_frame);
     
     fprintf(sprintf('Please wait, these figures will result in a video\n'));
     close(f1);
 end

 close(vid_new);
