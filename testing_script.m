%% Initial Setup
clear; clc;

fileLocation = 'C:\Users\vraj\OneDrive - The University of Western Australia\Uni\2022\Computer Vision\Project\VISO\mot\car\001';
nameTemplate = '%06d';
frameRange = [100 130];

%% Generate initial data
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
[candidates, centroid, bbox] = candidateDiscrimination(bin, gryimg,p);
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


%% test

p2 = p.file_index(27);
figure, imshow(p2.frame);
hold on;
for i = 1: length(p3.csv.Frame)
    if p3.csv.Frame(i) == 27
        rectangle('Position', [table2array(p3.csv(i,3)),table2array(p3.csv(i,4)),table2array(p3.csv(i,5)),table2array(p3.csv(i,6))],'EdgeColor',[1, 0, 0, 0.7],'FaceColor',[0,0,1,0.2],'LineWidth',2);
    end
end

%% waste of time and energy
pred_min_row = bbox_pred(:,1);
pred_min_col = bbox_pred(:,2);
pred_max_row = pred_min_row + bbox_pred(:,3);
pred_max_col = pred_min_row + bbox_pred(:,4);

gt_min_row = gt_data(:,1);
gt_min_col = gt_data(:,1);
gt_max_row = gt_min_row + gt_data(:,3);
gt_max_col = gt_min_col + gt_data(:,4);

box_pred = [pred_min_row,pred_min_col,pred_max_row,pred_max_col];
box_gt = [gt_min_row,gt_min_col,gt_max_row,gt_max_col];


xA = max(box_pred(1), box_gt(1));
yA = max(box_pred(2), box_gt(2));
xB = min(box_pred(3), box_gt(3));
yB = min(box_pred(4), box_gt(4));
