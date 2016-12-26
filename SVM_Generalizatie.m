%% SVM analyse: alle condities
function [meanresult] = SVM_Generalizatie(ROInr, option, ROIname, rootDir, makeROI, ROI, SubjectSpecDir, meanresult, subject, DATA, resultDir, VAR)

%% Loading in data, normalizing and removing NaN
cd(rootDir);

% naam van opslaan
[path] = make_folder(resultDir, char(subject));
file = [path 'Analyses_' char(subject) '.xls'];

% Optie 1
% Trainen      Testen
% 2* vs 4*     2 vs 4
% 2* vs 6*     2 vs 6
% 2* vs 8*     2 vs 8
% 4* vs 6*     4 vs 6
% 4* vs 8*     4 vs 8
% 6* vs 8*     6 vs 8

% Optie 2
% Trainen      Testen
% 2 vs 4       2* vs 4*
% 2 vs 6       2* vs 6*
% 2 vs 8       2* vs 8*
% 4 vs 6       4* vs 6*
% 4 vs 8       4* vs 8*
% 6 vs 8       6* vs 8* 

if option == 1
   n1 = [5 5 5 6 6 7];
   n2 = [6 7 8 7 8 8];
   n3 = [1 1 1 2 2 3];
   n4 = [2 3 4 3 4 4];
elseif option == 2
   n1 = [1 1 1 2 2 3];
   n2 = [2 3 4 3 4 4];
   n3 = [5 5 5 6 6 7];
   n4 = [6 7 8 7 8 8];
end

aantal = size(n1);

% how many training and test runs? 
proportion_training_runs = 0.70;
[nrRuns_training, nrRuns_test] = HowMany_Training_Test_Runs(VAR, proportion_training_runs);

classRateAll = zeros(aantal(2), VAR.nRep);

for rep=1:VAR.nRep    
    clear trainingSamples trainingLabels indTestSamples indTestLabels testSamples testLabels;
    for i=1:aantal(2)
        c1 = n1(i);
        c2 = n2(i);
        c3 = n3(i);
        c4 = n4(i);
        
        % divide training and test data 
        [trainingSamples, testSamples, trainingLabels, testLabels] = make_training_test_samples(nrRuns_test, nrRuns_training, VAR, ROI, DATA, c1, c2, c3, c4);

        % train and test the model
        model = svmtrain2(trainingLabels', trainingSamples', '-s 1 -t 0 -d 1 -g 1 -r 1 -c 1 -n 0.5 -p 0.1 -m 45 -e 0.001 -h 1');
        [~,y,~] = svmpredict2(testLabels', testSamples', model);
        classRateAll(i,rep) = y(1)/100;
    end
end
           
SVMresult = mean(classRateAll,2);
mean_generalization = mean(SVMresult);

if option == 1
    meanresult(1) = mean_generalization;
elseif option == 2
    meanresult(2) = mean_generalization;
end

% write data
cd(rootDir);

Analyse = cellstr('Generalization Analyses');
Hoofding = {'Trainen' 'Testen' 'Resultaat'};

if option == 1
    ConditiesTraining = {'2* vs 4*'; '2* vs 6*'; '2* vs 8*'; '4* vs 6*'; '4* vs 6*'; '4* vs 8*'};
    ConditiesTest = {'2 vs 4'; '2 vs 6'; '2 vs 8'; '4 vs 6'; '4 vs 6'; '4 vs 8'};
    MeanName = {'Dots > Cijfers'};
elseif option == 2
    ConditiesTraining = {'2 vs 4'; '2 vs 6'; '2 vs 8'; '4 vs 6'; '4 vs 6'; '4 vs 8'};
    ConditiesTest = {'2* vs 4*'; '2* vs 6*'; '2* vs 8*'; '4* vs 6*'; '4* vs 6*'; '4* vs 8*'};
    MeanName = {'Cijfers > Dots'};
end

ROINAME = cellstr(ROIname{ROInr});
ROINAME = char(ROINAME);
ROINAME = str2num(ROINAME);

% read in roiname
[ROInaam] = Get_ROIName(rootDir, ROINAME);

% openen excel
Excel = actxserver ('Excel.Application');
if ~exist(file,'file')
    ExcelWorkbooks = Excel.workbooks.Add;
    ExcelWorkbooks.SaveAs(file,1);
    ExcelWorkbooks.Close(false);
end
ExcelWorkbook = Excel.Workbooks.Open(file); 

switch option
    case 1,
        xlswrite1(file, Analyse, ROInaam, 'A22');
        xlswrite1(file, Hoofding, ROInaam, 'A23:C23');
        xlswrite1(file, ConditiesTraining, ROInaam, 'A24: A29');
        xlswrite1(file, ConditiesTest, ROInaam, 'B24: B29');
        xlswrite1(file, SVMresult, ROInaam, 'C24: C29');
        xlswrite1(file, MeanName, ROInaam, 'H24');
        xlswrite1(file, mean_generalization, ROInaam, 'I24');
    case 2,
        xlswrite1(file, Analyse, ROInaam, 'A22');
        xlswrite1(file, Hoofding, ROInaam, 'D23:F23');
        xlswrite1(file, ConditiesTraining, ROInaam, 'D24: D29');
        xlswrite1(file, ConditiesTest, ROInaam, 'E24: E29');
        xlswrite1(file, SVMresult, ROInaam, 'F24: F29');
        xlswrite1(file, MeanName, ROInaam, 'H25');
        xlswrite1(file, mean_generalization, ROInaam, 'I25');
end

% sluiten excel
ExcelWorkbook.Save
ExcelWorkbook.Close(false) % Close Excel workbook.
Excel.Quit;
delete(Excel); 

save([path 'Gen_Subject_' char(subject) '_ROI_' num2str(ROIname{ROInr}) '_Option_' num2str(option) '.mat'], 'SVMresult',  'VAR', 'ROI', 'DATA', 'subject', 'ROINAME');

