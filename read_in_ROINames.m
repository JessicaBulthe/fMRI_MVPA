function read_in_ROINames(ROIName_File)

[~, ~, raw0_0] = xlsread(ROIName_File,'Blad1','A2:B20');
[~, ~, raw1_0] = xlsread(ROIName_File,'Blad1','A23:B27');
raw = [raw0_0;raw1_0;];
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
cellVectors = raw(:,1);
raw = raw(:,2);

%% Create output variable
data = reshape([raw{:}],size(raw));

%% Allocate imported array to column variable names
ROIsmetMask = cellVectors(:,1);
Naamvooropteslaan = data(:,1);
for i = 1:size(Naamvooropteslaan,1)
    ROINames(i,:) = {Naamvooropteslaan(i) ROIsmetMask{i}};
end

ROINames = sortrows(ROINames, 1);

save('ROINames.mat', 'ROINames');
