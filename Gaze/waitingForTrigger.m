function waitingForTrigger(gazeVerif, globalTask, randEmo)
% gazeVerif -> bool. True if we are performing a gaze training.
% globalTask -> char.
% randEmo -> char. Emotion of the current trial.

global onsets;
%We wait for the trigger.
if gazeVerif
    KbQueueCheckWrapper(1, 'gazeVerif');
else
    [~, ~, pressTrig] = KbQueueCheckWrapper(1, 'Trigger');
end
%We put the time value of the trigger (minus the time value of the
%first trigger) in a matrix, in the cell corresponding to the
%current trial condition.
if gazeVerif == 0
    if strcmp(globalTask, 'Gaze')
        if strcmp(randEmo, 'Angry')
            cellNum = 1;
        elseif strcmp(randEmo, 'Fear')
            cellNum = 2;
        elseif strcmp(randEmo, 'Neutral')
            cellNum = 3;
        end
    else
        if strcmp(randEmo, 'Angry')
            cellNum = 4;
        elseif strcmp(randEmo, 'Fear')
            cellNum = 5;
        elseif strcmp(randEmo, 'Neutral')
            cellNum = 6;
        end
    end
    onsets{cellNum}(length(onsets{cellNum})+1,1) = pressTrig;
end