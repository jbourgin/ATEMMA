% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/addpath.html
clear all
clear classes
addpath('/home/jessica/ATEMMA/MRI/Task/')
global dataDir;
dataDir = "/media/jessica/48243AC9243ABA30/IRM_Gaze/Files_ready/";
cd(dataDir);
categories = {'CN', 'YA'}; % remove AD for now

global spmdir;
spmdir = '/home/jessica/software/spm12/';

global unauthorizedEye;
unauthorizedEye = ['PT19','CB05','RM01','VM09','RC01','PR02', 'DL26', 'LD13', 'MC11', 'BM24', 'GS23', 'PV49', 'VS719'];

global nogaze;
nogaze = ['DL26', 'SH27', 'PT19', 'FC03'];

preprocess = false(1);
artprocess = false(1);

global TR_rsfiles;
TR_rsfiles = 2.5;
global nb_vol_removed;
nb_vol_removed = 0;
global baseline;
baseline = false(1);
global duration
duration = 10;

%set(0,'DefaultFigureVisible','off');

for category = categories
    disp(strcat('Category:  ', category));
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    for subj = subjList
        %We exclude these subjects because they have not enough sessions.
        %We need to change preprocessing_job for them. Done in
        %preprocessing_job_2
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
