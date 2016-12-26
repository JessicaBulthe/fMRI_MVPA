
%% Explanation
% This script serves for correlational or decoding MVPA with BETA VALUES or TSTATS. 
% Below you can adjust a couple of variables. The rest of the script you do
% not have to adjust anything. 

%% VARIABLES YOU HAVE TO ADJUST
% where is your SPM.mat file
nameSPM = {'C:\Users\u0069828\Google Drive\Research\Dyscalculie Studie\fMRI\Statistiek\C5\Exp\SPM.mat'};

% where is your ROI-file? 
load('C:\Users\u0069828\Google Drive\Research\Dyscalculie Studie\fMRI\ROIs\Anatomisch 0.01\C5\1.mat');

% make the link to where the lib-svm map
% addpath('C:\Users\Neusje\SkyDrive\SkyDrive Doc\Dyscalculie studie\Analyses\Scandata\0 - Nodige toolboxen\libsvm')

% where are the beta-files of this subject? 
betaDir = 'C:\Users\u0069828\Google Drive\Research\Dyscalculie Studie\fMRI\Statistiek\C5\Exp\';

% do you want to use t-statistics or beta-values ('betas' or 'tstat')
beta_or_tstat = 'tstat';                           % beta_or_tstat = 'tstat'

% do you want to do correlational or decoding MVPA ('correlational' or 'decoding')
which_analysis = 'decoding';                   % which_analysis = 'decoding' 

% did you model the fixation condition? (0 is not, 1 if you did)
fix = 1;

%% Preparation of the analyses 
% 1) Calculate in all necessary parameters
    %load in the SPM.mat file 
    SPM_all = load(nameSPM{1});
    
    % proportion training and test runs for decoding analysis
    prop_trainingruns = 0.7;

    totalRuns = str2num(SPM_all.SPM.xsDes.Number_of_sessions); % how many runs do you have
    nCond= str2num(SPM_all.SPM.xsDes.Trials_per_session(1,1:2))-fix;      % how many conditions do you have
    nRep = 100;  % how many replications do you want to do?

    % calculate which beta's for each run and condition
    condToTake = [];
    for run = 1:totalRuns
        switch (beta_or_tstat)
            case 'betas'
                condToTake = [condToTake SPM_all.SPM.Sess(run).col(1,1:nCond)];
            case 'tstat'
                condToTake = [condToTake run:totalRuns:size(SPM_all.SPM.xCon,2)];
        end
    end

% 2) Load in ROI-coordinates 
    ROI.XYZ = makeROI.selected.anatXYZ;
    nrVoxels = makeROI.selected.number;

% 3) load in the beta-values
    cd(betaDir)
    % Preallocation of a            
    for i = 1:size(condToTake,2)
        switch (beta_or_tstat)
            case 'betas'
                a{i} = zeros(SPM_all.SPM.Vbeta(1).dim(1), SPM_all.SPM.Vbeta(1).dim(2), SPM_all.SPM.Vbeta(1).dim(3));
            case 'tstat'
                a{i} = zeros(SPM_all.SPM.xCon(1).Vspm.dim(1), SPM_all.SPM.xCon(1).Vspm.dim(2), SPM_all.SPM.xCon(1).Vspm.dim(3)); 
        end
    end

    % Read in all the volumes for betas
    for condition = condToTake(1):size(condToTake,2)
        switch (beta_or_tstat)
            case 'betas'
                imgfile = load_untouch_nii([SPM_all.SPM.Vbeta(condToTake(condition)).fname]);
            case 'tstat'
                imgfile = load_untouch_nii([SPM_all.SPM.xCon(condToTake(condition)).Vspm.fname]);
        end
%         matrix = flipdim(imgfile.img, 1);
        a{condition} = imgfile.img(:,:,:);
    end

    % make big matrix
    alltogether = zeros(nrVoxels, size(condToTake,2));
    for voxel=1:nrVoxels
        telcond=0;
        for condition=1:size(condToTake,2); 
             condSig = a{condition}(ROI.XYZ(1,voxel),ROI.XYZ(2,voxel),ROI.XYZ(3,voxel));
             telcond=telcond+1;
             alltogether(voxel,telcond) = condSig;
        end
    end

% 4) Rearrange data: for each run, seperate cell in the ROI.PSC_all    
    for i=1:totalRuns,
        ROI.PSC_all{i} = alltogether(:,(i-1)*nCond+1:(i-1)*nCond+nCond); 
    end
    
% 5) Standardize with subtraction of mean across all conditons for each voxel
    if strcmp(which_analysis, 'correlational') == 1
        for i=1:totalRuns,
            for v=1:nrVoxels,
                ROI.PSC_all{i}(v,:) = ROI.PSC_all{i}(v,:) - mean(ROI.PSC_all{i}(v,:));
            end
        end
    end
    
% 6)  Take out the voxels with NaN (should not be there with proper masking);
    telKept = 0;
    for v=1:nrVoxels,
        remove = 0;
        for r=1:totalRuns,
            if abs(mean(ROI.PSC_all{r}(v,:))) < 25
            else %mean higher than 25; also happens if mean is NaN
                remove = 1;
            end
        end
        if remove == 0
            telKept = telKept + 1;
            for r=1:totalRuns,
                ROI.PSC_select{r}(telKept,1:nCond) = ROI.PSC_all{r}(v,:);
            end
        end
    end
    
% 7) Standardization for decoding
  if strcmp(which_analysis, 'decoding') == 1
        for i=1:totalRuns
            for ve=1:nCond
                ROI.PSC_select{i}(:,ve) = (ROI.PSC_select{i}(:,ve) - mean(ROI.PSC_select{i}(:,ve))) ./ std(ROI.PSC_select{i}(:,ve));
            end
        end
  end

