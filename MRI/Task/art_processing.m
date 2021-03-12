function art_processing(subj, curDir)
    
    global unauthorizedEye;
    global nogaze;
    global baseline;
    scanDir = char(strcat(curDir, subj, '/', 'Task', '/'));
    onsetDuration(subj, curDir);
    onsetDir = char(strcat(curDir, subj, '/', 'Onsets', '/'));
      
    spmfilesArt = [];
    movFilesList = [];
    onsetFilesList = [];
    artfilesList = [];
    number_vol = 0;
    if ~contains(nogaze, char(subj))
        tt_nb_sessions = 4;
    else
        tt_nb_sessions = 2;
    end
    for c = 1:tt_nb_sessions
    %for c = 1:2  We don't do sessions 3 and 4. Ok for DL26, SH27 and PT19.
    %Won't be ok for gaze analysis.
        spmfilesArt{c} = getFile(scanDir, '*.nii', sprintf('s8wa%s_Task_Session%i', char(subj), c)); % smooth 8
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
    
    statDirResp = char(strcat(scanDir, 'statsResp'));
    statDirEye = char(strcat(scanDir, 'statsEye'));
    statDirClassicEye = char(strcat(scanDir, 'statsClassicEye'));
    statDirClassicResp = char(strcat(scanDir, 'statsClassicResp'));
    
    statDirClassic = char(strcat(scanDir, 'statsDirClassic'));
    statDirGazeClassic = char(strcat(scanDir, 'statsDirGazeClassic'));
    if length(spmfilesArt) == tt_nb_sessions
        % not used I think
        firstLevelSpecificationClassic(spmfilesArt, onsetFilesList, movFilesList, statDirClassic)
        print('-dpsc2', '-f1', '-append', 'artfile')
        if ~contains(nogaze,char(subj)) && length(spmfilesArt) == 4
            firstLevelSpecification(spmfilesArt, onsetFilesList, movFilesList, statDirGazeClassic)
            print('-dpsc2', '-f1', '-append', 'artfile')
            % add response information to pmod
            onsetpmod(subj, curDir, false(1));
            % main. Controls response.
            firstLevelSpecificationResponse(spmfilesArt, onsetFilesList, movFilesList, statDirResp)
            print('-dpsc2', '-f1', '-append', 'artfile')
            % for tracking analyses.
            if ~contains(unauthorizedEye,char(subj))
                onsetpmod(subj, curDir, true(1));
                firstLevelSpecificationEye(spmfilesArt, onsetFilesList, movFilesList, statDirEye)
                print('-dpsc2', '-f1', '-append', 'artfile')
            end
        end
        % do not use. Set to false in prettt_task. Will not work because
        % changes onsets.
        if baseline
            statDirBaseline = char(strcat(scanDir, 'statsDirBaseline'));
            onsetbaseline(subj, curDir);
            firstLevelSpecificationClassicBaseline(spmfilesArt, onsetFilesList, movFilesList, statDirBaseline)
            print('-dpsc2', '-f1', '-append', 'artfile')
        end
        % add response information to pmod
        onsetpmod(subj, curDir, false(1));
        % main used in thesis
        firstLevelSpecificationClassicResponse(spmfilesArt, onsetFilesList, movFilesList, statDirClassicResp)
        print('-dpsc2', '-f1', '-append', 'artfile')
        % add response information and eyetracking to pmod
        if ~contains(unauthorizedEye,char(subj))
            onsetpmod(subj, curDir, true(1));
            % main used for tracking analysis in thesis
            firstLevelSpecificationClassicEye(spmfilesArt, onsetFilesList, movFilesList, statDirClassicEye)
            print('-dpsc2', '-f1', '-append', 'artfile')
        end
        if ~contains(nogaze,char(subj)) && length(spmfilesArt) == 4
            matFile = getFile(statDirGazeClassic, '*.mat', 'SPM');
        else
            matFile = getFile(statDirClassic, '*.mat', 'SPM');
        end
    else
        disp('Number of sessions different from ');
        disp (tt_nb_sessions);
    end
    
    
    
    art_job(subj, number_vol, scanDir, matFile);
               
end