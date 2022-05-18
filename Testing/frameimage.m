function FrameImage = frameimage(fileLocation, frame_index)
            
            ImageNameTemplate = '%06d';

            fileroute = append("%s/img/",ImageNameTemplate, '.jpg');

            img = sprintf(fileroute,fileLocation,frame_index);

            FrameImage = imread(img);
end
