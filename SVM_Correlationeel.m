function [DATA, VAR, ROI] = SVM_Correlationeel(ROInr, ROIname, rootDir, makeROI, SubjectSpecDir, subject, resultDir)

%% Loading in data, normalizing and removing NaN
cd(rootDir);

% inladen van SPM, ROI, 
[SPM, VAR, ROI] = load_in_variables(SubjectSpecDir, makeROI);

% naam van opslaan
[path] = make_folder(resultDir, char(subject));
file = [path 'Analyses_' char(subject) '.xls'];
   
% inladen van t-statistieken voor elke voxel in de ROI
[DATA] = load_in_tstats_ROI(VAR, SPM, ROI, SubjectSpecDir); 

% ruwe data opslaan
DATA.raw = DATA.PSC_all; 

% normalization for correlational MVPA
[DATA] = normalization_correlation(VAR, ROI, DATA);

% remove NaN
[DATA, ROI] = remove_NaN(ROI, VAR, DATA);

%% Correlationalanalysis
% how many training and test runs? 
proportion_training_runs = 0.50;
[nrRuns_training, nrRuns_test] = HowMany_Training_Test_Runs(VAR, proportion_training_runs);

for rep=1:VAR.nRep    
    clear trainingSamples trainingLabels indTestSamples indTestLabels testSamples testLabels;
    for c1=1:VAR.nCond-1,
        for c2=c1+1:VAR.nCond,     
            % divide training and test data 
            [trainingSamples, testSamples, ~, ~] = make_training_test_samples(nrRuns_test, nrRuns_training, VAR, ROI, DATA, c1, c2, c1, c2);

            % correlations between selectivity patterns (asymmetrical matrix)
            co = corrcoef(mean(trainingSamples(:,1:nrRuns_training),2),testSamples(:,1));            
            symMatrix(c1,c1,rep) = co(2,1);
            co = corrcoef(mean(trainingSamples(:,nrRuns_training+1:2*nrRuns_training),2),testSamples(:,2));            
            symMatrix(c2,c2,rep) = co(2,1);
            co = corrcoef(mean(trainingSamples(:,1:nrRuns_training),2),testSamples(:,2));            
            symMatrix(c1,c2,rep) = co(2,1);
            co = corrcoef(mean(trainingSamples(:,nrRuns_training+1:2*nrRuns_training),2),testSamples(:,1));            
            symMatrix(c2,c1,rep) = co(2,1);
        end   
    end
end

%% Berekenen van de gemiddelden 
symMatrixresult = mean(symMatrix,3);
[means] = calculate_correlation_measures(symMatrixresult);

%% write data to excel
Analyse = cellstr('Correlational Analyses');
MeanNames1 = {'Diag' 'NonDiag'};
MeanNames2 = {'Cijfers'; 'Dots'};

ROINAME = cellstr(ROIname{ROInr});
ROINAME = char(ROINAME);
ROINAME = str2num(ROINAME);

% read in roiname
[ROInaam] = Get_ROIName(rootDir, ROINAME);

ConditionNames1 = {'2' '4' '6' '8' '2*' '4*' '6*' '8*'};
ConditionNames2 = {'2'; '4'; '6'; '8'; '2*'; '4*'; '6*'; '8*'};

% open excel
[Excel, ExcelWorkbook] = OpenExcel(file);

% write to excel
xlswrite1(file, Analyse, ROInaam, 'A1');
xlswrite1(file, ConditionNames1, ROInaam, 'C2:J2');
xlswrite1(file, ConditionNames2, ROInaam, 'B3:B10');
xlswrite1(file, symMatrixresult, ROInaam, 'C3:J10');
xlswrite1(file, MeanNames1, ROInaam, 'M3:N3');
xlswrite1(file, MeanNames2, ROInaam, 'L4:L5');
xlswrite1(file, means.corr, ROInaam, 'M4:N5');

% close excel
CloseExcel(ExcelWorkbook, Excel);

%% Opslaan van gemiddelden naar datamatrix
charsubject = char(subject);
[DD] = check_group(charsubject);

% volgorde: groep / subjectnummer zonder groep / ROInaam / gemiddeldes
% correlaties
results_corr = [DD str2num(charsubject(1,2:size(charsubject,2))) ROINAME means.CD means.CND means.DD means.DND];

% inladen van mat-file met alle data
load([resultDir 'all_results_correlation.mat']);
[results] = write_to_datamat([resultDir 'all_results_correlation.mat'], results_corr);
save([resultDir 'all_results_correlation.mat'], 'results');

% opslaan van al de rest
save([path 'Corr_Subject_' char(subject) '_ROI_' num2str(ROIname{ROInr}) '.mat'], 'symMatrixresult',  'VAR', 'ROI', 'DATA', 'subject', 'ROINAME');

