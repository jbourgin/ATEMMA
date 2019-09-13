function preprocess_function(subj, curDir)
    global spmdir;
    global dataDir;

    subjName = char(subj);
    scanDir = char(strcat(curDir, subj, '/', 'Task', '/'));
    anatDir = char(strcat(curDir, subj, '/', 'Anat', '/'));
    spmfiles = dir(fullfile(scanDir, '*.nii'));
    spmFilesList = [];
    for a = 1:length(spmfiles)
        spmFilesList{a} = fullfile(scanDir, spmfiles(a).name);
        disp(spmFilesList{a});
    end
    
    % Rename anat file
    anatFiles = dir(fullfile(anatDir, '*.nii'));
    anatFiles2 = char(strcat(anatDir, anatFiles.name));
    anatFile = expand_4d_vols(anatFiles2, 'Ok', 'Not relevant');
    replace_name = strcat(char(subj),'_T1','.nii');
    mat_name = char(strcat(anatDir, replace_name(1:end-4), '.mat'));
    transforming_files(anatFile, anatFiles2, replace_name, mat_name);
    clear anatFile;
    clear anatFileRaw;
    clear replace_name;
    clear mat_name;
    anatFileRaw = getFile(anatDir, '*.nii', sprintf('%s_T1', char(subj)));
    anatFile = expand_4d_vols(char(anatFileRaw), 'Ok', 'Not relevant');  
    
    % Rename fun files
    for b = 1:length(spmFilesList)
        funFilesRaw = expand_4d_vols(spmFilesList{b}, 'Ok', 'Not relevant');
        replace_name = strcat(char(subj),'_Task_Session', num2str(b),'.nii');
        mat_name = char(strcat(scanDir, replace_name(1:end-4), '.mat'));
        transforming_files(funFilesRaw, spmFilesList{b}, replace_name, mat_name);
    end
    clear spmFilesList;
    spmFilesList = [];
    spmfiles = dir(fullfile(scanDir, '*.nii'));
    for c = 1:length(spmfiles)
        spmFilesList{c} = fullfile(scanDir, spmfiles(c).name);
        disp(spmFilesList{c});
    end
    funFilesList = [];
    for d = 1:length(spmFilesList)
        funFilesList{d} = expand_4d_vols(spmFilesList{d}, 'Ok');
        disp(funFilesList{d});
    end
    if length(funFilesList) == 4
        preprocessing_job(funFilesList, anatFile);
        anatNormFile = getFile(anatDir, '*.nii', sprintf('w%s', char(subj)));
        scanNormFile = getFile(scanDir, '*.nii', sprintf('wmean%s', char(subj)));
        
        % Normalization check
        checkfiles{1,1} = fullfile(spmdir,'canonical/single_subj_T1.nii');
        checkfiles{2,1} = anatNormFile;
        checkfiles{3,1} = scanNormFile;
        checkreg_job(checkfiles);
        currentpsfile = getFile(dataDir, '*.ps', 'spm');
        print('-dpsc2', '-f1', '-append', currentpsfile)
        clear checkfiles;

    else
        disp('Number of sessions different from 4');
    end
    
end