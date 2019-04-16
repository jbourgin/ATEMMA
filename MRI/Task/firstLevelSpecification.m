% Not comparable to batch version (contrasts were changed to add parametric
% modulators)
% To add : gaze derivation from cross at the beginning of the trial
% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A3=ind1002&L=SPM&E=quoted-printable&P=4267684&B=--B_3348824016_952061&T=text%2Fhtml;%20charset=UTF-8
function [matlabbatch] = firstLevelSpecification(filesList, onsetsList, rpList, statDir)

matlabbatch{1}.spm.stats.fmri_spec.dir = {statDir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2.5;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = {filesList{1}};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {onsetsList{1}};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = {rpList{1}};
matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = {filesList{2}};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi = {onsetsList{2}};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = {rpList{2}};
matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = {filesList{3}};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi = {onsetsList{3}};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = {rpList{3}};
matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = {filesList{4}};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {}, 'orth', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = {onsetsList{4}};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = {rpList{4}};
matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Emotion_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1	1	-2	0   0   0   0   0   0   0	0	0	0	0	0	1	1	-2];
%matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Emotion_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0   0   0   0   0   0  0   0   0   0   0   0  0 0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	1	-2	0   0   0   0   0   0  0	0	0	0	0	0	1	1	-2	0	0	0	0	0	0   0   0   0   0   0   0];
%matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Fear_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0	1	-1	0   0   0   0   0   0   0	0	0	0	0	0	0	1	-1];
%matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Angry_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [1	0	-1	0   0   0   0   0   0   0	0	0	0	0	0	1	0	-1];
%matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Fear_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0   0   0   0   0   0   0   0   0   0   0   0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	-1	0	0	0	0	0	0	0	0   0   0   0   0   0   1	-1	0	0	0	0	0	0   0   0   0   0   0   0];
%matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Angry_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [0   0   0   0   0   0   0   0   0   0   0   0   0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	-1	0	0	0	0	0	0   0   0   0   0   0   0  1	0	-1	0	0	0	0	0	0   0   0   0   0   0   0];
%matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Inter_Neu_Emo_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1	1	-2	0	0	0	0	0	0	0   0   0   0   0   0   1	1	-2	0   0   0   0   0   0   0	0	0	0	0	0	-1	-1	2	0   0   0   0   0   0   0	0	0	0	0	0	-1	-1	2	0   0   0   0   0   0   0	0	0	0	0	0];
%matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	-2	0	0	0	0	0	0	0	0	0	-1	0	0	0	-1	0	0	0	2	0	0	0	0	0	0	0	0	0	-1	0	0	0	-1	0	0	0	2	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Inter_Fear_Neu_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0	1	-1	0   0   0   0   0   0   0	0	0	0	0	0	0	1	-1	0	0   0   0   0   0   0   0	0	0	0	0	0	-1	1	0	0   0   0   0   0   0   0	0	0	0	0	0	-1	1	0	0	0	0	0	0   0   0   0   0   0   0];
%matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	-1	0	0	0	0	0	0	0	0	0	0	0	0	0	-1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	-1	0	0	0	1	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Inter_Angry_Neu_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [1	0	-1	0   0   0   0   0   0   0	0	0	0	0	0	1	0	-1	0   0   0   0   0   0   0	0	0	0	0	0	-1	0	1	0   0   0   0   0   0   0	0	0	0	0	0	-1	0	1	0	0	0	0	0	0   0   0   0   0   0   0];
%matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0	-1	0	0	0	0	0	0	0	1	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
%{
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Emo_fix_eyes';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Emo_first_eyes';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Emo_resp_time';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0	0	0	0	1	0	0	0	1	0	0	0	0	0	0	0	0	0	0];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;
%}

spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end