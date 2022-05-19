%% test
[pixel_row, pixel_col] = find(bin);
for i = 1: length(pixel_row)
    lowerRindex = pixel_row(i) -5;
    upperRindex = pixel_row(i) + 5;
    lowerCindex = pixel_col(i) - 5;
    upperCindex = pixel_col(i) + 5;
    pixel_values = [];
    n = 1;
    for b=1: length(pixel_col)
        if pixel_col(b) > lowerCindex && pixel_col(b) < upperCindex
            if pixel_row(b) > lowerRindex && pixel_row(b) < upperRindex
                pixel_values(n) = grayimg(pixel_row(b), pixel_col(b));
                n = n+1;
            end
        end
    end
    mu = mean(pixel_values);
    sigma = std(double(pixel_values));
    x = norminv([0.0025, 0.9975], mu, sigma);
    for m = 1: numel(search_window)
        if search_window(m) > x(1) && search_window(m) < x(2)
            search_window(m) = 1;
        else 
            search_window(m) = 0;
        end
    end
    final(lowerRindex:upperRindex, lowerCindex: upperCindex) = search_window;
end