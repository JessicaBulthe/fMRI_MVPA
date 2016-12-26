%% [DATA] = normalization_correlation(VAR, ROI, DATA)
% This function normalizes the data for correlational MVPA. The average
% across conditions for every voxel is subtracted for every voxel. 

function [DATA] = normalization_correlation(VAR, ROI, DATA)

for i=1:VAR.nRuns,
    for v=1:ROI.nVoxels,
        DATA.PSC_all{i}(v,:) = DATA.PSC_all{i}(v,:) - mean(DATA.PSC_all{i}(v,:));
    end;
end;
