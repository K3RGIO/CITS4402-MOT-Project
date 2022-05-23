%% Initial Setup
clear; clc;

fileLocation = 'C:\Users\vraj\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001';
nameTemplate = '%06d';
frameRange = [1 40];

%% Generatre initial data
p = parser(fileLocation, nameTemplate, frameRange);

%% Extract single frame and display it
p2 = p.file_index(10);
figure, imshow(p2.frame);
hold on;
% rectangle('Position', [582,24,6,9],'FaceColor',[0 .5 .5])

%% Load csv data
p3 = p2.read_csv()

%% Candidate Detection
[bin, gryimg] = candidateDetection(p);

%% Candidate Discrimination
candidates = candidateDiscrimination(bin, gryimg);
% figure, imshow(candidates{1});
% figure, imshow(bin{10});

%% Testing
props = regionprops(bin{1}, 'MajorAxisLength', 'Orientation', 'Area','Centroid');
count = 1;
for i = 1:length(props)
    if props(i,1).Area > 2
        cluster(count) = props(i);
        pixel_row(count) = round(cluster(count).Centroid(1));
        pixel_col(count) = round(cluster(count).Centroid(2));
        count = count+1;
    end
end

%% Morph

frame = 30;

hBlobAnalysis = vision.BlobAnalysis('MajorAxisLengthOutputPort',true,'EccentricityOutputPort',true,'ExtentOutputPort',true,'MaximumCount',100000000, ...
    'MinimumBlobArea',5,'MaximumBlobArea',1000);
[area, centroid, bbox, majoraxis, eccentricity, extent] = hBlobAnalysis(candidates{frame+1});

th_area = [5,30];
th_extent = [0.6, 0.7];
th_majoraxis = [8, 21];
th_eccentricity = [0.7, 0.9];


k = 1;
new_area= []; new_extent = []; new_majoraxis = []; new_eccentricity = []; new_bbox = []; new_centroid = [];
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

p2 = p.file_index(frame);
figure, imshow(p2.frame);
hold on;

for i = 1:length(new_bbox)
rectangle('Position', [new_bbox(i,1),new_bbox(i,2),new_bbox(i,3),new_bbox(i,4)],'EdgeColor',[1, 0, 0, 0.7],'FaceColor',[0,0,1,0.2],'LineWidth',2)
end

%% test

p2 = p.file_index(27);
figure, imshow(p2.frame);
hold on;
for i = 1: length(p3.csv.Frame)
    if p3.csv.Frame(i) == 27
        rectangle('Position', [table2array(p3.csv(i,3)),table2array(p3.csv(i,4)),table2array(p3.csv(i,5)),table2array(p3.csv(i,6))],'EdgeColor',[1, 0, 0, 0.7],'FaceColor',[0,0,1,0.2],'LineWidth',2);
    end
end