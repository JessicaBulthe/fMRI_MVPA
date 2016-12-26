%
% make_roi.m
%
% Use this program to create an ROI in the SPM-environment. The program
%   has a functionality that is similar to the froi-function make_roi of 
%   N. Knouf (Kanwisher lab, MIT)
%
% Usage:
%
% Use SPM to call up xSPM structure for a specific contrast  
%       (e.g., objects-scrambled)
% After that you can type make_roi to show these voxels on coronals
% You have to change anatImage for your subject (always wmr*.img)
%    and maybe the rangeOfSlices too, depending on what you want to see
%       (now it only shows the posterior part of the brain)
%
% All significant voxels are selected (shown in red) by default
% This is what you can do:
% - press 'c' on the keyboard: de-select all voxels
%       (de-selected significant voxels are shown in yellow)
% - click the left mouse button to select individual voxels/regions 
% - press 'b' on the keyboard: 
%       change the size of the region selected with a left mouse click
% - press 'i' on the keyboard: 
%       compute the intersection between the selected region and
%       the original set of significant voxels
% - press 's' on the keyboard: save matlab-file (do NOT type extension)
% - press 'e' on the keyboard to end the program
%
% The saved structure makeROI contains all the selected voxels in the field
%   makeROI.selected, with the anatomical coordinates in makeROI.selected.anatXYZ.
%   You can also find all originally significant voxels in other fields.
%
% Written by Hans Op de Beeck
% All questions and bug reports should be addressed to Hans Op de Beeck
%       (hans.opdebeeck@psy.kuleuven.be)
%

clear anatIme
clear makeROI

