%% This function is study specific. It calculates across the correlation matrix the averages you want to know. 

function [means] = calculate_correlation_measures(symMatrixresult)

means.CD = mean([symMatrixresult(1, 1) symMatrixresult(2, 2) symMatrixresult(3, 3) symMatrixresult(4, 4)]);
means.CND = mean([symMatrixresult(2, 1) symMatrixresult(3, 1) symMatrixresult(4, 1) symMatrixresult(1, 2) symMatrixresult(3, 2) symMatrixresult(4, 2) symMatrixresult(1, 3) symMatrixresult(2, 3) symMatrixresult(4, 3) symMatrixresult(1, 4) symMatrixresult(2, 4) symMatrixresult(3, 4)]);
means.DD = mean([symMatrixresult(5, 5) symMatrixresult(6, 6) symMatrixresult(7, 7) symMatrixresult(8, 8)]);
means.DND = mean([symMatrixresult(6, 5) symMatrixresult(7, 5) symMatrixresult(8, 5) symMatrixresult(5, 6) symMatrixresult(7, 6) symMatrixresult(8, 6) symMatrixresult(5, 7) symMatrixresult(6, 7) symMatrixresult(8, 7) symMatrixresult(5, 8) symMatrixresult(6, 8) symMatrixresult(7, 8)]);
means.corr = [means.CD means.CND; means.DD means.DND];