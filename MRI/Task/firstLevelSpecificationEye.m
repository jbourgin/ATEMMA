% Not comparable to batch version (contrasts were changed to add parametric
% modulators)
% Add gaze fear > Neutral > classic fear > neutral. See Isabella 2016.
% Add information about eyetracking.
% Add mask freesurfer ?
%See multiple regression ?
% To add : gaze derivation from cross at the beginning of the trial
% https://www.jiscmail.ac.uk/cgi-bin/webadmin?A3=ind1002&L=SPM&E=quoted-printable&P=4267684&B=--B_3348824016_952061&T=text%2Fhtml;%20charset=UTF-8
function [matlabbatch] = firstLevelSpecificationEye(filesList, onsetsList, rpList, statDir)

global TR_rsfiles;
nzeros = 6;

matlabbatch{1}.spm.stats.fmri_spec.dir = {statDir};
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = TR_rsfiles;
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
% main task
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Classic';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Gaze';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% contrast task
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Gaze-Classic';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [-1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Classic-Gaze';
matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
% emo
% fear
matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Fear';
matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 'Fear Classic';
matlabbatch{3}.spm.stats.con.consess{6}.tcon.weights = [0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 'Fear Gaze';
matlabbatch{3}.spm.stats.con.consess{7}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
% angry
matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 'Angry';
matlabbatch{3}.spm.stats.con.consess{8}.tcon.weights = [1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 'Angry Classic';
matlabbatch{3}.spm.stats.con.consess{9}.tcon.weights = [1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 'Angry Gaze';
matlabbatch{3}.spm.stats.con.consess{10}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
% neutral
matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 'Neutral';
matlabbatch{3}.spm.stats.con.consess{11}.tcon.weights = [0 0 0 0 0 0 1 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 'Neutral Classic';
matlabbatch{3}.spm.stats.con.consess{12}.tcon.weights = [0 0 0 0 0 0 1 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 'Neutral Gaze';
matlabbatch{3}.spm.stats.con.consess{13}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0 zeros(1,nzeros) 0 0 0 0 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
% contrast emo
% emo
matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 'Emotion> Neutre';
matlabbatch{3}.spm.stats.con.consess{14}.tcon.weights = [1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0];
matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 'Emotion_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{15}.tcon.weights = [1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0];
matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 'Emotion_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{16}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0];
matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'Emotion_Gaze > Emotion_Classic';
matlabbatch{3}.spm.stats.con.consess{17}.tcon.weights = [-1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0];
matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'Emotion_Classic > Emotion_Gaze';
matlabbatch{3}.spm.stats.con.consess{18}.tcon.weights = [1 0 0 1 0 0 1 0 0 zeros(1,nzeros) 1 0 0 1 0 0 1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
% fear
matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'Fear > Neutre';
matlabbatch{3}.spm.stats.con.consess{19}.tcon.weights = [0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'Fear_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{20}.tcon.weights = [0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'Fear_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{21}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'Fear_Gaze > Fear_Classic';
matlabbatch{3}.spm.stats.con.consess{22}.tcon.weights = [0 0 0 -1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 -1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'Fear_Classic > Fear_Gaze';
matlabbatch{3}.spm.stats.con.consess{23}.tcon.weights = [0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 -1 0 0 0 0 0 zeros(1,nzeros) 0 0 0 -1 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
% angry
matlabbatch{3}.spm.stats.con.consess{24}.tcon.name = 'Angry > Neutre';
matlabbatch{3}.spm.stats.con.consess{24}.tcon.weights = [1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{24}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.name = 'Angry_Classic > Neutre_Classic';
matlabbatch{3}.spm.stats.con.consess{25}.tcon.weights = [1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{25}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.name = 'Angry_Gaze > Neutre_Gaze';
matlabbatch{3}.spm.stats.con.consess{26}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{26}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.name = 'Angry_Gaze > Angry_Classic';
matlabbatch{3}.spm.stats.con.consess{27}.tcon.weights = [-1 0 0 0 0 0 0 0 0 zeros(1,nzeros) -1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{27}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.name = 'Angry_Classic > Angry_Gaze';
matlabbatch{3}.spm.stats.con.consess{28}.tcon.weights = [1 0 0 0 0 0 0 0 0 zeros(1,nzeros) 1 0 0 0 0 0 0 0 0 zeros(1,nzeros) -1 0 0 0 0 0 0 0 0 zeros(1,nzeros) -1 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{28}.tcon.sessrep = 'none';
% inter
matlabbatch{3}.spm.stats.con.consess{29}.tcon.name = 'Inter_Neu_Emo_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{29}.tcon.weights = [-1 0 0 -1 0 0 2 0 0 zeros(1,nzeros) -1 0 0 -1 0 0 2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0 zeros(1,nzeros) 1 0 0 1 0 0 -2 0 0];
matlabbatch{3}.spm.stats.con.consess{29}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.name = 'Inter_Fear_Neu_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{30}.tcon.weights = [0 0 0 -1 0 0 1 0 0 zeros(1,nzeros) 0 0 0 -1 0 0 1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0 zeros(1,nzeros) 0 0 0 1 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{30}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.name = 'Inter_Angry_Neu_Gaze_Classic';
matlabbatch{3}.spm.stats.con.consess{31}.tcon.weights = [-1 0 0 0 0 0 1 0 0 zeros(1,nzeros) -1 0 0 0 0 0 1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0 zeros(1,nzeros) 1 0 0 0 0 0 -1 0 0];
matlabbatch{3}.spm.stats.con.consess{31}.tcon.sessrep = 'none';
%tracking task
matlabbatch{3}.spm.stats.con.consess{32}.tcon.name = 'Increasing_fix';
matlabbatch{3}.spm.stats.con.consess{32}.tcon.weights = [0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{32}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.name = 'Increasing_fix_classic';
matlabbatch{3}.spm.stats.con.consess{33}.tcon.weights = [0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{33}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.name = 'Increasing_fix_gaze';
matlabbatch{3}.spm.stats.con.consess{34}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{34}.tcon.sessrep = 'none';
% tracking emotion
%fear
matlabbatch{3}.spm.stats.con.consess{35}.tcon.name = 'Increasing_fix_fear';
matlabbatch{3}.spm.stats.con.consess{35}.tcon.weights = [0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{35}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.name = 'Increasing_fix_fear_classic';
matlabbatch{3}.spm.stats.con.consess{36}.tcon.weights = [0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{36}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{37}.tcon.name = 'Increasing_fix_fear_gaze';
matlabbatch{3}.spm.stats.con.consess{37}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0 zeros(1,nzeros) 0 0 0 0 1 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{37}.tcon.sessrep = 'none';
% anger
matlabbatch{3}.spm.stats.con.consess{38}.tcon.name = 'Increasing_fix_angry';
matlabbatch{3}.spm.stats.con.consess{38}.tcon.weights = [0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{38}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{39}.tcon.name = 'Increasing_fix_angry_classic';
matlabbatch{3}.spm.stats.con.consess{39}.tcon.weights = [0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{39}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{40}.tcon.name = 'Increasing_fix_angry_gaze';
matlabbatch{3}.spm.stats.con.consess{40}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0 zeros(1,nzeros) 0 1 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{40}.tcon.sessrep = 'none';
% neutral
matlabbatch{3}.spm.stats.con.consess{41}.tcon.name = 'Increasing_fix_neutral';
matlabbatch{3}.spm.stats.con.consess{41}.tcon.weights = [0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{41}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{42}.tcon.name = 'Increasing_fix_neutral_classic';
matlabbatch{3}.spm.stats.con.consess{42}.tcon.weights = [0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0];
matlabbatch{3}.spm.stats.con.consess{42}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{43}.tcon.name = 'Increasing_fix_neutral_gaze';
matlabbatch{3}.spm.stats.con.consess{43}.tcon.weights = [0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 0 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0 zeros(1,nzeros) 0 0 0 0 0 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{43}.tcon.sessrep = 'none';
% inter
matlabbatch{3}.spm.stats.con.consess{44}.tcon.name = 'Increasing_fix_classic-gaze';
matlabbatch{3}.spm.stats.con.consess{44}.tcon.weights = [0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 -1 0 0 -1 0 0 -1 0 zeros(1,nzeros) 0 -1 0 0 -1 0 0 -1 0];
matlabbatch{3}.spm.stats.con.consess{44}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{45}.tcon.name = 'Increasing_fix_gaze-classic';
matlabbatch{3}.spm.stats.con.consess{45}.tcon.weights = [0 -1 0 0 -1 0 0 -1 0 zeros(1,nzeros) 0 -1 0 0 -1 0 0 -1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0 zeros(1,nzeros) 0 1 0 0 1 0 0 1 0];
matlabbatch{3}.spm.stats.con.consess{45}.tcon.sessrep = 'none';

spm('defaults', 'FMRI');
spm_jobman('initcfg');
spm_jobman('run', matlabbatch);
%spm_jobman('interactive',matlabbatch);

end