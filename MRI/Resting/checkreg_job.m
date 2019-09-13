function [matlabbatch] = checkreg_job(files)

matlabbatch{1}.spm.util.checkreg.data = files;
spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end