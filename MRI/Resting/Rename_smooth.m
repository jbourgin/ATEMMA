%Renames s6w files in sw (for conn analysis).
clear all
categories = {'Old', 'Young'};
dataDir = 'D:/MRI_faces/Files_ready/';

for category = categories
    curDir = char(strcat(dataDir, category, '/'));
    subjList = {};
    %We create the list of subject names
    files = dir(curDir);
    dirFlags = [files(:).isdir]; 
    subFolders = files(dirFlags);
    for k = 1:length(subFolders)
        subjList{k} = [subFolders(k).name];
    end
    for subj = subjList
        if ~contains(char(subj), '.')
            scanDir = char(strcat(curDir, subj, '/', 'Resting/Resting', '/'));
            scanFiles = dir(fullfile(scanDir, '*.nii'));
            %anatDir = char(strcat(curDir, subj, '/', 'Anat', '/'));
            %anatFiles = dir(fullfile(anatDir, '*.nii'));
            for k = 1:length(scanFiles)
                baseFileName = scanFiles(k).name;
                fullFileName = fullfile(scanDir, baseFileName);
                if startsWith(baseFileName, sprintf('s6warTest-%s', char(subj)))
                    rename = strcat(scanDir, baseFileName(1:1), baseFileName(3:end)) ; 
                    movefile(fullFileName, rename); 
                end
            end
        end;
    end;
end;