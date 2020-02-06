function [matlabbatch] = transforming_files(filesList, spmfile, replace_name, mat_name)

matlabbatch{1}.spm.util.cat.vols = filesList;
matlabbatch{1}.spm.util.cat.name = replace_name;
matlabbatch{1}.spm.util.cat.dtype = 4;
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.files = {spmfile};
matlabbatch{2}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.files = {mat_name};
matlabbatch{3}.cfg_basicio.file_dir.file_ops.file_move.action.delete = false;

spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end
