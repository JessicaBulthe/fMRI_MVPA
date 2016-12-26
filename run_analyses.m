function run_analyses(Aantal_ROIs, ROIDir, ROIname, rootDir, SubjectSpecDir, subject, resultDir)

for ROInr = 1:Aantal_ROIs;
    % laden van ROI
    if exist([ROIDir char(ROIname(ROInr)) '.mat']) > 0
        load([ROIDir char(ROIname(ROInr))]);
    else
        continue;
    end
    
    [DATA, VAR, ROI] = SVM_Correlationeel(ROInr, ROIname, rootDir, makeROI, SubjectSpecDir, subject, resultDir);
    [DATA, VAR, ROI] = SVM_Decoding(ROInr, ROIname, rootDir, subject, resultDir, DATA, VAR, ROI);
    
    meanresult = [0 0];
    
    for OPTION = 1:2
        [meanresult] = SVM_Generalizatie(ROInr, OPTION, ROIname, rootDir, makeROI, ROI, SubjectSpecDir, meanresult, subject, DATA, resultDir, VAR);    
    end
    
     write_generalization_result(subject, ROInr, meanresult, ROIname, resultDir);
end