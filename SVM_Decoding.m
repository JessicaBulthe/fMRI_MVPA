% SVM analyse: alle condities
function [DATA, VAR, ROI] = SVM_Decoding(ROInr, ROIname, rootDir, subject, resultDir, DATA, VAR, ROI)

%% Loading in data, normalizing and removing NaN
cd(rootDir);

DATA = rmfield(DATA, 'PSC_select'); 
DATA = rmfield(DATA, 'PSC_all');
DATA.PSC_all = DATA.raw; 

% naam van opslaan
[path] = make_folder(resultDir, char(subject));
file = [path 'Analyses_' char(subject) '.xls'];
   
% remove NaN
[DATA, ROI] = remove_NaN(ROI, VAR, DATA);

% normalization for decoding
[DATA] = normalization_decoding(VAR, DATA);

%% Decoding Analysis
% how many training and test runs? 
proportion_training_runs = 0.70;
[nrRuns_training, nrRuns_test] = HowMany_Training_Test_Runs(VAR, proportion_training_runs);

%pre-allocate resultmatrix
classRateAll = zeros(VAR.nCond-1,VAR.nCond,VAR.nRep);

for rep=1:VAR.nRep
    clear trainingSamples trainingLabels indTestSamples indTestLabels testSamples testLabels;
    for c1=1:VAR.nCond-1,
        for c2=c1+1:VAR.nCond,
            % divide training and test data 
            [trainingSamples, testSamples, trainingLabels, testLabels] = make_training_test_samples(nrRuns_test, nrRuns_training, VAR, ROI, DATA, c1, c2, c1, c2);
            
            % train and test the model
            model = svmtrain2(trainingLabels', trainingSamples', '-s 1 -t 0 -d 1 -g 1 -r 1 -c 1 -n 0.5 -p 0.1 -m 45 -e 0.001 -h 1');
            [~,y,~] = svmpredict2(testLabels', testSamples', model);
            classRateAll(c1,c2,rep) = y(1)/100;
        end       
    end
end
    
%% calculate measures of decoding matrix
SVMresult = mean(classRateAll,3);
mean_symbols = mean([SVMresult(1,2) SVMresult(1,3) SVMresult(1,4) SVMresult(2,3) SVMresult(2,4) SVMresult(3,4)]);
mean_dots = mean([SVMresult(5,6) SVMresult(5,7) SVMresult(5,8) SVMresult(6,7) SVMresult(6,8) SVMresult(7,8)]);
mean_symbolsdots = mean([SVMresult(1,5) SVMresult(1,6) SVMresult(1,7) SVMresult(1,8) SVMresult(2,5) SVMresult(2,6) SVMresult(2,7) SVMresult(2,8) SVMresult(3,5) SVMresult(3,6) SVMresult(3,7) SVMresult(3,8) SVMresult(4,5) SVMresult(4,6) SVMresult(4,7) SVMresult(4,8)]);

%% write data to excel
Analyse = cellstr('Decoding Analyses');
ConditionNames1 = {'2' '4' '6' '8' '2*' '4*' '6*' '8*'};
ConditionNames2 = {'2'; '4'; '6'; '8'; '2*'; '4*'; '6*'};
MeanNames =  {'Cijfers'; 'Dots'; 'Cijfer Dots'};

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

xlswrite1(file, Analyse, ROInaam, 'A12');
xlswrite1(file, ConditionNames1, ROInaam, 'C13:J13');
xlswrite1(file, ConditionNames2, ROInaam, 'B14:B20');
xlswrite1(file, SVMresult, ROInaam, 'C14:J20');
xlswrite1(file, MeanNames, ROInaam, 'L14:L16');
xlswrite1(file, mean_symbols, ROInaam, 'M14');
xlswrite1(file, mean_dots, ROInaam, 'M15');
xlswrite1(file, mean_symbolsdots, ROInaam, 'M16');

% sluiten excel
ExcelWorkbook.Save
ExcelWorkbook.Close(false) % Close Excel workbook.
Excel.Quit;
delete(Excel); 

%% save to data matrix
charsubject = char(subject);
[DD] = check_group(charsubject);

results_dec = [DD str2num(charsubject(1,2:size(charsubject,2))) ROINAME mean_symbols mean_dots mean_symbolsdots];
[results] = write_to_datamat([resultDir 'all_results_decoding.mat'], results_dec);

save([resultDir 'all_results_decoding.mat'], 'results');

save([path 'Dec_Subject_' char(subject) '_ROI_' num2str(ROIname{ROInr}) '.mat'], 'SVMresult',  'VAR', 'ROI', 'DATA', 'subject', 'ROINAME');

