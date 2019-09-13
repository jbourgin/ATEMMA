function art_processing(subj, curDir)    

    global art_without_model;
    global TR_rsfiles;
    
    scanDir = char(strcat(curDir, subj, '/', 'Resting', '/'));
    artfile = getFile(scanDir, '*.nii', 'wa');
    tempFile = spm_vol(artfile);
    disp(tempFile);
    number_vol = size(tempFile, 1);
    
    if not(art_without_model)
        names = {'Baseline'};
        durations = {TR_rsfiles};
        % To check
        onsets = {[0:TR_rsfiles:(number_vol-1)*TR_rsfiles]};
        fichier_out = [scanDir 'onsets' char(subj) '.mat'];
        save(fichier_out, 'names', 'onsets', 'durations');
    end
    try
        spmfilesArt = getFile(scanDir, '*.nii', 's6wa');
    catch
        warning('No s6wr found. Must have been renamed to swa.');
        spmfilesArt = getFile(scanDir, '*.nii', 'swa');
    end

    movFile = getFile(scanDir, '*.txt', sprintf('rp_%s', char(subj)));
    if not(art_without_model)
        onsetFile = getFile(scanDir, '*.mat', sprintf('onsets%s', char(subj)));
        firstLevelSpecification(spmfilesArt, onsetFile, movFile, scanDir);
        matFile = getFile(scanDir, '*.mat', 'SPM');
    else
        matFile = 'None';
    end
    
    h = figure;
    text(0.5,0.5,char(subj));
    set(gca,'visible','off');
    print('-dpsc2', h, '-append', 'artfile') %,'-bestfit'
    close(h);
    art_job(subj, number_vol, scanDir, artfile, movFile, matFile);
end