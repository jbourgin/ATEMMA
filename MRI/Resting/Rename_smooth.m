%Renames s6w files in sw (for conn analysis).
categories = {'AD', 'CN'};
global dataDir;
dataDir = '/media/jessica/SSD_DATA/IRM_Gaze/Files_ready/';

for category = categories
    disp(category)
    curDir = char(strcat(dataDir, category, '/'));
    subjList = createSubjList(category);
    disp(subjList)
    for subj = subjList
        if ~contains(char(subj), '.')
            scanDir = char(strcat(curDir, subj, '/', 'Resting', '/'));
            disp(scanDir);
            scanFiles = dir(fullfile(scanDir, '*.nii'));
            for k = 1:length(scanFiles)
                baseFileName = scanFiles(k).name;
                fullFileName = fullfile(scanDir, baseFileName);
                if startsWith(baseFileName, sprintf('s6wa%s', char(subj)))
                    rename = strcat(scanDir, baseFileName(1:1), baseFileName(3:end)) ; 
                    movefile(fullFileName, rename); 
                end
            end
        end
    end
end