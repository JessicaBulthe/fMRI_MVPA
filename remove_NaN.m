%% [DATA] = load_in_tstats_ROI(VAR, SPM)
% This function removese all NaN from the data. Recalculates the number of
% voxels kept after removing the NaN valued voxels. 

function [DATA, ROI] = remove_NaN(ROI, VAR, DATA)

telKept = 0;
for v=1:ROI.nVoxels,
    remove = 0;
    for r=1:VAR.nRuns,
        if abs(mean(DATA.PSC_all{r}(v,:))) < 25
        else    % >25 of NaN
            remove = 1;
        end;
    end;
    if remove == 0
        telKept = telKept + 1;
        for r=1:VAR.nRuns,
            DATA.PSC_select{r}(telKept,1:VAR.nCond) = DATA.PSC_all{r}(v,:);
        end
    end
end

ROI.VoxelsKept = telKept; 