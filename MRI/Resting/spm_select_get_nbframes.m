function n = spm_select_get_nbframes(file)
    N = nifti(file);
    dim = [N.dat.dim 1 1 1 1 1];
    n = dim(4);
end