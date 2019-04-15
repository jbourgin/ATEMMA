function onsetDuration(subject, category)

new_durations = {10, 10, 10};

workingDir = 'D:\MRI_faces\';
dataDir = char(strcat(workingDir, 'Files_ready\'));
curDir = char(strcat(dataDir, category, '\'));
onsetDir = char(strcat(curDir, subject, '\', 'Onsets', '\'));
for sess = 1:4
    onsetfile = fullfile(onsetDir, sprintf('onsets%sSession%s', char(subject), char(sess)));
    load(onsetfile, 'durations', 'names', 'onsets');

    durations = new_durations;

    fichier_out = sprintf('onsets%sSession%s.mat', char(subject), char(sess));
    save (fichier_out, 'names', 'onsets', 'durations')

end