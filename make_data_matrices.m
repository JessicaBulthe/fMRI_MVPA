function make_data_matrices(resultDir)

results = zeros(1,7);
save([resultDir 'all_results_correlation.mat'], 'results');
clear results;

results = zeros(1,6);
save([resultDir 'all_results_decoding.mat'], 'results');
clear results;

results = zeros(1,5);
save([resultDir 'all_results_generalization.mat'], 'results');
clear results;
