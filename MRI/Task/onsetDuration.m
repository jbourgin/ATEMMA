function onsetDuration(subj, curDir)

new_durations = {10, 10, 10};
onsetDir = char(strcat(curDir, subj, '/', 'Onsets', '/'));
onsetfiles = dir(fullfile(onsetDir, '*.mat'));
onsetFilesList = [];

for a = 1:length(onsetfiles)
    disp(onsetfiles(a).name);
    onsetFilesList{a} = fullfile(onsetDir, onsetfiles(a).name);
    load(onsetFilesList{a}, 'durations', 'names', 'onsets');
    durations = new_durations;
    %for elt = 1:length(onsets)
    %    for elt2 = 1:length(onsets{elt})
    %        onsets{elt+3}(elt2,1) = onsets{elt}(elt2)+5;
    %        onsets{elt+6}(elt2,1) = onsets{elt}(elt2)+8;
    %    end
    %end
    fichier_out = sprintf('%s/onsets%sSession%i.mat', onsetDir, char(subj), a);
    save (fichier_out, 'durations', 'names', 'onsets')
end
end