function do_stats(resultDir)

%% Stats for decoding results
% (1) test whether decoding results are sign. larger than 0.50
% for both groups seperatly 
load([resultDir 'all_results_decoding.mat']);
rois = unique(results(:,3));
aantal_rois = size(rois,1);

[statresults.decoding.controls] = tstat_decoding(rois, aantal_rois, results, 0); % for controls
[statresults.decoding.dyscalculia] = tstat_decoding(rois, aantal_rois, results, 1); % for dyscalculia

% (2) Test whether decoding results differ for dyscalculia and controls. 
clear ROI_matrix
for i = 1:aantal_rois
    roi = rois(i);
    for group = 0:1
        rows = find((results(:,3) == roi) & (results(:,1) == group));
        ROI_matrix{group+1}(:,:) = results(rows,:);
    end
    for j = 4:6
        [h,p,ci,stats] = ttest2(ROI_matrix{1}(:,j),ROI_matrix{2}(:,j));
        tstat = [roi mean(ROI_matrix{1}(:,j))-mean(ROI_matrix{2}(:,j)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                statresults.decoding.difference.symbols(i,:) = tstat;
            case 5,
                statresults.decoding.difference.dots(i,:) = tstat;
            case 6,
                statresults.decoding.difference.symdots(i,:) = tstat;
        end  
    end
    clear ROI_matrix;
end


%% Stats for correlation results
% (1) test whether the difference between diagonal and nondiagonal for symbols,
% dots is different from each other for each group seperatly 
load([resultDir 'all_results_correlation.mat']);
rois = unique(results(:,3));
aantal_rois = size(rois,1);

[statresults.correlation.controls] = tstat_correlation(rois, aantal_rois, results, 0); % for controls
[statresults.correlation.dyscalculia] = tstat_correlation(rois, aantal_rois, results, 1); % for dyscalculia

% (2) Test whether correlation results differ for dyscalculia and controls. 
for i = 1:aantal_rois
    clear ROI_matrix;
    roi = rois(i);
    for group = 0:1
        rows = find((results(:,3) == roi) & (results(:,1) == group));
        ROI_matrix{group+1}(:,:) = results(rows,:);
    end
    for j = 4:2:6
        [h,p,ci,stats] = ttest2((ROI_matrix{1}(:,j)-ROI_matrix{1}(:,j+1)),(ROI_matrix{2}(:,j)-ROI_matrix{2}(:,j+1)));
        tstat = [roi mean(ROI_matrix{1}(:,j)-ROI_matrix{1}(:,j+1))-mean(ROI_matrix{2}(:,j)-ROI_matrix{2}(:,j+1)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                statresults.correlation.difference.symbols(i,:) = tstat;
            case 6,
                statresults.correlation.difference.dots(i,:) = tstat;
        end  
    end
end

%% Stats for correlation results
% Difference in self-correlation and other-correlation for NUMBER
% NUMBER: symbols and dots with same numerical magnitude versus symbols and
% dots with different numerical magnitudes 

% (1) For every group seperatly 
[CD_results] = calculate_average_number_correlation(resultDir);
[statresults.correlation.controls.number] = tstat_number_correlation(CD_results, rois, aantal_rois, 0);
[statresults.correlation.dyscalculia.number] = tstat_number_correlation(CD_results, rois, aantal_rois, 1);

% (2) Test whether number correlation results differ between groups
for i = 1:aantal_rois
    clear ROI_matrix;
    roi = rois(i);
    
    for group = 0:1
        rows = find((CD_results(:,3) == roi) & (CD_results(:,1) == group));
        ROI_matrix{group+1}(:,:) = CD_results(rows,:);
    end

    [h,p,ci,stats] = ttest2((ROI_matrix{1}(:,4)-ROI_matrix{1}(:,5)),(ROI_matrix{2}(:,4)-ROI_matrix{2}(:,5)));
    statresults.correlation.difference.number(i,:) = [roi mean(ROI_matrix{1}(:,4)-ROI_matrix{1}(:,5))-mean(ROI_matrix{2}(:,4)-ROI_matrix{2}(:,5)) h p stats.tstat stats.df stats.sd];
end

%% Stats for generalization results
load([resultDir 'all_results_generalization.mat']);
rois = unique(results(:,3));
aantal_rois = size(rois,1);

% (1) For each group seperatly 
[statresults.generalization.controls] =  tstat_generalization(aantal_rois, rois, results, 0);
[statresults.generalization.dyscalculia] =  tstat_generalization(aantal_rois, rois, results, 1);

% (2) Compare two groups
for i = 1:aantal_rois
    clear ROI_matrix;
    roi = rois(i);
    
    for group = 0:1
        rows = find((results(:,3) == roi) & (results(:,1) == group));
        ROI_matrix{group+1}(:,:) = results(rows,:);
    end

    for j = 4:5
        [h,p,ci,stats] = ttest2(ROI_matrix{1}(:,j),ROI_matrix{2}(:,j));
        tstat = [roi mean(ROI_matrix{1}(:,j))-mean(ROI_matrix{2}(:,j)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                statresults.generalization.difference.dotstosymbols(i,:) = tstat;
            case 5,
                statresults.generalization.difference.symbolstodots(i,:) = tstat;
        end  
    end
end

save([resultDir 'statresults.mat'], 'statresults')