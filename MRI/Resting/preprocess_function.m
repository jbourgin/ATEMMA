function preprocess_function(subj, curDir)
    global spmdir;
    global dataDir;

    scanDir = char(strcat(curDir, subj, '/', 'Resting', '/'));
    anatDir = char(strcat(curDir, subj, '/', 'Anat_rest', '/'));
    
    % Rename anat file
    anatFiles = dir(fullfile(anatDir, '*.nii'));
    anatFiles2 = char(strcat(anatDir, anatFiles.name));
    %anatFile = expand_4d_vols(anatFiles2, 'Ok', 'Not relevant');
    %replace_name = strcat(char(subj),'_T1','.nii');
    %mat_name = char(strcat(anatDir, replace_name(1:end-4), '.mat'));
    %transforming_files(anatFile, anatFiles2, replace_name, mat_name);
    replace_name = strcat(anatDir, char(subj),'_T1','.nii');
    movefile(anatFiles2, replace_name); 
    %clear anatFile;
    clear replace_name;
    clear mat_name;
    anatFileRaw = getFile(anatDir, '*.nii', sprintf('%s_T1', char(subj)));
    anatFile = expand_4d_vols(char(anatFileRaw), 'Ok', 'Not relevant');  
    
    % Rename fun file and removing first volumes
    spmfiles = dir(fullfile(scanDir, '*.nii'));
    spmfiles2 = char(strcat(scanDir, spmfiles.name));
    %funFilesRaw = expand_4d_vols(spmfiles2, 'Not Ok', 1000);
    %replace_name = strcat(char(subj),'_Resting','.nii');
    %mat_name = char(strcat(scanDir, replace_name(1:end-4), '.mat'));
    %transforming_files(funFilesRaw, spmfiles2, replace_name, mat_name);
    replace_name = strcat(scanDir, char(subj),'_Resting','.nii');
    movefile(spmfiles2, replace_name); 
    spmfileRaw = getFile(scanDir, '*.nii', sprintf('%s', char(subj)));
    funFiles = expand_4d_vols(char(spmfileRaw), 'Ok', 'Not relevant');
    
    preprocessing_job(funFiles, anatFile);
    anatNormFile = getFile(anatDir, '*.nii', sprintf('w%s', char(subj)));
    anatNormFile2 = getFile(anatDir, '*.nii', sprintf('wm%s', char(subj)));
    c1file = getFile(anatDir, '*.nii', sprintf('mwc1%s', char(subj)));
    c2file = getFile(anatDir, '*.nii', sprintf('mwc2%s', char(subj)));
    c3file = getFile(anatDir, '*.nii', sprintf('mwc3%s', char(subj)));
    scanNormFile = getFile(scanDir, '*.nii', sprintf('wmean%s', char(subj)));
    
    % Normalization check
    checkfiles{1,1} = fullfile(spmdir,'canonical/single_subj_T1.nii');
    checkfiles{2,1} = anatNormFile;
    checkfiles{3,1} = scanNormFile;
    checkreg_job(checkfiles);
    currentpsfile = getFile(dataDir, '*.ps', 'spm');
    print('-dpsc2', '-f1', '-append', currentpsfile)
    clear checkfiles;
    
    % Segmentation check
    checkfiles{1,1} = anatNormFile;
    checkfiles{2,1} = anatNormFile2;
    checkfiles{3,1} = c1file;
    checkfiles{4,1} = c2file;
    checkfiles{5,1} = c3file;
    checkreg_job(checkfiles);

    print('-dpsc2', '-f1', '-append', currentpsfile)
end