function [output] = tstat_correlation(rois, aantal_rois, results, group) 

for i = 1:aantal_rois
    roi = rois(i);
    rows = find((results(:,3) == roi) & (results(:,1) == group));
    ROI_matrix = results(rows,:);     
    for j = 4:2:6
        [h,p,ci,stats] = ttest(ROI_matrix(:,j),ROI_matrix(:,j+1));
        tstat = [roi mean(ROI_matrix(:,j)-ROI_matrix(:,j+1)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                output.symbols(i,:) = tstat;
            case 6,
                output.dots(i,:) = tstat;
        end  
    end
end

