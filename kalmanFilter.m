function [output] = kalmanFilter(self, bin, centroid, bbox)
    
    %% Constants (F = evolution matrix, H = measurement matrix)
    F = [1,0,1,0,0.5,0;0,1,0,1,0,0.5;0,0,1,0,1,0;0,0,0,1,0,1;0,0,0,0,1,0;0,0,0,0,0,1];
    H = [1,0,0,0,0,0;0,1,0,0,0,0];
    std_centroid = 1;
    std_vel = 2;
    std_acc = 2;

    %% Main function steps
    %InitialiseTracks
    for i = 1:length(centroid)
        hypothesis = centroid{i} 
        initialisedTracks = initialiseTracks(hypothesis);
        frame = 1;

        self = [initialisedTracks]

    end
    

    % Initialise tracks using the first frame
    function initialiseTracks(hypothesis)
        id = 1;
        initialisedTracks = [];

        for j = 1:length(hypothesis)
            centroid_x = round(hypothesis(j,1));
            centroid_y = round(hypothesis(j,2));
            acc_x = 0;
            acc_y = 0;
            state = [centroid_x; centroid_y; vel_x; vel_y; acc_x; acc_y];
            Q = diag([std_centroid^2,std_centroid^2,std_vel^2,std_vel^2,std_acc^2,std_acc^2]);
            initialisedTracks = [initialisedTracks, [id, state, Q]];
            id = id + 1;
        end
    end

    function initialiseNewTracks(hypothesis)
    end

    function predictTracks(initialisedTracks)
    end

    function trackAssociation(predictTracks, hypothesis, nonAssignmentCost)
    end

    function updateTracks(someInput)
    end

    function templateMatching(someInput)
    end

    


    % State vector for the next frame
    state_vector_ii = F .* state_vector + Q;

    R = [1, 0: 0, 1];

    Y = H .* state_vector_i + R;

   

    output
end

