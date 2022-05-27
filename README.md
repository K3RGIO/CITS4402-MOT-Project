# CITS4402 README FILE

The GUI consists of different tabs corresponding to the following steps in the project.

1. *PARSER*
	Input: Selected folder and optional frame range. 
	Output: Loaded frames.

The parser enables the user to load the relevant project data. Once a folder is selected, frames are only loaded when queried (i.e. when the 'Load Data' button is pushed). If the frame range is not manually set, the parser automatically loads all frames in that folder and defines the frame range in the external function. The loaded frames are then displayed in the 'Data Preview' panel. 

2. *CANDIDATE DETECTION*
	Input: for each frame index n from 1 to N-1, this step takes as input the frames at index n-k, n and n+k. 
	Output: for each frame index n from 1 to N-1, this step outputs a binary image representing candidate small objects.

This step uses a set frame interval (k) of 5 as this was found to produce more accurate results. If the frame interval is set too low, the inter-frame differences are predominantly artefacts due to regular and irregular noises that are present in consecutive frames. 

These frames are split into 30 x 30 pixel blocks. The inter-frame differences and averages are then computed to threshold the images and extract candidates to produce a series of binary images. These are displayed in the 'Identified Candidates' panel in the GUI. 

3. *CANDIDATE MATCH DISCRIMINATION*
	Input: for each frame index n from 1 to N-1, this step takes as input a binary image representing the candidate small objects
	Output: for each frame index n from 1 to N-1, this step outputs the bounding box and centroid of each candidate small object

The minimum blob area is specified as 3, to find the centroids and bounding boxes of the candidates. 11 x 11 search windows are created, centred around the coordinates of the candidate centroids. Grayscale values are extracted for the relevant search window and the mean and standard deviation of these pixels is computed. This is normalised and used to threshold the calculated gray-scale values and if it falls within that 0.05-99.5 % quantile interval, the pixel is classified as a candidate pixel and the region growing step is complete. 

Morphological cue based discrimination is then performed. This utilises vision.blob.analysis to compute the morphological information. Bounding boxes from gt.txt, of the relevant frames, is compared to calculated bounding boxes using the intersection over union (IoU) metric. If this value is greater than 0.1, the regions are considered matching at this stage. Although this is lower than the optimal value of 0.7, lowering the acceptable limit was necessary at this stage to find matching regions. Regions that are not accepted are stored as rejected data. 

The mean and standard deviation of all cues is used to plot and analyse the properties of all accepted and rejected candidates. Normalising and overlapping the accepted and rejected cues enables the calibration of each morphological cue to determine the interval. Ideally, the maximum would be chosen as the highest proportion of accepted regions and lowest proportion of rejected regions. The minimum can be set as the lower bound of the accepted region. However, as both distributions overlapped significantly, this method was not viable and default thresholds were manually determined. The GUI enables the user to manually choose thresholds as well. 

4. *KALMAN FILTER AND TRACKING LOOP*
Although this step is incomplete, the "kalmanFilter.m" file contains the initial attempt and the following explanation covers further steps that would have been done. Ultimately, as the prior steps were more timeconsuming than anticipated, there was little time left to create and troubleshoot the tracking loop. 

	Input: for each frame index n from 1 to N-1, this step takes as input a binary image representing candidate small objects, as well as the state of the tracker (the Kalman state vectors for each tracks, and the corresponding covariances estimates) from the previous frame
	Output: a series of tracks, each made up of a Kalman state vector representing the position, speed and acceleration of the tracked small objects

HYPOTHESES = Outputs of the discrimination (true vehicles and some noise). Essentially the output of the candidate discrimination step. Final outputs of detecting and tracking framework are also hypotheses. 

---------------------------- STEP 1 ------------------------------------
INITIALISATION. Setting up motion and observation models. Use this motion model to predict the next position of the track....

MOTION MODEL Attach a state vector to each current track 
    Stores x and y coordinates of centroid, velocity and acceleration of tracked object
    ```Matlab
        x(i) = [x y vx vy ax ay]
	```
The state vector for the next frame `x(i+1)` is given by matrix math where the time between frames `(tau) = 1`

OBSERVATION MODEL Extract observation (position) from the state vector (of the next frame?) by matrix multiplication

Modelisation of the uncertainty (noise) of the above models 
Covariance matrix of the MOTION MODEL
	Qk based on standard deviation of position estimate, standard deviation of velocity estimate, standard deviation of acceleration estimate
Covariance matrix of the OBSERVATION MODEL
	Rk based on standard deviation of the moving object detection algorithm estimate 

*Determine appropriate values for standard deviations

---------------------------- STEP 1.1 ------------------------------------
Initialising new tracks... 

MOTION MODEL Same as before 
    Position set to centroid of detected pixels path (candidate) and
    default speed and acceleration are 0
	```Matlab
        x(new) = [x y 0 0 0 0]
	```
Keep track of covariance matrix Pk which is initialised as equal to `Qk`

---------------------------- STEP 2 ------------------------------------
PREDICTION. Kalman filter prediction step for tracks. Use a measure of the state of
the track (state vector) with the motion prediction to get a filtered
state of the track...

Update the track position usign the MOTION MODEL, based on values respective
to `k` and `k-1`, and compute:
```Matlab
    x_pred_pri Predicted state vector 
    P_pred_pri Predicted estimate covariance 
```

---------------------------- STEP 3 ------------------------------------
HYPOTHESIS TO TRACK ASSOCIATION - finding the optimal match between
multiple tracks and multiple hypotheses...

Use inbuilt hungarian algorithm in Matlab `assignDetectionsToTracks`
```Matlab
    [assignments,unassignedTracks,unassignedDetections] = assignDetectionsToTracks(costMatrix,costOfNonAssignment)
    [assignments,unassignedTracks,unassignedDetections] = assignDetectionsToTracks(costMatrix,unassignedTrackCost,unassignedDetectionCost)
```

---------------------------- STEP 4 ------------------------------------
Nearest searching, correction and termination. Deal with unassigned tracks...

Forward unassigned tracks to a local search algorithm 
    Correlate a square window around the object to the previous frame
    with a local neighbourhood of the previous position in the current
    frame 

Unmatched tracks discarded 

Unassigned hypotheses assigned to new tracks that are initialised (Step
1.1)

---------------------------- STEP 5 ------------------------------------
UPDATE the state estimate of the Kalman filter...

Measured values of `zk` are centroids of each cluster in the hypothesis map

Compute the innovation (error) between measurement and prediction
```Matlab
    yk = zk - Hk*x_pred_pri
```

Compute covariance of innovation
```Matlab
    Sk = Hk*P_pred_pri*HkT + Rk
```
Compute optimal Kalman gain
```Matlab
    Kk
```

Compute updated state estimate 
    x_pred_post

Compute updated state covariance
```Matlab
    x_pred_post
```

Use ^ in the next iteration of the algorithm 

------------------------------------------------------------------------
                          Tracking Loop
------------------------------------------------------------------------
Do above steps for the next frame using input from previous frame

Measure performance of the model by reporting the precision, recall and
`F1` scores of the model based on numbers of true positives and true
negatives 
