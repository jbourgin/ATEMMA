function [matlabbatch] = change_dir_global()

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {'D:\MRI_faces\'};

spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end