% Create a subjList. Récupérer les files anat et scan (AD > subject_number
% > Anat/Resting)
clear all
clear classes
addpath('D:\ATEMMA\MRI\Resting\')
dataDir = 'D:\MRI_faces\Files_ready\';
cd(dataDir);
categories = {'AD', 'Old'}; % Old
preprocess = 1;
artprocess = 1;
transformFiles = 1;
art_without_model = 1;

for category = categories
    curDir = char(strcat(dataDir, category, '\'));
    %disp('------ Preprocessing started ------')
    disp(strcat('Category:  ', category));
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
            disp(strcat('Subject: ', subj));
            clear matlabbatch;
            if preprocess == 1
                scanDir = char(strcat(curDir, subj, '\', 'Resting', '\'));
                anatDir = char(strcat(curDir, subj, '\', 'Anat', '\'));
                spmfiles = dir(fullfile(scanDir, '*.nii'));
                spmfile = char(strcat(scanDir, spmfiles.name));
                anatFiles = dir(fullfile(anatDir, '*.nii'));
                anatFiles2 = char(strcat(anatDir, anatFiles.name));
                anatFile = expand_4d_vols(anatFiles2, 'Ok');
                if transformFiles == 1
                    funFiles = expand_4d_vols(spmfile, 'Not Ok');
                    replace_name = strcat('Test-',char(subj),'_resting','.nii');
                    mat_name = char(strcat(scanDir, replace_name(1:end-4), '.mat'));
                    transforming_files(funFiles, spmfile, replace_name, mat_name);
                    clear funFiles;
                    clear spmfile;
                    clear replace_name;
                    clear mat_name;
                    spmfiles = dir(fullfile(scanDir, '*.nii'));
                    spmfile = char(strcat(scanDir, spmfiles.name));
                    funFiles = expand_4d_vols(spmfile, 'Ok');
                else
                    funFiles = expand_4d_vols(spmfile, 'Ok');
                end
                change_dir_subject(scanDir);
                preprocessing_job(funFiles, anatFile);
                change_dir_global();
                clear funFiles;
                clear anatFile;
                clear spmfiles;
                clear anatFiles;
                clear anatFiles2;
            end
            if artprocess == 1
                scanDir = char(strcat(curDir, subj, '\', 'Resting', '\'));
                if art_without_model == 0
                    names = {'Baseline'};
                    durations = {2};
                    onsets = {[0:1:599]};
                    fichier_out = [scanDir 'onsets' char(subj) '.mat'];
                    save(fichier_out, 'names', 'onsets', 'durations');
                end
                niiFiles = dir(fullfile(scanDir, '*.nii'));
                textFiles = dir(fullfile(scanDir, '*.txt'));
                matFiles = dir(fullfile(scanDir, '*.mat'));
                for k = 1:length(niiFiles)
                    baseFileName = niiFiles(k).name;
                    fullFileName = fullfile(scanDir, baseFileName);
                    if startsWith(baseFileName, 'war')
                        artfile = fullFileName;
                        tempFile = spm_vol(artfile);
                        disp(tempFile);
                        number_vol = size(tempFile, 1);
                    elseif startsWith(baseFileName, 's6war')
                        spmfiles = fullFileName;
                    end
                end
                for j = 1:length(textFiles)
                    baseFileName = textFiles(j).name;
                    fullFileName = fullfile(scanDir, baseFileName);
                    if startsWith(baseFileName, sprintf('rp_Test-%s', char(subj)))
                        movFile = fullFileName;
                    end
                end
                if art_without_model == 0
                    for m = 1:length(matFiles)
                        baseFileName = matFiles(m).name;
                        fullFileName = fullfile(scanDir, baseFileName);
                        if startsWith(baseFileName, sprintf('onsets%s', char(subj)))
                            onsetFile = fullFileName;
                        end
                    end
                    firstLevelSpecification(spmfiles, onsetFile, movFile, scanDir);
                    clear matFiles;
                    matFiles = dir(fullfile(scanDir, '*.mat'));
                    for m = 1:length(matFiles)
                        baseFileName = matFiles(m).name;
                        fullFileName = fullfile(scanDir, baseFileName);
                        if startsWith(baseFileName, 'SPM')
                            matFile = {fullFileName}';
                        end
                    end
                else
                    matFile = 'None';
                end
                artProcessing(subj, number_vol, dataDir, scanDir, artfile, movFile, matFile, art_without_model);
                %clear subj;
                clear number_vol;
                clear scanDir;
                clear artfile;
                clear movFile;
                clear matFile;
                clear onsetFile;
                clear spmfiles;
                clear matFiles;
                clear textFiles;
                clear tempFile;
                clear artfile;
                clear niiFiles;
                clear fullFileName;
                clear baseFileName;
            end
        end
        %disp('------ Preprocessing ended ------');
    end
end
