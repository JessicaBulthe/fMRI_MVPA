%% Function make_folder
% Explanation: checks if folder already exists in directory, if it does not
% exist, it will create the folder and returns iin both cases the pathway
% of the folder. 
%
% INPUT:
%       directory: directory of the folder
%       name: string variable of the name of the folder
%
% OUTPUT:
%       path: the pathway of the folder

%% Code
function [path] = make_folder(directory, name)

% check if folder already exists
folder_exist = exist([directory name], 'dir');

% if it doesn't exist, make the folder
if folder_exist == 0
    mkdir([directory name]);
end

% return pathway
path = [directory name filesep]; 