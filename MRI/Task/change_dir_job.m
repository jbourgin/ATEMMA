function [matlabbatch] = change_dir_job(goDir)

matlabbatch{1}.cfg_basicio.file_dir.dir_ops.cfg_cd.dir = {goDir};

spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end