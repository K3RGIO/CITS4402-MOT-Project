img_a = imread('C:\Users\pc\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001\img\000001.jpg');
img_b = imread('C:\Users\pc\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001\img\000002.jpg');
img_c = imread('C:\Users\pc\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001\img\000003.jpg');
img_a = rgb2gray(img_a);
img_b = rgb2gray(img_b);
img_c = rgb2gray(img_c);

[rows columns] = size(img_a);

blockSizeR  = 30;
blockSizeC  = 30;

% Figure out the size of each block in rows.
wholeBlockRows = floor(rows/blockSizeR);
blockVectorR = [blockSizeR * ones(1, wholeBlockRows), rem(rows, blockSizeR)];

% Figure out the size of each block in columns.
wholeBlockCols = floor(columns/blockSizeR);
blockVectorC = [blockSizeC * ones(1, wholeBlockCols), rem(columns, blockSizeC)];

a = mat2cell(img_a, blockVectorR, blockVectorC);
b = mat2cell(img_b, blockVectorR, blockVectorC);
c = mat2cell(img_c, blockVectorR, blockVectorC);

ab = cellfun(@minus,a,b,'Un',0);
bc = cellfun(@minus,b,c,'Un',0);

% Calculate mean of absolute differences
ab_avg = cellfun(@(x) mean(x, 'all'),ab);
bc_avg = cellfun(@(x) mean(x, 'all'),bc);

% Thresholding
lambda_ab = 1./ab_avg;
threshold_ab = (-log(0.05))./lambda_ab;

lambda_bc = 1./bc_avg;
threshold_bc = (-log(0.05))./lambda_bc;

% I identify as non-binary


output = cellfun(@(x) x(x>threshold_ab),ab,'UniformOutput',false)
output(cellfun(@(x) isempty(x), output)) = {0};





