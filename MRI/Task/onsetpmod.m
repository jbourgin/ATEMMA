function onsetpmod(subj, curDir, gazeprocess)

global dataDir;

onsetDir = char(strcat(curDir, subj, '/', 'Onsets', '/'));
onsetfiles = dir(fullfile(onsetDir, sprintf('*%s*.mat',char(subj))));
onsetFilesList = [];
csvfile = readtable(strcat(dataDir, 'para_modul.csv'));

for a = 1:length(onsetfiles)
    responseVector = {[],[],[]};
    eyeVector = {[],[],[]};
    for elt = 1:length(csvfile.Subject)
        if strcmp(char(subj), csvfile.Subject(elt)) && csvfile.Session(elt) == a
            if strcmp('Angry',csvfile.Emotion(elt))
                responseVector{1}(end+1) = csvfile.BR(elt);
                eyeVector{1}(end+1) = csvfile.First_time_corrected(elt);
            elseif strcmp('Fear',csvfile.Emotion(elt))
                responseVector{2}(end+1) = csvfile.BR(elt);
                eyeVector{2}(end+1) = csvfile.First_time_corrected(elt);
            elseif strcmp('Neutral',csvfile.Emotion(elt))
                responseVector{3}(end+1) = csvfile.BR(elt);
                eyeVector{3}(end+1) = csvfile.First_time_corrected(elt);
            end
        end
    end
    disp(onsetfiles(a).name);
    onsetFilesList{a} = fullfile(onsetDir, onsetfiles(a).name);
    load(onsetFilesList{a}, 'durations', 'names', 'onsets');
    pmod = struct('name',{''},'param',{},'poly',{});
    if gazeprocess
        for cond = 1:3
            pmod(cond).name{1} = 'time_eyes';
            pmod(cond).poly{1} = 1;
            pmod(cond).param{1} = eyeVector{cond};
            pmod(cond).name{2} = 'response';
            pmod(cond).poly{2} = 1;
            pmod(cond).param{2} = responseVector{cond};
        end
    else
        for cond = 1:3
            pmod(cond).name{1} = 'response';
            pmod(cond).poly{1} = 1;
            pmod(cond).param{1} = responseVector{cond};
        end
    end
    fichier_out = sprintf('%s/onsets%sSession%i.mat', onsetDir, char(subj), a);
    save (fichier_out, 'durations', 'names', 'onsets', 'pmod')
end
end