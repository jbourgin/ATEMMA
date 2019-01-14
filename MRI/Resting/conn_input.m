clear all
categories = {'AD', 'Old'};
nOld = 1;
nAD = 0;
nsubjects = nAD + nOld;
dataDir = 'D:/MRI_faces/Files_ready/';
%volDir = 'D:/IRM_Data/Volbrain/';
cd(dataDir);

clear BATCH;

%Sets file to write
BATCH.filename = fullfile(dataDir, 'conn_MRI_faces.mat');
Batch.Setup.isnew = 1;

%Sets TR value
BATCH.Setup.RT = 1;

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
BATCH.Setup.subjects.effect_names = {'AllSubjects', 'AD', 'Old'};
BATCH.Setup.subjects.effects{1} = [ones(1, nAD), ones(1, nOld)];
BATCH.Setup.subjects.effects{2} = [ones(1, nAD), zeros(1, nOld)];
BATCH.Setup.subjects.effects{3} = [zeros(1, nAD), ones(1, nOld)];
%BATCH.Setup.subjects.effects{4} = [59	67	65	63	73	69	56	76	78	79	68	84	70	77	69	33	30	39	34	48	52	45	30	44	39	36	35];
%BATCH.Setup.subjects.effects{5} = [59	67	65	63	73	69	56	76	78	79	68	84	70	77	69, zeros(1, nYoung)];
%BATCH.Setup.subjects.effects{6} = [zeros(1, nOld), 33	30	39	34	48	52	45	30	44	39	36	35];
%BATCH.Setup.subjects.effects{7} = [14	18	37	20	22	20	19	20	25	27	12	20	22	13	12	30	33	37	34	43	14	43	21	43	16	18	20];
%BATCH.Setup.subjects.effects{8} = [864.613485472152	919.946713948718	735.075959285	830.67286794214	949.075949367089	887.672709889896	813.897435897436	1103.78405997011	878.961038961039	1056.91151903402	972.63856195125	809.2084137975	1062.67834358007	807.453115933318	969.530641582278	802.857232774529	840.817923870588	898.312708523077	772.893649905953	740.465710531218	861.332019570904	820.470116759366	782.763836914214	770.583102076859	996.530166811085	717.630356842308	820.187708355];
%BATCH.Setup.subjects.effects{9} = [864.613485472152	919.946713948718	735.075959285	830.67286794214	949.075949367089	887.672709889896	813.897435897436	1103.78405997011	878.961038961039	1056.91151903402	972.63856195125	809.2084137975	1062.67834358007	807.453115933318	969.530641582278, zeros(1, nYoung)];
%BATCH.Setup.subjects.effects{10} = [zeros(1, nOld), 802.857232774529	840.817923870588	898.312708523077	772.893649905953	740.465710531218	861.332019570904	820.470116759366	782.763836914214	770.583102076859	996.530166811085	717.630356842308	820.187708355];
%BATCH.Setup.subjects.effects{11} = [1 0 1 1 0 1 1 0 1 0 0 1 0 1 0, zeros(1, nYoung)];
%BATCH.Setup.subjects.effects{12} = [0 1 0 0 1 0 0 1 0 1 1 0 1 0 1, zeros(1, nYoung)];
%BATCH.Setup.subjects.effects{13} = [864.613485472152	0	735.075959285	830.67286794214	0	887.672709889896	813.897435897436	0	878.961038961039	0	0	809.2084137975	0	807.453115933318	0, zeros(1, nYoung)];
%BATCH.Setup.subjects.effects{14} = [0	919.946713948718	0	0	949.075949367089	0	0	1103.78405997011	0	1056.91151903402	972.63856195125	0	1062.67834358007	0	969.530641582278, zeros(1, nYoung)];

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
    subjList = {};
    %We create the list of subject names
    files = dir(curDir);
    dirFlags = [files(:).isdir]; 
    subFolders = files(dirFlags);
    for k = 1:length(subFolders)
        subjList{k} = [subFolders(k).name];
    end
    for subj = subjList
        if ~contains(char(subj), '.')
            disp(fprintf('------ Processing subject: %s of category %s ------', char(subj), char(category)));
            counterSubj = counterSubj + 1;
            
            %We select the functional volumes
            scanDir = char(strcat(curDir, subj, '/', 'Resting', '/'));
            niiFiles = dir(fullfile(scanDir, '*.nii'));
            textFiles = dir(fullfile(scanDir, '*.mat'));
            %textFiles = dir(fullfile(scanDir, '*.txt'));
            for k = 1:length(niiFiles)
                baseFileName = niiFiles(k).name;
                fullFileName = fullfile(scanDir, baseFileName);
                % If we don't choose swr files, 2nd data set (on which ROI
                % will be selected) will not be correct -> it will be
                % smoothed, which will conduct to imprecise results.
                if startsWith(baseFileName, sprintf('swar'))
                    spmfile = fullFileName;
                %elseif startsWith(baseFileName, sprintf('wr%s', char(subj)))
                %    spmfile2 = fullFileName;
                %    BATCH.Setup.roifunctionals.roiextract_functional{counterSubj}{1} = fullFileName;
                end
            end
            for j = 1:length(textFiles)
                baseFileName = textFiles(j).name;
                fullFileName = fullfile(scanDir, baseFileName);
                %if contains(fullFileName, sprintf('rp_', char(subj)))
                if startsWith(baseFileName, 'art_regression_outliers_and_movement_')
                    movFile = fullFileName;
                end
            end
            disp(strcat('Functional volume :  ', spmfile));
            BATCH.Setup.functionals{counterSubj}{1} = spmfile;
            %BATCH.Setup.roifunctionals{counterSubj}{1} = spmfile2;
            BATCH.Setup.covariates.files{1}{counterSubj}{1} = movFile;
            clear spmfile;
            %clear spmfile2;
            clear movFile;
            clear niiFiles;
            clear scanDir;
            
            %We select the anatomical volumes
            anatDir = char(strcat(curDir, subj, '/', 'Anat', '/'));
            niiFiles = dir(fullfile(anatDir, '*.nii'));
            for k = 1:length(niiFiles)
                baseFileName = niiFiles(k).name;
                fullFileName = fullfile(anatDir, baseFileName);
                if startsWith(baseFileName, sprintf('wm'))
                    spmfileanat = fullFileName;
                elseif startsWith(baseFileName, sprintf('mwc1'))
                    spmfileC1 = fullFileName;
                elseif startsWith(baseFileName, sprintf('mwc2'))
                    spmfileC2 = fullFileName;
                elseif startsWith(baseFileName, sprintf('mwc3'))
                    spmfileC3 = fullFileName;
                end
            end
            disp(strcat('Anatomical volume :  ', spmfileanat));
            disp(strcat('Grey mask :  ', spmfileC1));
            disp(strcat('White mask :  ', spmfileC2));
            disp(strcat('CSF mask :  ', spmfileC3));
            BATCH.Setup.structurals{counterSubj} = spmfileanat;
            BATCH.Setup.masks.Grey{counterSubj} = spmfileC1;
            BATCH.Setup.masks.White{counterSubj} = spmfileC2;
            BATCH.Setup.masks.CSF{counterSubj} = spmfileC3;
            clear spmfileanat;
            clear spmfileC1;
            clear spmfileC2;
            clear spmfileC3;
            clear niiFiles;
            clear anatDir;
            
        end
    end
end

conn_batch(BATCH);