clear all
clear classes
addpath('/home/jessica/ATEMMA/MRI/Resting/')
global dataDir;
dataDir = '/media/jessica/SSD_DATA/IRM_Gaze/Files_ready/';
cd(dataDir);
categories = {'AD', 'CN', 'YA'};

artprocess = true(1);
global transformFiles;
transformFiles = false(1);
global art_without_model;
art_without_model = false(1);
global TR_rsfiles;
TR_rsfiles = 1.05;
global nb_vol_removed;
nb_vol_removed = 10;
preprocess = true(1);
global spmdir;
spmdir = '/home/jessica/software/spm12/';

for category = categories
    disp(strcat('Category:  ', category));
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    for subj = subjList
        if ~contains(char(subj),'DD')
            disp(strcat('Subject: ', subj));
            if preprocess
                preprocess_function(subj, curDir);
                disp('-------- Preprocessing ended --------');
            end
            if artprocess
                art_processing(subj, curDir);
                disp('-------- ART ended --------');
            end
        end
    end
end