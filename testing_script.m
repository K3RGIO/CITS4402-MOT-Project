%% Initial Setup
clear; clc;

fileLocation = 'C:\Users\Vraj\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001';
nameTemplate = '%06d';
frameRange = [10 80];

%% Generatre initial data
p1 = parser(fileLocation, nameTemplate, frameRange)

%% Extract single frame and display it
p2 = p1.file_index(53)
imshow(p2.frame);

%% Load csv data
p3 = p2.read_csv()