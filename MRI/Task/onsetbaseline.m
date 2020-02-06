function onsetbaseline(subj, curDir)

global duration;
onsetDir = char(strcat(curDir, subj, '/', 'Onsets', '/'));
onsetfiles = dir(fullfile(onsetDir, sprintf('*%s*.mat',char(subj))));
onsetFilesList = [];
new_names = {'Angry','Fear','Neutral','Baseline'};
new_durations = {duration,duration,duration,duration};

for a = 1:length(onsetfiles)
    onsetsBaseline = [];
    disp(onsetfiles(a).name);
    onsetFilesList{a} = fullfile(onsetDir, onsetfiles(a).name);
    load(onsetFilesList{a}, 'durations', 'names', 'onsets');
    onsettest = vertcat(onsets{1},onsets{2},onsets{3});
    for i = 0:10:370
        elt_found = false(1);
        for elt = 1:length(onsettest)
            if abs(i - onsettest(elt)) < 1
                elt_found = true(1);
                break
            end
        end
        if ~elt_found
            onsetsBaseline = vertcat(onsetsBaseline,i);
        end
    end
    durations = new_durations;
    names = new_names;
    onsets{4} = onsetsBaseline;
    fichier_out = sprintf('%s/onsets%sSession%i.mat', onsetDir, char(subj), a);
    save (fichier_out, 'durations', 'names', 'onsets')
end
end