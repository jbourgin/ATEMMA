function subjList = createSubjList(category)

    global dataDir;
    
    curDir = char(strcat(dataDir, category, '/'));
    subjList = {};
    %We create the list of subject names
    subjfolders = dir(curDir);
    dirFlags = [subjfolders(:).isdir]; 
    subFolders = subjfolders(dirFlags);
    count = 0;
    for k = 1:length(subFolders)
        if ~contains(char(subFolders(k).name), '.') && length(char(subFolders(k).name)) > 1
            count = count + 1;
            subjList{count} = [subFolders(k).name];
        end
    end
end