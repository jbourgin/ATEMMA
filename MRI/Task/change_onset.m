% http://www.ece.northwestern.edu/local-apps/matlabhelp/techdoc/ref/addpath.html
clear all
clear classes
addpath('D:/ATEMMA/MRI/Task/')
global dataDir;
dataDir = 'E:/IRM_Gaze_blank/Files_ready/';
cd(dataDir);
categories = {'AD', 'CN', 'YA'};

global spmdir;
spmdir = 'D:/Matlab/spm/';

global duration
duration = 10;

for category = categories
    disp(strcat('Category:  ', category));
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    for subj = subjList
        disp(strcat('Subject: ', subj));
        onsetDuration(subj, curDir);
    end
end
