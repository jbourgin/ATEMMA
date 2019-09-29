% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/addpath.html
clear all
clear classes
addpath('/home/jessica/ATEMMA/MRI/Task/')
global dataDir;
dataDir = '/media/jessica/SSD_DATA/IRM_Gaze/Files_ready/';
cd(dataDir);
categories = {'AD', 'CN', 'YA'};

global spmdir;
spmdir = '/home/jessica/software/spm12/';

global unauthorizedEye;
unauthorizedEye = ['PT19','CB05','RM01','VM09','RC01','PR02'];

preprocess = false(1);
artprocess = true(1);

global TR_rsfiles;
TR_rsfiles = 2.5;
global nb_vol_removed;
nb_vol_removed = 0;

%set(0,'DefaultFigureVisible','off');

for category = categories
    disp(strcat('Category:  ', category));
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    for subj = subjList
        %Le faire à part en modifiant preprocessing_job
        %if ~contains(char(subj),'PT19')
        disp(strcat('Subject: ', subj));
        if preprocess
            preprocess_function(subj, curDir);
            disp('-------- Preprocessing ended --------');
        end
        if artprocess
            art_processing(subj, curDir);
            disp('-------- ART ended --------');
        end
        %end
    end
end
