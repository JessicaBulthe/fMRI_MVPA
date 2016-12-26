
function [trainingSamples, testSamples, trainingLabels, testLabels] = make_training_test_samples(nrRuns_test, nrRuns_training, VAR, ROI, DATA, c1, c2, c3, c4)


if nrRuns_test==1 % 1 testsample
    runNow = 0;
    for r=1:VAR.nRuns,
        if r~=rep
            runNow = runNow+1;
            trainingSamples(1:ROI.VoxelsKept,runNow) = DATA.PSC_select{r}(:,c1);
            trainingLabels(runNow) = 1;
            trainingSamples(1:ROI.VoxelsKept,nrRuns_training+runNow) = DATA.PSC_select{r}(:,c2);
            trainingLabels(nrRuns_training+runNow) = 2;
        else
            testSamples(1:ROI.VoxelsKept,1) = DATA.PSC_select{r}(:,c3);
            testLabels(1) = 1;
            testSamples(1:ROI.VoxelsKept,nrRuns_test+1) = DATA.PSC_select{r}(:,c4);
            testLabels(nrRuns_test+1) = 2;
        end
    end
else % meerdere testsamples
    runOrder = randperm(VAR.nRuns); %first runs in this list will be training runs
    for r=1:nrRuns_training,
        trainingSamples(1:ROI.VoxelsKept,r) = DATA.PSC_select{runOrder(r)}(:,c1); % getraind c1 vs c2
        trainingLabels(r) = 1;
        trainingSamples(1:ROI.VoxelsKept,nrRuns_training+r) = DATA.PSC_select{runOrder(r)}(:,c2);
        trainingLabels(nrRuns_training+r) = 2;
    end
    
    for r=1:nrRuns_test, % testen op zelfde (c1 en c2) of andere condities
        indTestSamples(1:ROI.VoxelsKept,r) = DATA.PSC_select{runOrder(nrRuns_training+r)}(:,c3);
        indTestLabels(r) = 1;
        indTestSamples(1:ROI.VoxelsKept,nrRuns_test+r) = DATA.PSC_select{runOrder(nrRuns_training+r)}(:,c4);
        indTestLabels(nrRuns_test+r) = 2;
    end
    testSamples(1:ROI.VoxelsKept,1) = mean(indTestSamples(1:ROI.VoxelsKept,1:nrRuns_test),2);
    testLabels(1) = 1;
    testSamples(1:ROI.VoxelsKept,2) = mean(indTestSamples(1:ROI.VoxelsKept,nrRuns_test+1:nrRuns_test+nrRuns_test),2);
    testLabels(2) = 2;
    
    % make test-data from one run also as a control for the smoothing-analysis
    testRun = randperm(nrRuns_test);
    testSamplesOneRun(1:ROI.VoxelsKept,1) = indTestSamples(1:ROI.VoxelsKept,testRun(1));
    testLabelsOneRun(1) = 1;
    testSamplesOneRun(1:ROI.VoxelsKept,2) = indTestSamples(1:ROI.VoxelsKept,nrRuns_test+testRun(1));
    testLabelsOneRun(2) = 2;
end