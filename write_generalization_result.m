function write_generalization_result(subject, ROInr, meanresult, ROIname, resultDir)

ROINAME = cellstr(ROIname{ROInr});
ROINAME = char(ROINAME);
ROINAME = str2num(ROINAME);
charsubject = char(subject);
[DD] = check_group(charsubject);

% volgorde: groep / subjectnummer zonder groep / ROInaam / gemiddeldes
% generalizaties
results_gen = [DD str2num(charsubject(1,2:size(charsubject,2))) ROINAME meanresult(1) meanresult(2)];

% inladen van mat-file met alle data
load([resultDir 'all_results_generalization.mat']);
[results] = write_to_datamat([resultDir 'all_results_generalization.mat'], results_gen);
save([resultDir 'all_results_generalization.mat'], 'results');
