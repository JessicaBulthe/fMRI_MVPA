function [CD_results] = calculate_average_number_correlation(resultDir)

% which subfolders are present? So, which subjects have been analysed
[Subjects] = Get_Subfolders(resultDir);

% get all the files that have to be read in 
filenames = [];
for i = 1:size(Subjects,2)
    files = dir([resultDir char(Subjects(i)) filesep 'Corr*']); 
    for j = 1:size(files,1)
        filenames{size(filenames,2)+1} = [resultDir char(Subjects(i)) filesep files(j).name];
    end
end

CD_results = [];

% get the average numbers diagonal and nondiagonal for every subject and
% roi
for file = 1:size(filenames,2)
    load(filenames{file});
    CDdiag = mean([symMatrixresult(1,5) symMatrixresult(2,6) symMatrixresult(3,7) symMatrixresult(4,8)]);
    CDnondiag = mean([symMatrixresult(2,5) symMatrixresult(3,5) symMatrixresult(4,5) symMatrixresult(1,6) symMatrixresult(3,6) symMatrixresult(4,6) symMatrixresult(1,7) symMatrixresult(2,7) symMatrixresult(4,7) symMatrixresult(1,8) symMatrixresult(2,8) symMatrixresult(3,8)]);
    charsubject = char(subject);
    [DD] = check_group(charsubject);
    CD_results = [CD_results; DD str2num(charsubject(1,2:size(charsubject,2))) ROINAME CDdiag CDnondiag];
end 

