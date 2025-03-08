%% YASİN ÖZATLI MP-2 QUESTION 2

% RESULT: In Noisy Video, plotted vectors deviated compared to noise-free.
% The 3-Step Block Matching Algorithm (3SBMA)
% is a popular motion detection technique in 
% video processing. It is efficient in finding 
% motion vectors between blocks of consecutive 
% video frames, making it suitable for motion detection

clc;
clear;
close all;

%CONSTANTS
variance = 0.2; % Gaussian (normal) distribution has mean and variance as parameters
mean = 0;                 % Here, mean is 0, variance is 0.2

x = 0; % stores min movement
y = 0;

Image_1 = imread('r1.jpg'); % imread() function reads photos
Image_2 = imread('r2.jpg');

Image_1_grayscale = im2double(rgb2gray(Image_1)); % im2double() normalizes iamges (0-1) value
Image_2_grayscale = im2double(rgb2gray(Image_2)); 

[rows, columns, size] = size(Image_1_grayscale);  % dimensions, size is 3 because it is RGB

block_length = gcd(rows, columns); % gcd() function returns the greatest common divisor of the parameters.


for n = 1 : 2 % n=1 noise-free,  n=2 noisy

    if (n == 2) 
        Image_1_grayscale = imnoise(Image_1_grayscale,'gaussian',mean,variance);
        Image_2_grayscale = imnoise(Image_2_grayscale,'gaussian',mean,variance);
    end % With imnoise() function, adding Gaussian noise


    % Motion Vector Initialization. Stores x and y displacements for each block. 
    array_of_displacemnt = zeros(2, rows*columns/block_length^2); 
                                                                                                                          
                                                                                                                                                                   
    % In the 3-Step Block Search method for motion detection, MAD stands for 
    % Mean Absolute Difference. It is a metric used to measure the similarity 
    % (or dissimilarity) between two blocks of pixels in consecutive frames, 
    % The algorithm iterates to minimize the MAD
    % To ensure the first computed MAD value is always smaller than the initialized MAD, 
    % we must set the initial MAD to a very large value
    % So, infinity
    % any valid MAD value from the first comparison will overwrite it
    mad = inf;

    % to track and index the current block being processed in the algoritm
    % assigns a unique index to each block in the image, which is then used
    % to store and access the corresponding motion vectors in the
    % array_of_displacement
    % Start with the first block is being processed.
    index_of_block = 1;

   
    for i = 1 : block_length : rows - block_length 
        for j = 1 : block_length : columns - block_length 

           
            x_direction = j;
            y_direction = i;
            steps = 3;

            
              % minimum MAD is needed 
            while(steps > 0) % run step 3, 2 and 1
               

                for a = -steps : steps : steps
                    for b = -steps : steps : steps

                       
                if((y_direction+a)<1||(x_direction+b)<1||((y_direction+a)+block_length-1)>rows||((y_direction+a)+block_length-1)>rows||((x_direction+b)+block_length-1)>columns)             
                 
                    continue;% these 3 conditions must not be processed, calculation must be in image boundaries
                end

                       
                        block_2 = Image_2_grayscale(i:i+block_length-1, j:j+block_length-1);
                        block_1 = Image_1_grayscale((y_direction + a):(y_direction + a)+block_length-1, (x_direction + b):(x_direction + b)+block_length-1);
                        result_mad = sum(sum(abs(block_2-block_1)))/(block_length^2); % MAD calculation
                        
                        
                        if(result_mad < mad)
                            
                            mad = result_mad;
                            x = b / steps; % calculate vectors                
                            y = a / steps;
                        end

                    end
                end

                x_direction = x_direction + (x * steps); % Update x_dir and y_dir 
                y_direction = y_direction + (y * steps);
               
                steps = steps - 1; %  reduce step size

            end

            array_of_displacemnt(1, index_of_block) = y_direction - i; % store directio vectors
            array_of_displacemnt(2, index_of_block) = x_direction - j;
           
            index_of_block = index_of_block + 1;
           
            x = 0;          %reset
            y = 0;          %reset
            mad = inf;      %reset

        end
    end

    if (n == 1) 
    % noise-free, n=1
       
        figure;
        a=0.5;    % equally blended
        imshow(Image_1_grayscale*a +(1-a)*Image_2_grayscale);
        title("Noise-Free");
        hold on;

        index_of_block = 0;
        for i = block_length/2 : block_length : columns
            for j = block_length/2 : block_length : rows
                index_of_block = index_of_block+1;   
            % vector plot
            quiver(i, j, array_of_displacemnt(1, index_of_block), array_of_displacemnt(2, index_of_block), 3, 'Color', [1, 0, 0], 'LineWidth', 1);

            end
        end
    else 
        
        figure;
   
        imshow(Image_1_grayscale*0.22 +(1-0.7)*Image_2_grayscale); % tried random alpha values 
        title("Noise gaussian");
        hold on;
      
        index_of_block = 0;
        for i = block_length/2 : block_length : columns
            for j = block_length/2 : block_length : rows
                index_of_block = index_of_block+1;   
                 % vector plot
                quiver(i, j, array_of_displacemnt(1, index_of_block), array_of_displacemnt(2, index_of_block), 3, 'Color', [1, 0, 0], 'LineWidth', 1);

            end
        end
    end
    

end