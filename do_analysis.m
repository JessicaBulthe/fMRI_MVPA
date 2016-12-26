%% Explanation
% This is the main script for the automated MVPA scripts.
% DYSCALCULIA STUDY

% Make it work:
% (a) Make following folders in the directory for your study:
%          ROIs (with subfolders for every subject, naming it as subject (f.e. C8)
%          scripts (includes all the scripts)
%          Statistiek (with subfolders for every subject, naming it as subject (f.e. C8)
% (b) In folder ROIs, include also the ROI.namen.xlsx! 

%% ADJUST: Variables to adjust when you run new subjects
% new subjects that you wish to include in the analysis (subjects you
% already analysed should NOT be included in the variable). 
subjectIDs = [{'C1' 'C2' 'C3' 'C4' 'C5' 'C6' 'C7' 'C8' 'C9' 'C10' 'C11' 'C12' 'C13' 'C14' ...
    'C15' 'C16' 'C18' 'C19' 'C20' 'C21' 'C22' 'C25' 'C26' 'C27' ...
    'D1' 'D2' 'D3' 'D4' 'D5' 'D6' 'D7' 'D8' 'D9' 'D10' 'D11' 'D12' 'D13' 'D14' ...
    'D15' 'D16' 'D18' 'D19' 'D20' 'D21' 'D22' 'D25' 'D26' 'D27'}];     

% if you only want a select couple of ROIs, fill in the numbers below.
% For example: selected_ROIs{1} = '6'; selected_ROIs{2} = '10'; 
% Otherwise:  selected_ROIs = [];
selected_ROIs = [];
% selected_ROIs{1} = '6'; selected_ROIs{2} = '7'; selected_ROIs{3} = '8'; selected_ROIs{4} = '9'; selected_ROIs{5} = '10'; 

%% ADJUST: Variables to adjust only once for a study 
% HomeDir (directory with all the folders of that study)
% Add folder and subfolders to search path
HomeDir = ['D:' filesep 'Drive' filesep 'Research' filesep 'Dyscalculie Studie' filesep 'fMRI' filesep];
addpath(genpath(HomeDir)); 

% excel file with numbers and names of the ROIs
ROINames = 'ROI_namen.xlsx';

%% Do the MVPA analysis
% the analyses are only done for the new included subjects
[resultDir] = do_mvpa(subjectIDs, selected_ROIs, HomeDir, ROINames);

%% calculate statistics on the correlation, decoding and generalization data
% do_stats(resultDir);

%% Nog ideetjes voor jullie om te proberen
% Als je alles hierboven goed door hebt, zijn er nog paar analyses die je
% zelf kan proberen te programmeren. Van bijna elk idee hieronder heb ik
% ergens een script rondslingeren die nog niet aangepast is voor deze
% studie. Dus vraag gerust maar aan mij als je iets van hieronder wilt
% proberen te doen op deze studie. 
% Alle onderstaande analyses moeten net zoals de do_stats hierboven gedaan
% worden per groep en ook vergelijken tussen groepen. 
% 
% (a.1) Afstandseffect berekenen: is de decoding lager voor nummers dicht bij
% elkaar dan voor numbers ver van elkaar? Hierbij kan je een
% regressie-analyse doen om te testen of er een stijgende decoding is
% naarmate de afstand groter wordt. 
% (a.2) Afstandseffect voor correlaties kan je ook doen. 

% (b) Multi Dimensional Scaling: hoe ziet de stimulusruimte eruit? 

% (c.1) Nummers als objecten: test of de correlatie tussen symbolen en twee
% dots groter is als de correlatie tussen symbolen en vier dots, en die dan
% op zijn toer groter als de correatie tussen symbolen en zes dots.
% Hiervoor moet je een regressie-analyse doen op de verschillende
% correlaties tussen symbolen en een bepaalde dot conditie. 
% (c.2) Je kan dit ook testen door een "confusie" analyse te doen. Dit
% betekent dat je een bepaalde generalizatie gaat doen (van bv. twee dots
% versus vier dots, naar symbool twee en symbool vier) en dan gaat kijken
% of symbool vier als vier dots of als twee dots geclassificeerd wordt. De
% trainingsstimuli zijn steeds dots (waarvan telkens twee dots één
% conditie) en de teststimuli zijn steeds symbolen (waarvan telkens symbool
% twee één conditie).   