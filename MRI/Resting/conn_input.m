clear all
clear BATCH;
addpath('/home/jessica/ATEMMA/MRI/Resting/')

global dataDir;
dataDir = strcat('/media/jessica/SSD_DATA/IRM_Gaze/Files_ready/');
categories = {'AD', 'CN'};

volDir = '/media/jessica/SSD_DATA/Volbrain_mri/';
volfiles = dir(volDir);
dirFlags = [volfiles(:).isdir];
volfolders = volfiles(dirFlags);

for category = categories
    subjList = createSubjList(category);
    for subj = subjList
        if strcmp(category, 'AD')
            nAD = length(subjList);
        elseif strcmp(category, 'CN')
            nCN = length(subjList);
        end
    end
end

nsubjects = nAD + nCN;

csvfile = readtable(strcat(dataDir, 'final_subjects_resting_scores.csv'));

names = {'Age', 'Genre', 'Amy', 'AmyL', 'AmyR', 'ICV', 'GDS'};
my_mat = zeros(nsubjects, length(names));

i = 0;
for category = categories
    subjList = createSubjList(category);
    for subj = subjList
        i = i + 1;
        for elt = 1:length(csvfile.Sujets)
            if strcmp(char(subj), csvfile.Sujets(elt))
                my_mat(i, find(strcmp(names,'Genre'))) = csvfile.Genre(elt);
                my_mat(i, find(strcmp(names,'Age'))) = csvfile.Age(elt);
                my_mat(i, find(strcmp(names,'GDS'))) = csvfile.GDS(elt);
                my_mat(i, find(strcmp(names,'ICV'))) = csvfile.Tissue_IC(elt);
                my_mat(i, find(strcmp(names,'Amy'))) = csvfile.NormalizedAmygdala(elt);
                my_mat(i, find(strcmp(names,'AmyL'))) = csvfile.NormalizedAmygdala_left(elt);
                my_mat(i, find(strcmp(names,'AmyR'))) = csvfile.NormalizedAmygdala_right(elt);
            end
        end
    end
end


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
BATCH.Setup.subjects.effect_names = cat(2, {'AllSubjects', 'AD', 'CN'}, names); % % fixation on each type of emotional image (compared to neutral). Maybe the calculation needs to be redone (do the mean % (calculate the % for each trial)). Other variables to add ?
BATCH.Setup.subjects.effects{1} = [ones(1, nAD), ones(1, nCN)];
BATCH.Setup.subjects.effects{2} = [ones(1, nAD), zeros(1, nCN)];
BATCH.Setup.subjects.effects{3} = [zeros(1, nAD), ones(1, nCN)];
for i = 1:length(names)
    BATCH.Setup.subjects.effects{i+3} = transpose(my_mat(:,i));
end

atlasDir = '/media/jessica/SSD_DATA/AtlasFull/';
atlasnames = {};
atlas = {};
atlasfolders = dir(atlasDir);
count = 0;
for k = 1:length(atlasfolders)
    if contains(char(atlasfolders(k).name), 'ROI')
        count = count + 1;
        atlasnames{count} = atlasfolders(k).name;
        atlas{count} = fullfile(atlasDir, atlasfolders(k).name);
    end
end

%Setup ROIs
BATCH.Setup.rois.names = cat(2,atlasnames,'left_amy','right_amy');
for k = 1:length(atlas)
    BATCH.Setup.rois.files{k} = atlas{k};
end

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
        spmfile = getFile(scanDir, '*.nii', sprintf('swa%s', char(subj)));
        movFile = getFile(scanDir, '*.mat', 'art_regression_outliers_and_movement');
        disp(strcat('Functional volume :  ', spmfile));
        BATCH.Setup.functionals{counterSubj}{1} = spmfile;
        BATCH.Setup.covariates.files{1}{counterSubj}{1} = movFile;

        %We select the anatomical volumes
        anatDir = char(strcat(curDir, subj, '/', 'Anat_rest', '/'));
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
        
        for j = 1:length(volfolders)
            if startsWith(volfolders(j).name, sprintf('%s', char(subj)))
                volsubjfiles = dir(strcat(volDir, volfolders(j).name));
                BATCH.Setup.rois.files{length(atlasnames)+1}{counterSubj} = getFile(strcat(volDir, volfolders(j).name), '*.nii', sprintf('%s_left_amy', char(subj)));
                BATCH.Setup.rois.files{length(atlasnames)+2}{counterSubj} = getFile(strcat(volDir, volfolders(j).name), '*.nii', sprintf('%s_right_amy', char(subj)));
            end
        end           
    end
end

conn_batch(BATCH);