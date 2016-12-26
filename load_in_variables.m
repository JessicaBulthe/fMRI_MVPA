%% [SPM_all, sess_all, nCond, nRep, condToTake] = load_in_variables(SubjectSpecDir)
% This function loads in the SPM.mat file, calculates the sessions and
% conditions. 

function [SPM, VAR, ROI] = load_in_variables(SubjectSpecDir, makeROI)

% inladen van SPM.mat file voor dat subject
load([SubjectSpecDir 'SPM.mat']);

% bepalen van hoeveel runs en hoeveel condities
VAR.nRuns = str2num(SPM.xsDes.Number_of_sessions);
VAR.nCond = str2num(SPM.xsDes.Trials_per_session(1,1))-1;

% hoeveel repetities wil je doen voor de mvpa?
VAR.nRep = 100;

% bereken de condToTake (opgelet voor t-statistieken)
VAR.condToTake = [];
for run = 1:VAR.nRuns
     VAR.condToTake = [VAR.condToTake run:VAR.nRuns:size(SPM.xCon,2)];
end

% ROI-specifieke informatie
ROI.XYZ = makeROI.selected.anatXYZ;
ROI.nVoxels=size(ROI.XYZ,2);
