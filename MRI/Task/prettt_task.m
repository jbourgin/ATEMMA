% Create a subjList. Récupérer les files anat et scan (AD > subject_number
% > Anat/Resting)
% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/addpath.html
clear all
clear classes
addpath('D:\ATEMMA\MRI\Task\')
workingDir = 'D:\MRI_faces\';
dataDir = char(strcat(workingDir, 'Files_ready\'));
cd(workingDir);
categories = {'AD', 'Old'};
preprocess = 1;
artprocess = 1;
transformFiles = 1;

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
			scanDir = char(strcat(curDir, subj, '\', 'Task', '\'));
            if preprocess == 1
                anatDir = char(strcat(curDir, subj, '\', 'Anat', '\'));
                spmfiles = dir(fullfile(scanDir, '*.nii'));
				spmFilesList = [];
                for a = 1:length(spmfiles)
                    spmFilesList{a} = fullfile(scanDir, spmfiles(a).name);
                end
                disp(spmFilesList);
                anatFiles = dir(fullfile(anatDir, '*.nii'));
                anatFiles2 = char(strcat(anatDir, anatFiles.name));
                anatFile = expand_4d_vols(anatFiles2, 'Ok');
                if transformFiles == 1
                    for b = 1:length(spmFilesList)
						funFiles = expand_4d_vols(spmFilesList{b}, 'Not Ok');
						replace_name = strcat(char(subj),'_Task_Session', num2str(b),'.nii');
						mat_name = char(strcat(scanDir, replace_name(1:end-4), '.mat'));
                        disp(spmFilesList{b});
                        disp(funFiles);
                        disp(replace_name);
						transforming_files(funFiles, spmFilesList{b}, replace_name, mat_name);
						clear funFiles;
						clear replace_name;
						clear mat_name;
                    end
					clear spmFilesList;
					spmFilesList = [];
                    spmfiles = dir(fullfile(scanDir, '*.nii'));
                    for c = 1:length(spmfiles)
						spmFilesList{c} = fullfile(scanDir, spmfiles(c).name);
                    end
                end
				funFilesList = [];
				for d = 1:length(spmFilesList)
					funFilesList{d} = expand_4d_vols(spmFilesList{d}, 'Ok');
                end
                disp(funFilesList);
                change_dir_subject(scanDir);
                if length(funFilesList) == 4
					preprocessing_job(funFilesList, anatFile, scanDir);
                else
                    disp('Number of sessions different from 4');
                end
                change_dir_global();
                clear funFilesList;
				clear spmFilesList;
                clear anatFile;
				clear anatFiles;
				clear anatFiles2;
				clear spmfiles;
            end
            if artprocess == 1
                onsetDir = char(strcat(curDir, subj, '\', 'Onsets', '\'));
				onsetfiles = dir(fullfile(onsetDir, '*.mat'));
				onsetFilesList = [];
				for a = 1:length(onsetfiles)
                    disp(onsetfiles(a).name);
					onsetFilesList{a} = fullfile(onsetDir, onsetfiles(a).name);
				end
                niiFiles = dir(fullfile(scanDir, '*.nii'));
                textFiles = dir(fullfile(scanDir, '*.txt'));
                matFiles = dir(fullfile(onsetDir, '*.mat'));
				number_vol = 0;
				spmFilesList = [];
                num_swra = 1;
                for k = 1:length(niiFiles)
                    baseFileName = niiFiles(k).name;
                    fullFileName = fullfile(scanDir, baseFileName);
                    if startsWith(baseFileName, 'wra')
                        artfile = fullFileName;
                        tempFile = spm_vol(artfile);
                        disp(tempFile);
                        number_vol = number_vol + size(tempFile, 1);
                    elseif startsWith(baseFileName, sprintf('swra'))
                        spmFilesList{num_swra} = fullFileName;
                        num_swra = num_swra + 1;
                    end
                end
                disp(spmFilesList);
				movFilesList = [];
                for j = 1:length(textFiles)
                    baseFileName = textFiles(j).name;
                    fullFileName = fullfile(scanDir, baseFileName);
                    if startsWith(baseFileName, sprintf('rp_a'))
						movFilesList{j} = fullFileName;
                    end
                end
                disp(movFilesList);
				onsetFilesList = [];
                for m = 1:length(matFiles)
                    baseFileName = matFiles(m).name;
                    if startsWith(baseFileName, sprintf('onsets', char(subj)))
                        onsetFilesList{m} = fullfile(onsetDir, onsetfiles(m).name);
                    end
                end
                disp(onsetFilesList);
				statDir = char(strcat(scanDir, 'stats'));
                if ~exist(statDir, 'dir')
                    mkdir(statDir)
                end
                if length(spmFilesList) == 4
					firstLevelSpecification(spmFilesList, onsetFilesList, movFilesList, statDir)
                else
                    disp('Number of sessions different from 4');
                end
				clear matFiles;
				matFiles = dir(fullfile(statDir, '*.mat'));
				for m = 1:length(matFiles)
					baseFileName = matFiles(m).name;
					fullFileName = fullfile(statDir, baseFileName);
					if startsWith(baseFileName, 'SPM')
						matFile = {fullFileName}';
					end
				end
                artProcessing(subj, number_vol, dataDir, scanDir, matFile);
                clearvars -except dataDir workingDir categories category preprocess artprocess transformFiles curDir subj subjList

            end
        end
        %disp('------ Preprocessing ended ------');
    end
end