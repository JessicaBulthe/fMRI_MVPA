correlation_symb = [statresults.correlation.controls.symbols(:,2:4) statresults.correlation.dyscalculia.symbols(:,2:4) statresults.correlation.difference.symbols(:,2:4)]
correlation_dots = [statresults.correlation.controls.dots(:,2:4) statresults.correlation.dyscalculia.dots(:,2:4) statresults.correlation.difference.dots(:,2:4)]
correlation_symbdots = [statresults.correlation.controls.number(:,2:4) statresults.correlation.dyscalculia.number(:,2:4) statresults.correlation.difference.number(:,2:4)]
decoding_symbols = [statresults.decoding.controls.symbols(:,2:4) statresults.decoding.dyscalculia.symbols(:,2:4) statresults.decoding.difference.symbols(:,2:4)]
decoding_dots = [statresults.decoding.controls.dots(:,2:4) statresults.decoding.dyscalculia.dots(:,2:4) statresults.decoding.difference.dots(:,2:4)]
generalization_d2s = [statresults.generalization.controls.dotstosymbols(:,2:4) statresults.generalization.dyscalculia.dotstosymbols(:,2:4) statresults.generalization.difference.dotstosymbols(:,2:4)]
generalization_s2d = [statresults.generalization.controls.symbolstodots(:,2:4) statresults.generalization.dyscalculia.symbolstodots(:,2:4) statresults.generalization.difference.symbolstodots(:,2:4)]

% open excel
file = ['E:\Research\Dyscalculie Studie\fMRI\results\Anatomisch 0.01\statresults_fdr.xls'];
[Excel, ExcelWorkbook] = OpenExcel(file);

% write to excel
xlswrite1(file, correlation_symb, 'Cor_S', 'A1');
xlswrite1(file, correlation_dots, 'Cor_D', 'A1');
xlswrite1(file, correlation_symbdots, 'Cor_SD', 'A1');
xlswrite1(file, decoding_symbols, 'Dec_S', 'A1');
xlswrite1(file, decoding_dots, 'Dec_D', 'A1');
xlswrite1(file, generalization_d2s, 'Gen_d2s', 'A1');
xlswrite1(file, generalization_s2d, 'Gen_s2d', 'A1');

% close excel
CloseExcel(ExcelWorkbook, Excel);

