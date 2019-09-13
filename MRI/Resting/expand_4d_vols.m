function out = expand_4d_vols(nii_file, type_file, high_threshold)
    nb_vols = spm_select_get_nbframes(nii_file);
    if contains(nii_file,'VP18')
        high_threshold = 230;
    end
    global nb_vol_removed;
    out = {};
    for k = 1:nb_vols
        if strcmp(type_file,'Not Ok') && k > nb_vol_removed && k < high_threshold
            out{k-nb_vol_removed,1} = strcat(nii_file, ',', num2str(k));
        elseif strcmp(type_file,'Ok')
            out{k,1} = strcat(nii_file, ',', num2str(k));
        end
    end
    %out = strcat(repmat(nii_file, nb_vols, 1), ',', num2str([1:nb_vols]'));
end