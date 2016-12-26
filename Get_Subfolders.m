%% Function Get_Subfolders
% Explanation: checks in directory the present files and folders. Gets out
% only the names of those which are a folder in that directory. 
%
% INPUT:
%       directory: directory of the folder
%
% OUTPUT:
%       SubFolders: the names of the subfolders

%% Code
function [SubFolders] = Get_Subfolders(directory)

% which files and folders in the directory
content_folder = dir(directory); 

% which are folders
isub = [content_folder(:).isdir];

% remove non-subfolders
SubFolders = {content_folder(isub).name};

% remove '.' and '..'
SubFolders(ismember(SubFolders,{'.','..'})) = [];
