classdef Satellite_Img_Parser
    %Class to parse images retrieving labeled locations of small objects
    %and frames when given a frame index

    properties (Dependent)
        FrameArray %Optional property to play with getting array for frame
    end

    properties
        FileLocation %the location of the gt and img folders for the given
                     %satellite image to be used
       
        FrameRange   %A 1x2 Matrix containing the starting and ending 
                     %frames of the satellite image, if not specified will 
                     %use default frame range
        
        ImageNameTemplate %Format of image names, in general will be '%06d.jpg'
    end

    methods
        function obj = Satellite_Img_Parser(File_Location, Image_Name_Template, Frame_Range)
            %Construct instance of class from the file location and range
            %to be considered. File location input should be down to the
            %three digit numbered folder which contains gt and img folders,
            %i.e 'VISO/mot/car/001. Frame range must be a row matrix with
            %two elements, the first being starting frame and second being
            %final frame, entering no Frame_Range value will set FrameRange
            %to be the frame range determined by the number of frame images
            %for that particular satellite image.Image_Name_Template should
            %be a string which includes the file type and the general
            %format of the data, for this project the usual expected value
            %will be '%06d.jpg'

            obj.FileLocation = File_Location;
            %assign file location property to object

            obj.ImageNameTemplate = Image_Name_Template;
            %assign image name template property to object

            a = dir(fullfile(File_Location, '/img'));
            numframes = size(a,1);
            %Counts number of files in img folder that are .jpg aka all
            %frames available for the given satellite image

            true_frame_range = [1 numframes];
            %Defines the range of frames for the selected satellite image

            if ~exist('Frame_Range','var')
            %Frame range not given, so default it to something
                

                obj.FrameRange = true_frame_range;
                %uses the true frame range of satellite image
            else
            %Frame range was specified
                mustBeGreaterThanOrEqual(Frame_Range(2),Frame_Range(1))
                mustBeGreaterThanOrEqual(Frame_Range(1),true_frame_range(1))
                mustBeLessThanOrEqual(Frame_Range(2),true_frame_range(2))
                mustBeLessThanOrEqual(Frame_Range(1),true_frame_range(2))
                %Setting up conditions that will return error message if
                %given range is not correctly input or not within the true
                %frame range of the satellite image

                obj.FrameRange = Frame_Range;
                %uses the given frame range from variable
            end
        end

        function gtarray = fetch_array(obj)
            %Retrieves the ground truth array for the given satellite img
            %with the object for the satellite image as an input
            
            gt_filename = sprintf('%s/gt/gt.txt',obj.FileLocation);
            %Creates string using file location for the gt file name and
            %file location for the given object

            gtarray = csvread(gt_filename);
            %Reads the txt file and creates array, includes all rows and
            %first 6 columns
            gtarray(:,7:end)=[];
            %remove the final columns from the array so only include
            %relative values
        end

        function FrameImage = frameimage(obj, frame_index)
            %Function for reading a specific frame from the satellite image
            %object. obj is the object created for the specific sattelite
            %image and frame image is an integer that must be within frame
            %range property of class

            mustBeInRange(frame_index,obj.FrameRange(1),obj.FrameRange(2));
            %Ensures that the frame index is within the FrameRange

            fileroute = append("%s/img/",obj.ImageNameTemplate);
            %appends the file directory and the image name template to be
            %passed into sprintf

            img = sprintf(fileroute,obj.FileLocation,frame_index);
            %creates file directory to the requested frame, note that %06d
            %ensures that the image name will be the frame index plus the
            %necessary number of 0's in front to have a 6 digit number

            FrameImage = imread(img);
            %Reads the particular frame index
        end
    end
end