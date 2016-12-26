function [Aantal_ROIs, ROIname] = load_ROI_information(ROIdir)

% tellen van ROIs en informatie opslaan
lijstROIs = dir([ROIdir '*.mat']);        
Aantal_ROIs = numel(lijstROIs);

% maken van nieuwe structuur voor ROINAME aan te maken die dan de namen
% bevat van de ROIs
for k = 1:Aantal_ROIs
    volledige_naam = lijstROIs(k).name;
    [~, name, ~] = fileparts(volledige_naam);
    ROIname{k} = name;
end
