function [Discriminants] = candidateDiscrimination(bin, gryimg)
%% Region Growing
% Inputs: Binary image created during candidate detection and it's matching
% grayscale image
% Outpits: Binary region grown image



for y = 1:length(bin)
    disp("Processing image " + y) %debudding message
    binary_img = bin{y};
    gray_img = gryimg{y};

    % Find centroids (i.e. candidates) and their area
    Blob1 = vision.BlobAnalysis('MinimumBlobArea', 3, 'MaximumCount', 30000);
    [area, centroid, bbox] = Blob1(binary_img);

    % Determine coordinates for centroids
    centroid = round(centroid);
    pixel_row = centroid(:,1);
    pixel_col = centroid(:,2);

    % Determine the location of the white pixels in the binary image
%     [pixel_row, pixel_col] = find(binary_img);

    % Create 11x11 search window around each candidate
    for i = 1: length(pixel_row)
        lowRow = pixel_row(i) - 5;
        highRow = pixel_row(i) + 5;
        lowCol = pixel_col(i) - 5;
        highCol = pixel_col(i) + 5;

        %Conditional statements to ensure that search window bounds are
        %within the image range
        if lowRow < 1
            lowRow = 1;
        end
        if highRow > size(binary_img,1)
            highRow = size(binary_img,1);
        end
        if lowCol < 1
            lowCol = 1;
        end
        if highCol > size(binary_img,2)
            highCol = size(binary_img,2);
        end

        % Create seach window once the boundaries are verified
        search_window = gray_img(lowRow:highRow,lowCol:highCol);
        binary_window = binary_img(lowRow:highRow,lowCol:highCol);
        
        % Initialise pixel_value array to store grayscale values
        gray_value = [];
        counter = 1;

        % Get the grayscale values of the white pixels in the given search
        % window
        [row, col] = find(binary_img);
        for z=1: length(col)
            if col(z) > lowCol && col(z) < highCol
                if row(z) > lowRow && row(z) < highRow
                    gray_value(counter) = gray_img(row(z), col(z));
                    counter = counter+1;
                end
            end
        end

        % Calculate mean and standard deviation of the grayscale values
        avg = mean(gray_value);
        stdev = std(double(gray_value));

        % Compute quantile interval
        interval = norminv([0.005, 0.995], avg, stdev);

        % If that calculated gray-level value is within the interval,
        % classify that pixel as a candidate pixel
        for m = 1: numel(search_window)
%             if binary_window(m) == 1
                if search_window(m) > interval(1) && search_window(m) < interval(2)
                    binary_window(m) = 1;
                else
                    binary_window(m) = 0;
                end
%             end
        end
        region_grown(lowRow:highRow, lowCol: highCol) = binary_window;
    end
    
    image{y} = region_grown;

end


Discriminants = image;

%% Morphological Cues
% Inputs: Binary region grown images of each frame
% Outputs: Bounding box of tracked vehicles

for j = 1:length(image)
    hBlobAnalysis = vision.BlobAnalysis('MajorAxisLengthOutputPort',true,'EccentricityOutputPort',true,'ExtentOutputPort',true, ...
        'MaximumCount',100000000,'MinimumBlobArea',5,'MaximumBlobArea',1000);
    [area, centroid, bbox, majoraxis, eccentricity, extent] = hBlobAnalysis(image{y});

    % Setup thresholds
    th_area = [40,80];
    th_extent = [0.3, 0.9];
    th_majoraxis = [3, 15];
    th_eccentricity = [0.2, 0.8];

    % Threshold morphological cues
    k = 1;

    % Setup empt array
    new_area= []; new_extent = []; new_majoraxis = []; new_eccentricity = []; new_bbox = []; new_centroid = [];
    
    % Threshold each candidate cluster based on the above determined thresholds
    for i = 1:length(area)
        if (th_area(1) < area(i)) && (area(i) < th_area(2)) && (th_extent(1) < extent(i)) && (extent(i) < th_extent(2)) && ...
                (th_majoraxis(1) < majoraxis(i)) && (majoraxis(i) < th_majoraxis(2)) && ...
                (th_eccentricity(1) < eccentricity(i)) && (eccentricity(i) < th_eccentricity(2))

            new_area(k) = area(i);
            new_extent(k) = extent(i);
            new_majoraxis(k) = majoraxis(i);
            new_eccentricity(k) = eccentricity(i);
            new_bbox(k,:) = bbox(i,:);
            new_centroid(k,:) = centroid(i,:);
            k = k+1;

        end
    end

end








