% Create a subjList. Récupérer les files anat et scan (AD > subject_number
% > Anat/Resting)
clear all
clear classes
dataDir = 'D:\MRI_faces\Files_ready\';
cd(dataDir);
categories = {'AD', 'Old'}; % Old
preprocess = 1;
artprocess = 1;
transformFiles = 1;
art_without_model = 0;

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
                    replace_name = strcat('Test-',char(subj),'_Resting','.nii');
                    transforming_files(funFiles, spmfile, replace_name);
                    clear funFiles;
                    clear spmfile;
                    spmfiles = dir(fullfile(scanDir, '*.nii'));
                    spmfile = char(strcat(scanDir, spmfiles.name));
                    funFiles = expand_4d_vols(spmfile, 'Ok');
                else
                    funFiles = expand_4d_vols(spmfile, 'Ok');
                end
                clear funFiles;
                clear anatFile;
                clear spmfiles;
                clear anatFiles;
                clear anatFiles2;
            end
        end
        %disp('------ Preprocessing ended ------');
    end
end
