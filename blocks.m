
img = imread('peppers.png');

[m,n] = size(img);
x_pixels_range = 1:30;
y_pixels_range = 1:30;

imagesc(image(x_pixels_range,y_pixels_range,:));


