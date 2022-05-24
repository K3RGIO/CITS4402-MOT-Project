
% DEFINITIONS

% HYPOTHESES = Outputs of the discrimination (true vehicles and some
% noise). Basically the output of the candidate discrimination step. Final
% outputs of detecting and tracking framework are also hypotheses. 

% x = state vector
% F = evolution matrix CONSTANT MATRIX
% v = procedure of noise vector 

% y = measurement vector 
% H = measurement matrix CONSTANT MATRIX
% n = measurement noise 

% i = current track or current frame?
% k = frames interval (should be set to 1)

% ------------------------------------------------------------------------
%                          Kalman Filter
% ------------------------------------------------------------------------

% ---------------------------- STEP 1 ------------------------------------
% INITIALISATION. Setting up motion and observation models. Use this motion model to
% predict the next position of the track....

% MOTION MODEL Attach a state vector to each current track 
    % Stores x and y coordinates of centroid, velocity and acceleration of
    % tracked object 
        % x(i) = [x y vx vy ax ay]

% The state vector for the next frame x(i+1) is given by matrix math thing 
% where the time between frames (tau) = 1

% OBSERVATION MODEL Extract observation (position) from the state vector 
% (of the next frame?) by matrix multiplication

% Modelisation of the uncertainty (noise) of the above models 
    % Covariance matrix of the MOTION MODEL
        % Qk based on standard deviation of position estimate, standard
        % deviation of velocity estimate, standard deviation of
        % acceleration estimate
    % Covariance matrix of the OBSERVATION MODEL
        % Rk based on standard deviation of the moving object detection
        % algorithm estimate 
    % WE NEED TO DETERMINE APPROPRIATE VALUES FOR THE STANDARD DEVIATIONS 

% ---------------------------- STEP 1.1 ------------------------------------
% Initialising new tracks... 

% MOTION MODEL Same as before 
    % Position set to centroid of detected pixels path (candidate) and
    % default speed and acceleration are 0 
        % x(new) = [x y 0 0 0 0]
% OBSERVATION MODEL Also same as before? Possibly not required for this
% step.
% Keep track of covariance matrix Pk which is initialised as equal to Qk 
    % Only mentions covariance matrix of MOTION MODEL so perhaps don't need
    % OBSERVATION MODEL in this step 

% ---------------------------- STEP 2 ------------------------------------
% PREDICTION. Kalman filter prediction step for tracks. Use a measure of the state of
% the track (state vector?) with the motion prediction to get a filtered
% state of the track...

% Update the track position usign the MOTION MODEL, based on values respective
% to k and k-1, and compute:
    % x_pred_pri Predicted state vector 
    % P_pred_pri Predicted estimate covariance 

% ---------------------------- STEP 3 ------------------------------------
% HYPOTHESIS TO TRACK ASSOCIATION - finding the optimal match between
% multiple tracks and multiple hypotheses...

% Use inbuilt hungarian algorithm in Matlab "assignDetectionsToTracks"
    % [assignments,unassignedTracks,unassignedDetections] 
    % = assignDetectionsToTracks(costMatrix,costOfNonAssignment)
    % [assignments,unassignedTracks,unassignedDetections] 
    % = assignDetectionsToTracks(costMatrix, unassignedTrackCost,unassignedDetectionCost)

% ---------------------------- STEP 4 ------------------------------------
% Nearest searching, correction and termination. Deal with unassigned tracks...

% Forward unassigned tracks to a local search algorithm 
    % Correlate a square window around the object to the previous frame
    % with a local neighbourhood of the previous position in the current
    % frame 

    % Lecture 10 - page 56 - gives list of matching metrics idk what they
    % mean 

% Unmatched tracks discarded 

% Unassigned hypotheses assigned to new tracks that are initialised (Step
% 1.1)

% ---------------------------- STEP 5 ------------------------------------
% UPDATE the state estimate of the Kalman filter...

% Measured values of zk are centroids of each cluster in the hypothesis map

% Compute the innovation (error) between measurement and prediction 
    % yk = zk - Hk*x_pred_pri

% Compute covariance of innovation
    % Sk = Hk*P_pred_pri*HkT + Rk

% Compute optimal Kalman gain
    % Kk

% Compute updated state estimate 
    % x_pred_post

% Compute updated state covariance  
    % x_pred_post

% Use ^ in the next iteration of the algorithm 

% ------------------------------------------------------------------------
%                          Tracking Loop
% ------------------------------------------------------------------------

% Do above steps for the next frame?

% Measure performance of the model by reporting the precision, recall and
% F1 scores of the model based on numbers of true positives and true
% negatives 





