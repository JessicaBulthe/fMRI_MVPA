%% do fdr

% ResultDir
resultDir = 'E:\Research\Dyscalculie Studie\fMRI\results\';

% inladen van statfile
load([resultDir 'statresults.mat']);

%  Lobes - Occipital Lobe - Parietal - Frontal - Temporal - subPar
rows = {[2 3 4 5]; [20 23]; [6 11 14]; [19 21]; [18]; [7 8 9 10]};

% Fdr-corrected
fdr_corrected = statresults;
fdr_corrected.decoding.controls.symbols(:,8) = NaN;
fdr_corrected.decoding.controls.dots(:,8) = NaN;
fdr_corrected.decoding.dyscalculia.symbols(:,8) = NaN;
fdr_corrected.decoding.dyscalculia.dots(:,8) = NaN;
fdr_corrected.decoding.difference.symbols(:,8) = NaN;
fdr_corrected.decoding.difference.dots(:,8) = NaN;

for i = 1:size(rows,1)
    [~, ~, fdr_corrected.decoding.controls.dots(rows{i},8)] = fdr_bh(statresults.decoding.controls.dots(rows{i},4));
    [~, ~, fdr_corrected.decoding.dyscalculia.dots(rows{i},8)] = fdr_bh(statresults.decoding.dyscalculia.dots(rows{i},4));
    [~, ~, fdr_corrected.decoding.difference.dots(rows{i},8)] = fdr_bh(statresults.decoding.difference.dots(rows{i},4));

    [~, ~, fdr_corrected.decoding.controls.symbols(rows{i},8)] = fdr_bh(statresults.decoding.controls.symbols(rows{i},4));
    [~, ~, fdr_corrected.decoding.dyscalculia.symbols(rows{i},8)] = fdr_bh(statresults.decoding.dyscalculia.symbols(rows{i},4));
    [~, ~, fdr_corrected.decoding.difference.symbols(rows{i},8)] = fdr_bh(statresults.decoding.difference.symbols(rows{i},4));
end

clear statresults;

statresults = fdr_corrected; 

save(['statresults_fdr_corrected_finalROIs.mat'], 'statresults')
    