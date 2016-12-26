%% Calculate mean matrices

subjectIDs = [{'C5'} {'C6'} {'C8'} {'C10'} {'C12'} {'C13'} {'D1'} {'D2'} {'D4'} {'D6'} {'D7'} {'D8'}];      

rois = [1 3 6:10];

filedir = 'E:\Research\Dyscalculie Studie\fMRI\results\';

for r = 1:size(rois,2)
    roi = rois(r);
    
    for s = 1:size(subjectIDs, 2)
        subject = subjectIDs(s)
        if exist([filedir char(subject) filesep 'Dec_Subject_' char(subject) '_ROI_'  num2str(roi) '.mat'], 'file') == 0
          % File does not exist
          % Skip to bottom of loop and continue with the loop
          continue;
        end
        
        load([filedir char(subject) filesep 'Dec_Subject_' char(subject) '_ROI_'  num2str(roi) '.mat']);
        
        all_decoding_matrices{r}(:,:,s) = SVMresult; 
    end
end



