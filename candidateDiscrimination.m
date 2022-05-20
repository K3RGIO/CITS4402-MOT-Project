%% Testing stuff
function [Discriminants] = candidateDiscrimination(bin, gryimg)
% Determine the location of the white pixels in the binary image
for y = 1:length(bin)
    binary_img = bin{y};
    gray_img = gryimg{y};
    [pixel_row, pixel_col] = find(binary_img);

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

        % Get the grayscale values of the candidates in the given search
        % window
        for z=1: length(pixel_col)
            if pixel_col(z) > lowCol && pixel_col(z) < highCol
                if pixel_row(z) > lowRow && pixel_row(z) < highRow
                    gray_value(counter) = gray_img(pixel_row(z), pixel_col(z));
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
% Discriminants = image;



end








