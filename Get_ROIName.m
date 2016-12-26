function [ROInaam] = Get_ROIName(rootDir, roi)

load([rootDir 'ROINames.mat']);

% zoek waar in de matrix de ROI staat
index = zeros(1,size(ROINames,1));
for k = 1:size(ROINames,1)
    index(1,k) = (ROINames{k,1} == roi);
end
row = find(index == 1);

ROInaam = ROINames(row,2);
ROInaam = ROInaam{1};
