function [results] = write_to_datamat(file, summary_matrix)

load(file);

% check of de analyse al gebeurd is voor dat subject en ROI
is_equal = ismember(results(:,1:3), summary_matrix(1,1:3), 'rows');

if mean(is_equal) == 0
    if results(1,2) == 0
        results(1,:) = summary_matrix;
    else
        results = insertrows(results,summary_matrix,size(results,1)+1);
    end
else
    row = find(is_equal(:,:) == 1);
    results(row(1,1), :) = summary_matrix;
end


