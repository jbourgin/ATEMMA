function contrast_group(contrast_list, filter_list, finalDir, statDir)

    global dataDir;
    global resultDir;
    global categories;

    for contrast_num = 1:length(contrast_list)
        contrast = contrast_list{contrast_num};
        disp(strcat('Contrast :', contrast));
        globalspmFiles = [];
        for category = categories
            disp(strcat('Category :  ', category));
            curDir = char(strcat(dataDir, category, '/'));
            subjList = createSubjList(category);
            spmFilesList = [];
            for subj = subjList
                if isempty(filter_list) || ~contains(filter_list,char(subj))
                    disp(strcat('subj :', char(subj)));
                    spmFilesList{end+1} = getFile(char(strcat(curDir, char(subj), '/Task/', statDir, '/')), '*.nii', contrast{1});
                end
            end
            onettest_job(spmFilesList, char(strcat(resultDir, finalDir, '/', contrast{2}, '/', category, '/')), contrast{2});
            globalspmFiles{end+1} = spmFilesList;
        end
        disp(globalspmFiles{1});
        disp(globalspmFiles{2});
        twottest_job(globalspmFiles{1}, globalspmFiles{2}, char(strcat(resultDir, finalDir, '/', contrast{2}, sprintf('/%s-%s/', categories{1}, categories{2}))), sprintf('/%s-%s/', categories{1}, categories{2}), sprintf('/%s-%s/', categories{2}, categories{1}));
    end
end