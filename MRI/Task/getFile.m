function file = getFile(curDir, fileType, eltSearched)
    allFiles = dir(fullfile(curDir, fileType));
    for j = 1:length(allFiles)
        baseFileName = allFiles(j).name;
        fullFileName = fullfile(curDir, baseFileName);
        if startsWith(baseFileName, eltSearched)
            file = fullFileName;
        end
    end
    %disp(file);
end