subject = 'D27';
AnatomieDir = 'E:\Research\Dyscalculie Studie\fMRI\Anatomical Scans\';
anatomie_file = dir([AnatomieDir 'wr' char(subject) '_ANATOMIE_*.nii']);
ROIDir = ['E:\Research\Dyscalculie Studie\fMRI\ROIs\Anatomisch 0.01\' char(subject)];

% load in SPM.mat file for that subject
treshold = 0.001;
matlabbatch{1}.spm.stats.results.spmmat = cellstr(['E:\Research\Dyscalculie Studie\fMRI\Statistiek\' char(subject) '\Loc\SPM.mat']);
matlabbatch{1}.spm.stats.results.conspec(1).titlestr = subject;
matlabbatch{1}.spm.stats.results.conspec(1).contrasts = 1;
matlabbatch{1}.spm.stats.results.conspec(1).threshdesc = 'none';
matlabbatch{1}.spm.stats.results.conspec(1).thresh = treshold;
matlabbatch{1}.spm.stats.results.conspec(1).extent = 0;
matlabbatch{1}.spm.stats.results.units = 1; % Data type: Volumetric, 1; Scalp-Time, 2; ...
matlabbatch{1}.spm.stats.results.print = false; % true or false

%% Run job file
spm_jobman('run', matlabbatch);

% The only things that need to be adapted
anatImage = spm_vol([AnatomieDir anatomie_file.name]);
rangeOfSlices = [5 95];

% Leave the rest to peace 
volumeSize= [size(anatImage.private.dat,1) size(anatImage.private.dat,2) size(anatImage.private.dat,3)]
telActive = size(xSPM.XYZ,2);

% process slice numbers and positions
numSlices = rangeOfSlices(2) - rangeOfSlices(1) + 1;
perDim = sqrt(numSlices);
if round(perDim) == perDim
    XimNum = round(perDim);
    YimNum = round(perDim);
else
    XimNum = round(perDim);
    YimNum = round(perDim) + 1;
end;

telSlice = 0;
for slY=1:YimNum,
    for slX=1:XimNum,
        telSlice = telSlice + 1;
        if telSlice <= numSlices
            sliceXYimPos(telSlice,1:2) = [slX slY];
        end;
    end;
end;

for sl=1:numSlices,
    startXpos = (sliceXYimPos(sl,1)-1)*volumeSize(1);
    startYpos = (sliceXYimPos(sl,2)-1)*volumeSize(3);
    hulp = flipdim(flipdim(squeeze(anatImage.private.dat(:,rangeOfSlices(1)+sl-1,:))',1),2);
    anatIm(startYpos+1:startYpos+volumeSize(3),startXpos+1:startXpos+volumeSize(1)) = hulp;
end;
for y=1:size(anatIm,1),
    for x=1:size(anatIm,2),
        if isnan(anatIm(y,x))
            anatIm(y,x) = 0;
        end;
    end;
end;
colorRange = [0 max(max(anatIm))]
figure(6)
%A=imshow(anatIm,[0 1700]);
A=imshow(anatIm,colorRange);
hold on;

makeROI.allPoints = xSPM.XYZ;
makeROI.nAllPoints = size(makeROI.allPoints,2);
telVox = 0;
for p=1:makeROI.nAllPoints,
    if xSPM.XYZ(2,p)>=rangeOfSlices(1) &  xSPM.XYZ(2,p)<=rangeOfSlices(2);
        telVox = telVox + 1;
        makeROI.allInFOV(1:3,telVox) = xSPM.XYZ(:,p);
    end;
end;
makeROI.nInFov = telVox

for p=1:makeROI.nInFov,
    sl = makeROI.allInFOV(2,p)-rangeOfSlices(1)+1;
    startXpos = (sliceXYimPos(sl,1)-1)*volumeSize(1);
    startYpos = (sliceXYimPos(sl,2)-1)*volumeSize(3);
    makeROI.figCoord(:,p) = [startYpos+(volumeSize(3)-makeROI.allInFOV(3,p)+1)  startXpos+(volumeSize(1)-makeROI.allInFOV(1,p)+1)];
end;

P = plot(makeROI.figCoord(2,:),makeROI.figCoord(1,:),'r.');
set(P,'MarkerSize',1);
makeROI.selected.figCoord = makeROI.figCoord;
makeROI.selected.number = size(makeROI.selected.figCoord,2);

boxSize=3;
%button = 0; while button == 0 [X,Y,button] = ginput(1); end;
while 1
   %title(strcat(filename, '    Setting Point No.',num2str(ith_point+1)));
   %xlabel('Click left mouse button to set 1st point; click right button to quit');
   [x,y, butn]=ginput(1);
   if butn == 101   %'e' == 'end'
      fprintf('Make_ROI has ended\n');
      fprintf('Bye ... \n');
      close
      break;
   end
   if butn == 99   %'c' == 'clear'
       A=imshow(anatIm,colorRange);
       hold on;
       P = plot(makeROI.figCoord(2,:),makeROI.figCoord(1,:),'y.');
       set(P,'MarkerSize',1);
       makeROI.selected.figCoord = [];
       makeROI.selected.number = 0;
       fprintf('All voxels have been cleared\n');
   end
   if butn == 98   %'b' == 'box'
       if boxSize == 9
           boxSize = 1;
       else
           boxSize = boxSize + 2;
       end;
       fprintf('New box size: %d x %d\n',boxSize,boxSize);
   end
   if butn == 1   %'left mouse button'
       x=round(x);  y=round(y);
       for i=1:boxSize,
           for j=1:boxSize,
               makeROI.selected.number = makeROI.selected.number + 1;
               makeROI.selected.figCoord(:,makeROI.selected.number) = [y+(i-1)-((boxSize-1)/2) x+(j-1)-((boxSize-1)/2)];
           end;
       end;
       P = plot(makeROI.selected.figCoord(2,:),makeROI.selected.figCoord(1,:),'r.');
       set(P,'MarkerSize',1);
   end;
   if butn == 105   %'i' == 'compute intersect'
       fprintf('Computing intersection\n');
       hulpSelected = makeROI.selected;
       makeROI.selected.figCoord = [];
       makeROI.selected.number = 0;      
       for sel=1:hulpSelected.number,
           for v=1:makeROI.nInFov,
               if hulpSelected.figCoord(1,sel)==makeROI.figCoord(1,v) &  hulpSelected.figCoord(2,sel)==makeROI.figCoord(2,v)
                   makeROI.selected.number = makeROI.selected.number + 1;
                   makeROI.selected.figCoord(1:2,makeROI.selected.number) = hulpSelected.figCoord(:,sel);
               end;
           end;
       end;
       A=imshow(anatIm,colorRange);
       hold on;
       P = plot(makeROI.figCoord(2,:),makeROI.figCoord(1,:),'y.');
       set(P,'MarkerSize',1);
       P = plot(makeROI.selected.figCoord(2,:),makeROI.selected.figCoord(1,:),'r.');
       set(P,'MarkerSize',1);
   end;
   if butn == 115   %'s' == 'save file'
       disp('Saving File...');
        % first clean up doubles
        double(1:makeROI.selected.number)=0;
        for i=1:makeROI.selected.number-1,
            for j=i+1:makeROI.selected.number,
                if makeROI.selected.figCoord(1,i)==makeROI.selected.figCoord(1,j) & makeROI.selected.figCoord(2,i)==makeROI.selected.figCoord(2,j)
                    double(j) = 1;
                end;
            end;
        end;
        hulpSelected = makeROI.selected;
        makeROI.selected.figCoord = [];
        makeROI.selected.number = 0;   
        for sel=1:hulpSelected.number,
           if double(sel) == 0
               makeROI.selected.number = makeROI.selected.number + 1;
               makeROI.selected.figCoord(1:2,makeROI.selected.number) = hulpSelected.figCoord(:,sel);
           end;
        end;
        % than add anatomical coordinates to the figCoord
        disp('Still saving...'); 
        makeROI.selected.anatXYZ = [];
        for sel=1:makeROI.selected.number,
           for v=1:makeROI.nInFov,
                if makeROI.selected.figCoord(1,sel)==makeROI.figCoord(1,v) &  makeROI.selected.figCoord(2,sel)==makeROI.figCoord(2,v)
                   makeROI.selected.anatXYZ(:,sel) = makeROI.allInFOV(1:3,v);
                end;
           end;
        end;
        [fileName, pathName] = uiputfile('*mat', 'Give the name of the ROI (without extension)');
        output=[ROIDir '\' fileName '.mat'];
        save(output, 'makeROI');
        %output = sprintf('save %s%s.mat makeROI', pathName, fileName);
        %eval(output);
        fprintf('ROI saved\n');
 

   end;   

end   


