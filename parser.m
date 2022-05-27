classdef parser
    % Parser to load relevant project data

    properties

        fileLocation % Path to the images that are to be loaded
        frameRange % Range of images to load
        nameTemplate % Naming scheme of image files
        frame % When attempting to load a single frame
        csv % Load trimmed gt.txt data
        numberOfFrames %
    end

    methods

        % Function to process inputs
        function imageData = parser(fileLocation, nameTemplate, frameRange)
            % Assign input fields to class properties
            imageData.fileLocation = fileLocation;
            imageData.nameTemplate = nameTemplate;

            % Store all filenames inside specified folder in an array
            array = dir(fullfile(fileLocation, '/img'));

            % Remove folder from the array (namely '.' and '..')
            array = array(~[array.isdir]);

            % Determine number of images in selection by calculating the
            % size of the array
            numberOfFrames = length(array);
            imageData.numberOfFrames = numberOfFrames;

            % Assign frameRange property by first checking if it has been
            % specified
            if ~exist('frameRange','var') == 1
                % Create 1x2 matrix encompassing all files in the folder
                imageData.frameRange = [1 numberOfFrames];
            else
                % Use specified frameRange otherwise
                imageData.frameRange = frameRange;
            end

        end

        % Function to index files and open selected one
        function [imageData] = file_index(imageData, frameIndex)
            % Convert input arg into a string using the nameTemplate
            frameNumber = append('%s/img/',imageData.nameTemplate,'.jpg');

            % Determine the overall filepath of the selected frame by
            % appending the selectedFrame onto the fileLocation
            fullFilePath = sprintf(frameNumber, imageData.fileLocation,frameIndex);
            

            % Read file
            selectedFrame = imread(fullFilePath);

            % Store selectredFrame as proterty of imageData
            imageData.frame = selectedFrame;
        end

        % Function to load ground truth data
        function [imageData] = read_csv(imageData)
            % Determine location of gt.txt file for given input             
            csvLocation = sprintf('%s/gt/gt.txt', imageData.fileLocation);

            % Read csv data
            csv = readtable(csvLocation);

            % Remove unrequired data
            csv = removevars(csv, {'Var7','Var8','Var9','Var10'});

            % Assign variables names for readibility
            csv.Properties.VariableNames = {'Frame','TrackID','x','y','width','height'};

            % filter for frame range
            % table_filtered = table(table.Frame == 1, :);

            
            imageData.csv = csv;

        end
    end
end
