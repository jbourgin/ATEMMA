function art_processing(subj, curDir)
    
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
    
    statDir = char(strcat(scanDir, 'stats'));
    if ~exist(statDir, 'dir')
        mkdir(statDir)
    end
    %if length(spmfilesArt) == 4
    firstLevelSpecificationClassic(spmfilesArt, onsetFilesList, movFilesList, statDir)
    %else
        %disp('Number of sessions different from 4');
    %end
    
    matFile = getFile(statDir, '*.mat', 'SPM');
    
    h = figure;
    text(0.5,0.5,char(subj));
    set(gca,'visible','off');
    print('-dpsc2', h, '-append', 'artfile') %,'-bestfit'
    close(h);
    art_job(subj, number_vol, scanDir, matFile);
               
end