% 8) How many voxels are left? How many training and testing-runs?  
    nrVoxels = telKept;
    
% 9) How many training and test runs?    
    switch (which_analysis)
        case 'correlational'
            if mod(totalRuns, 2) == 0
                nrRuns_training = totalRuns/2;
                nrRuns_test = totalRuns/2; 
            elseif mod(totalRuns, 2) == 1
                nrRuns_training = (totalRuns+1)/2;
                nrRuns_test = (totalRuns-1)/2; 
            end
        case 'decoding'
            nrRuns_training = ceil(totalRuns*prop_trainingruns);  
            nrRuns_test = totalRuns - nrRuns_training;
    end
    
%% Do MVPA 
telComp = 0;
for rep=1:nRep
    clear trainingSamples trainingLabels indTestSamples indTestLabels testSamples testLabels;
    telDiff=0;
    for c1=1:nCond-1
        for c2=c1+1:nCond,
            telDiff = telDiff + 1;
            rtest = rep;
            
            telComp = telComp + 1;
            if nrRuns_test==1
                runNow = 0;
                for r=1:totalRuns,
                    if r~=rtest
                        runNow = runNow+1;
                        trainingSamples(1:nrVoxels,runNow) = ROI.PSC_select{r}(:,c1);
                        trainingLabels(runNow) = 1;
                        trainingSamples(1:nrVoxels,nrRuns_training+runNow) = ROI.PSC_select{r}(:,c2);
                        trainingLabels(nrRuns_training+runNow) = 2;
                    else
                        testSamples(1:nrVoxels,1) = ROI.PSC_select{r}(:,c1);
                        testLabels(1) = 1;
                        testSamples(1:nrVoxels,nrRuns_test+1) = ROI.PSC_select{r}(:,c2);
                        testLabels(nrRuns_test+1) = 2;
                    end;
                end;
            else
                runOrder = randperm(totalRuns); %first runs in this list will be training runs
                for r=1:nrRuns_training,
                    trainingSamples(1:nrVoxels,r) = ROI.PSC_select{runOrder(r)}(:,c1);
                    trainingLabels(r) = 1;
                    trainingSamples(1:nrVoxels,nrRuns_training+r) = ROI.PSC_select{runOrder(r)}(:,c2);
                    trainingLabels(nrRuns_training+r) = 2;
                end;
                
                for r=1:nrRuns_test,
                    indTestSamples(1:nrVoxels,r) = ROI.PSC_select{runOrder(nrRuns_training+r)}(:,c1);
                    indTestLabels(r) = 1;
                    indTestSamples(1:nrVoxels,nrRuns_test+r) = ROI.PSC_select{runOrder(nrRuns_training+r)}(:,c2);
                    indTestLabels(nrRuns_test+r) = 2;
                end;
                testSamples(1:nrVoxels,1) = mean(indTestSamples(1:nrVoxels,1:nrRuns_test),2);
                testLabels(1) = 1;
                testSamples(1:nrVoxels,2) = mean(indTestSamples(1:nrVoxels,nrRuns_test+1:nrRuns_test+nrRuns_test),2);
                testLabels(2) = 2;
                
                % make test-data from one run also as a control for the smoothing-analysis
                testRun = randperm(nrRuns_test);
                testSamplesOneRun(1:nrVoxels,1) = indTestSamples(1:nrVoxels,testRun(1));
                testLabelsOneRun(1) = 1;
                testSamplesOneRun(1:nrVoxels,2) = indTestSamples(1:nrVoxels,nrRuns_test+testRun(1));
                testLabelsOneRun(2) = 2;
                
            end;
            
            switch (which_analysis)
                case 'correlational'
                    % now pairwise comparisons with correlations
                    co = corrcoef(mean(trainingSamples(:,1:nrRuns_training),2)-mean(trainingSamples(:,nrRuns_training+1:2*nrRuns_training),2),testSamples(:,1)-testSamples(:,2));
                    corrAll(c1,c2,rep) = co(2,1);

                    % correlations between selectivity patterns (asymmetrical matrix)
                    co = corrcoef(mean(trainingSamples(:,1:nrRuns_training),2),testSamples(:,1));
                    symMatrix(c1,c1,rep) = co(2,1);
                    co = corrcoef(mean(trainingSamples(:,nrRuns_training+1:2*nrRuns_training),2),testSamples(:,2));
                    symMatrix(c2,c2,rep) = co(2,1);
                    co = corrcoef(mean(trainingSamples(:,1:nrRuns_training),2),testSamples(:,2));
                    symMatrix(c1,c2,rep) = co(2,1);
                    co = corrcoef(mean(trainingSamples(:,nrRuns_training+1:2*nrRuns_training),2),testSamples(:,1));
                    symMatrix(c2,c1,rep) = co(2,1);
                case 'decoding'
                    % train the model
                    model = svmtrain2(trainingLabels', trainingSamples', '-s 1 -t 0 -d 1 -g 1 -r 1 -c 1 -n 0.5 -p 0.1 -m 45 -e 0.001 -h 1 -q');
                    % test the model
                    [x,y,z] = svmpredict2(testLabels', testSamples', model);
                    classRateAll(c1,c2,rep) =  y(1)/100;
            end
        end
    end
end

% Show results of MVPA 
switch (which_analysis)
    case 'correlational'
        results_mvpa = mean(symMatrix,3)
    case 'decoding'
        results_mpva = mean(classRateAll,3)
end
