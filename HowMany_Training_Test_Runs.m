function [nrRuns_training, nrRuns_test] = HowMany_Training_Test_Runs(VAR, proportion_training_runs)

nrRuns_training = ceil(VAR.nRuns*proportion_training_runs);   % berekening aantal trainingruns
nrRuns_test = VAR.nRuns - nrRuns_training; % overige runs worden test runs
