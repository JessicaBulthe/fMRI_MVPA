function [number] = tstat_number_correlation(CD_results, rois, aantal_rois, group)

for i = 1:aantal_rois
    roi = rois(i);
    rows = find(CD_results(:,3) == roi & CD_results(:,1) == group);
    ROI_matrix = CD_results(rows,:);     
    [h,p,ci,stats] = ttest(ROI_matrix(:,4),ROI_matrix(:,5));
    number(i,:) = [roi mean(ROI_matrix(:,4)-ROI_matrix(:,5)) h p stats.tstat stats.df stats.sd];
end
