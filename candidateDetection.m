%% General Setup
clear; clc;

% Use parser to load folder
fileLocation = 'C:\Users\pc\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001';
nameTemplate = '%06d';
frameRange = [1 15];

p = parser(fileLocation, nameTemplate, frameRange) %frame range not specified because we want to load all images

% Load gt.txt data
p_gt = p.read_csv();


%% Lets do this 
% function ObjectDetectionButtonPushed(app, event)
    % Split into 30x30 pixel regions
    for i = p.frameRange(1)+1:p.frameRange(2)-1
        % Load images at i-1, i and i+1
        img_1 = p.file_index(i).frame;
        img_2 = p.file_index(i-1).frame;
        img_3 = p.file_index(i+1).frame;

        % Convert Image to greyscale
        img_1_bw = rgb2gray(img_1);
        img_2_bw = rgb2gray(img_2);
        img_3_bw = rgb2gray(img_3);

        % Split images in 30x30 pixel blocks
        [rows columns] = size(img_1_bw); % store size of image for future operations

        blockSize = 30; %setting to determine how many pixels should be in each block

        wholeBlockRows = floor(rows/blockSize); %determine how many full blocks fit across width of image
        blockVectorR = [blockSize * ones(1, wholeBlockRows), rem(rows, blockSize)];

        wholeBlockCols = floor(columns/blockSize); %determine how many full blocks fit down height of image
        blockVectorC = [blockSize * ones(1, wholeBlockCols), rem(columns, blockSize)];

        img_1_blocks = mat2cell(img_1_bw, blockVectorR, blockVectorC);
        img_2_blocks = mat2cell(img_2_bw, blockVectorR, blockVectorC);
        img_3_blocks = mat2cell(img_3_bw, blockVectorR, blockVectorC);

        % Run detection algorithm across all blocks
            % Number of rows = wholeBlockRows + 1
            % Number of cols = wholeBlockCols + 1

        arr{i-1} = cell(wholeBlockRows+1, wholeBlockCols+1); % creating empty array to input results into

        for row = 1:wholeBlockRows+1
            for col = 1:wholeBlockCols+1
                % Calculate absolute difference between frames
                abs_diff_12 = abs(double(img_1_blocks{row,col}) - double(img_2_blocks{row,col}));
                abs_diff_13 = abs(double(img_1_blocks{row,col}) - double(img_3_blocks{row,col}));
        
                % Calculate mean of absolute differences
                avg_12 = mean(abs_diff_12, 'all');
                avg_13 = mean(abs_diff_13, 'all');
        
                % Apply thresholding as specified in reference paper
                % lamba = 1/avg, threshold = -ln(0.05)/lambda = -ln(0.05)*avg
                threshold_12 = -log(0.05)*avg_12;
                threshold_13 = -log(0.05)*avg_13;
        
                % Use threshold to create binarise frame
                binary_12 = abs_diff_12 > threshold_12;
                binary_13 = abs_diff_13 > threshold_13;
        
                % Save binary frame to array
                temp = arr{i-1};
                temp{row,col} = binary_12 & binary_13;
                arr{i-1} = temp;
            end

            % Display binary image 
          
%             binary_image = cell2mat(arr);
%             imshow(binary_image);
%             drawnow;
%             pause(0.01);
        end
        
        % Combine blocks into single matrix and place in arr
        arr{i-1} = cell2mat(arr{i-1});

    end