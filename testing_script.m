%% Initial Setup
clear; clc;

fileLocation = 'C:\Users\vraj\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001';
nameTemplate = '%06d';
frameRange = [1 20];

%% Generatre initial data
p = parser(fileLocation, nameTemplate, frameRange)


%% Extract single frame and display it
p2 = p.file_index(53)
% imshow(p2.frame);
% hold on;
% rectangle('Position', [582,24,6,9],'FaceColor',[0 .5 .5])

%% Load csv data
p3 = p2.read_csv()

%% Object Detection
[bin, gryimg] = candidateDetection(p);

%% Candidate Discrimination
candidates = candidateDiscrimination(bin, gryimg);
figure, imshow(candidates{1});
figure, imshow(bin{1});