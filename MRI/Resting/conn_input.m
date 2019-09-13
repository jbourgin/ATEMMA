clear all
clear BATCH;
addpath('/home/jessica/ATEMMA/MRI/Resting/')

global dataDir;
dataDir = strcat('/media/jessica/SSD_DATA/IRM_Gaze/Files_ready/');
categories = {'AD', 'CN', 'YA'};

for category = categories
    subjList = createSubjList(category);
    for subj = subjList
        if strcmp(category, 'AD')
            nAD = length(subjList);
        elseif strcmp(category, 'CN')
            nCN = length(subjList);
        elseif strcmp(category, 'YA')
            nYA = length(subjList);
        end
    end
end

nsubjects = nAD + nCN + nYA;

%Sets file to write
BATCH.filename = fullfile(dataDir, 'conn_MRI_faces.mat');
Batch.Setup.isnew = 1;

%Sets TR value
BATCH.Setup.RT = 1.05;

%Sets number of subjects
BATCH.Setup.nsubjects = nsubjects;

%Specifies the acquisition type (1 for continuous)
BATCH.Setup.acquisitiontype = 1;

%Specifies the type of analyses (1 for ROI-to-ROI, 2 for seed-to-voxel)
BATCH.Setup.analyses = [1,2];

%Specifies the analysis mask type (1 for a fixed template mask)
%BATCH.Setup.voxelmask = 1;

%Specifies the source of functional data for ROI timeseries extraction
%explicitly
%batch.Setup.roifunctionals.roiextract=1;

%We set up the covariates names
BATCH.Setup.covariates.names = {'motion'};

%We set the condition resting state
BATCH.Setup.conditions.names = {'rest'};

%We set the second level covariates
BATCH.Setup.subjects.effect_names = {'AllSubjects', 'AD', 'CN', 'YA'}; % % fixation on each type of emotional image (compared to neutral). Maybe the calculation needs to be redone (do the mean % (calculate the % for each trial)). Other variables to add ?
BATCH.Setup.subjects.effects{1} = [ones(1, nAD), ones(1, nOld)];
BATCH.Setup.subjects.effects{2} = [ones(1, nAD), zeros(1, nOld)];
BATCH.Setup.subjects.effects{3} = [zeros(1, nAD), ones(1, nOld)];
%Setup ROIs
BATCH.Setup.rois.names = {'atlas', 'networks', 'aal', 'dmn', 'AICHA'};
BATCH.Setup.rois.files{1} = 'D:\Matlab\spm\toolbox\conn\rois\atlas.nii';
BATCH.Setup.rois.files{2} = 'D:\Matlab\spm\toolbox\conn\rois\networks.nii';
BATCH.Setup.rois.files{3} = 'D:\Matlab\spm\toolbox\conn\utils\otherrois\aal.nii';
BATCH.Setup.rois.files{4} = 'D:\Matlab\spm\toolbox\conn\utils\otherrois\dmn.nii';
%BATCH.Setup.rois.files{5} = 'C:\toolbox\spm\toolbox\conn\utils\otherrois\AICHA.nii';
BATCH.Setup.rois.files{5} = 'D:\Matlab\spm\toolbox\conn\utils\otherrois\AICHA.nii';

%Loop through categories and subjects and associate functional and structural files
counterSubj = 0;
for category = categories
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    for subj = subjList
        disp(fprintf('------ Processing subject: %s of category %s ------', char(subj), char(category)));
        counterSubj = counterSubj + 1;

        %We select the functional volumes
        scanDir = char(strcat(curDir, subj, '/', 'Resting', '/'));
        spmfile = getFile(scanDir, '*.nii', sprintf('swar%s', char(subj)));
        movFile = getFile(scanDir, '*.mat', 'art_regression_outliers_and_movement');
        disp(strcat('Functional volume :  ', spmfile));
        BATCH.Setup.functionals{counterSubj}{1} = spmfile;
        BATCH.Setup.covariates.files{1}{counterSubj}{1} = movFile;

        %We select the anatomical volumes
        anatDir = char(strcat(curDir, subj, '/', 'Anat', '/'));
        anatFile = getFile(anatDir, '*.nii', sprintf('wm%s', char(subj)));
        spmfileC1 = getFile(anatDir, '*.nii', sprintf('mwc1%s', char(subj)));
        spmfileC2 = getFile(anatDir, '*.nii', sprintf('mwc2%s', char(subj)));
        spmfileC3 = getFile(anatDir, '*.nii', sprintf('mwc3%s', char(subj)));
        disp(strcat('Anatomical volume :  ', anatFile));
        disp(strcat('Grey mask :  ', spmfileC1));
        disp(strcat('White mask :  ', spmfileC2));
        disp(strcat('CSF mask :  ', spmfileC3));
        BATCH.Setup.structurals{counterSubj} = anatFile;
        BATCH.Setup.masks.Grey{counterSubj} = spmfileC1;
        BATCH.Setup.masks.White{counterSubj} = spmfileC2;
        BATCH.Setup.masks.CSF{counterSubj} = spmfileC3;

            
    end
end

conn_batch(BATCH);