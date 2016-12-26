
function [DATA] = normalization_decoding(VAR, DATA)

% standardize all vectors
for run=1:VAR.nRuns
    for voxel=1:VAR.nCond
        DATA.PSC_select{run}(:,voxel) = (DATA.PSC_select{run}(:,voxel) - mean(DATA.PSC_select{run}(:,voxel))) ./ std(DATA.PSC_select{run}(:,voxel));
    end
end