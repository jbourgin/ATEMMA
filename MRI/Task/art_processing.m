function art_processing(subj, curDir)
    
    global unauthorizedEye;
    scanDir = char(strcat(curDir, subj, '/', 'Task', '/'));
    onsetDuration(subj, curDir);
    onsetDir = char(strcat(curDir, subj, '/', 'Onsets', '/'));
      
    spmfilesArt = [];
    movFilesList = [];
    onsetFilesList = [];
    artfilesList = [];
    number_vol = 0;
    %for c = 1:4
    for c = 1:2
        spmfilesArt{c} = getFile(scanDir, '*.nii', sprintf('s6wa%s_Task_Session%i', char(subj), c));
        artfilesList{c} = getFile(scanDir, '*.nii', sprintf('wa%s_Task_Session%i', char(subj), c));
        movFilesList{c} = getFile(scanDir, '*.txt', sprintf('rp_%s_Task_Session%i', char(subj), c));
        onsetFilesList{c} = getFile(onsetDir, '*.mat', sprintf('onsets%sSession%i.mat', char(subj), c));
        number_vol = number_vol + size(spm_vol(artfilesList{c}));
        disp(spmfilesArt{c});
        disp(movFilesList{c});
        disp(onsetFilesList{c});
        disp(artfilesList{c});
    end
    
    h = figure;
    text(0.5,0.5,char(subj));
    set(gca,'visible','off');
    print('-dpsc2', h, '-append', 'artfile') %,'-bestfit'
    close(h);
    
    statDir = char(strcat(scanDir, 'stats'));
    statDirResp = char(strcat(scanDir, 'statsResp'));
    statDirEye = char(strcat(scanDir, 'statsEye'));
    if ~exist(statDir, 'dir')
        mkdir(statDir)
    end
    if length(spmfilesArt) == 2
        firstLevelSpecificationClassic(spmfilesArt, onsetFilesList, movFilesList, statDir)
        print('-dpsc2', '-f1', '-append', 'artfile')
        if ~contains(curDir, 'YA')
            onsetpmod(subj, curDir, false(1));
            firstLevelSpecificationClassicResponse(spmfilesArt, onsetFilesList, movFilesList, statDirResp)
            print('-dpsc2', '-f1', '-append', 'artfile')
            if ~contains(unauthorizedEye,char(subj))
                onsetpmod(subj, curDir, true(1));
                firstLevelSpecificationClassicEye(spmfilesArt, onsetFilesList, movFilesList, statDirEye)
            end
        end
    else
        disp('Number of sessions different from 2');
    end
    
    matFile = getFile(statDir, '*.mat', 'SPM');
    
    art_job(subj, number_vol, scanDir, matFile);
               
end