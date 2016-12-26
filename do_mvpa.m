function [resultDir] = do_mvpa(subjectIDs, selected_ROIs, HomeDir, ROINames)
warning('OFF', 'MATLAB:xlswrite:AddSheet');

%% Make directory variables
% rootDir (directory with scripts), resultDir (directory to store 
% results) & figureDir (directory to store figures)
rootDir= [HomeDir 'scripts' filesep]; 
roiDir = [HomeDir 'ROIs' filesep 'Anatomisch 0.001' filesep];
resultDir = make_folder(HomeDir, 'results\Final\');
figureDir = make_folder(HomeDir, 'Figures');

% excel file with numbers and names of the ROIs
ROIName_File = [roiDir ROINames];

%% Make data structures for summarizing the MVPA matrices 
% If the data_matrices are not made yet (this is probably done 
% only the first time you run this analysis for a study)
do_data_matrices_exist = dir([resultDir '*.mat']); 

if size(do_data_matrices_exist,1) == 0
    make_data_matrices(resultDir);
end

%% Read in the names of the ROIs 
% For writing to excel, the tabs will have the same names as the ROIs (so
% not the number, but the name itself).
do_roi_mat_exist = exist([rootDir 'ROINames.mat'], 'file');

if do_roi_mat_exist ~= 2
    read_in_ROINames(ROIName_File);
end

%% Do the MVPA analyses for every subject & ROI
% do the correlation, decoding, generalization and confusion 
% analysis for every subject and every ROI
aantal_subjects = size(subjectIDs,2); 
for i = 1:aantal_subjects
    c = clock;
    subject = subjectIDs(i);
    disp([char(subject) ' started at ' num2str(c(4)) 'u' num2str(c(5))]);
    SubjectSpecDir = [HomeDir 'Statistiek' filesep char(subject) filesep 'Exp' filesep];
    ROIDir = [roiDir char(subject) filesep];
    
    if size(selected_ROIs,1) > 0 
        Aantal_ROIs = size(selected_ROIs,2);
        ROIname = selected_ROIs; 
    else
        [Aantal_ROIs, ROIname] = load_ROI_information(ROIDir);
    end
    
    cd(rootDir);
    run_analyses(Aantal_ROIs, ROIDir, ROIname, rootDir, SubjectSpecDir, subject, resultDir);
end
