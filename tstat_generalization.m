function [output] =  tstat_generalization(aantal_rois, rois, results, group)

for i = 1:aantal_rois
    roi = rois(i);
    rows = find(results(:,3) == roi & results(:,1) == group);
    ROI_matrix = results(rows,:);     
    for j = 4:5
        [h,p,ci,stats] = ttest(ROI_matrix(:,j),0.5,0.05,'both');
        tstat = [i mean(ROI_matrix(:,j)) h p stats.tstat stats.df stats.sd];
        switch j
            case 4,
                output.dotstosymbols(i,:) = tstat;
            case 5,
                output.symbolstodots(i,:) = tstat;
        end  
    end
end