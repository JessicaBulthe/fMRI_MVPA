%% [DATA] = load_in_tstats_ROI(VAR, SPM)
% This function loads in the tstatistics for every voxel in the ROI.

function [DATA] = load_in_tstats_ROI(VAR, SPM, ROI, SubjectSpecDir)

% Preallocation of a            
 for i = 1:size(VAR.condToTake,2)
      a{i} = zeros(SPM.xCon(1).Vspm.dim(1), SPM.xCon(1).Vspm.dim(2), SPM.xCon(1).Vspm.dim(3));
end

% Read in all the volumes for betas
for condition = VAR.condToTake(1):size(VAR.condToTake,2)
    imgfile = load_nii([SubjectSpecDir SPM.xCon(VAR.condToTake(condition)).Vspm.fname]);
    matrix = flipdim(imgfile.img, 1);
    a{condition} = matrix(:,:,:);
end

% make big matrix
alltogether = zeros(ROI.nVoxels,size(VAR.condToTake,2));
for voxel=1:ROI.nVoxels
    telcond=0;
    for condition=1:size(VAR.condToTake,2); 
        if ( mean([ROI.XYZ(1,voxel) ROI.XYZ(2,voxel) ROI.XYZ(3,voxel)]) ~= 0)
             condSig = a{condition}(ROI.XYZ(1,voxel),ROI.XYZ(2,voxel),ROI.XYZ(3,voxel));
             telcond=telcond+1;
             alltogether(voxel,telcond) = condSig;
        else
            telcond=telcond+1;
            alltogether(voxel, telcond) = NaN;
        end
    end
end

% re-order the data
for i=1:VAR.nRuns,
    DATA.PSC_all{i} = alltogether(:,(i-1)*VAR.nCond+1:(i-1)*VAR.nCond+VAR.nCond);
end