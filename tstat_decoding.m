function [output] = tstat_decoding(rois, aantal_rois, results, group) 

for i = 1:aantal_rois
    roi = rois(i);
    rows = find((results(:,3) == roi) & (results(:,1) == group));
    ROI_matrix = results(rows,:);     
    for j = 4:6
        [h,p,ci,stats] = ttest(ROI_matrix(:,j), 0.5, 'Alpha', 0.05, 'Tail', 'both');
        tstat = [roi mean(ROI_matrix(:,j)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                output.symbols(i,:) = tstat;
            case 5,
                output.dots(i,:) = tstat;
            case 6,
                output.symdots(i,:) = tstat;
        end  
    end
end