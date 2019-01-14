function out = expand_4d_vols(nii_file, type_file)
    nb_vols = spm_select_get_nbframes(nii_file);
    threshold = 0;%10
    out = {};
    for k = 1:nb_vols
        if strcmp(type_file,'Not Ok') && k > threshold && k < 601
            out{k-threshold,1} = strcat(nii_file, ',', num2str(k));
        elseif strcmp(type_file,'Ok')
            out{k,1} = strcat(nii_file, ',', num2str(k));
        end
    end
    %out = strcat(repmat(nii_file, nb_vols, 1), ',', num2str([1:nb_vols]'));
end