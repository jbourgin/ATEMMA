% Function dedicated to dummy trials where only a fixation cross is shown.
% These dummy phases occur regularly and are used as baseline.
function trialCounter = dummyFunction(timeBetweenTrials, task, globalTask)
% timeBetweenTrials -> double (in seconds). Inter-trial time.
% task -> char. Main task or Training.
% globalTask -> char. Gaze or Classic.

UnchangingSettingsGaze;

global onsets;
global window;
global el;
global wH;
global wW;
global wRect;
global outputfile;
global subID;
global numSession;

for dummyNum = 1:numDummy

    if dummymode == 0
        Eyelink('Message', 'DUMMY');

        % start recording eye position (preceded by a short pause so that
        % the tracker can finish the mode transition)
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.05);
        Eyelink('StartRecording');

        eyeUsed = Eyelink('EyeAvailable'); % get eye that's tracked
        if eyeUsed == el.BINOCULAR % if both eyes are tracked
            eyeUsed = el.LEFT_EYE; % use left eye
        end
        % record a few samples before we actually start displaying
        % otherwise you may lose a few msec of data
        WaitSecs(0.1);
    else
        eyeUsed = 'None';
    end

    [a,b]=RectCenter(wRect);
    SetMouse(a,b,screenNumber); % set cursor and wait for it to take effect
    HideCursor;

    priorityLevel=MaxPriority(window);
    Priority(priorityLevel);

    %Draw fixation cross. We first select its position (on the left or
    %right side of the screen).
    centerX = 0;
    listPosition = {'Left', 'Right'};
    randListPosition = randperm(length(listPosition));
    position = listPosition{randListPosition(1)};
    if strcmp(position,'Left')
        centerX = wW - (wW/2);
    elseif strcmp(position,'Right')
        centerX = wW + (wW/2);
    end
    %The cross is displayed a little bit (value shiftY) below the vertical center of the
    %screen.
    centerY = wH + shiftY;
    
    %The fixation cross is displayed.
    startTrial = waitCross(centerX, centerY, eyeUsed, timeBetweenTrials, 0);

    %If we're interested in getting triggers, we wait for the trigger before we
    %start the trial, and then put its time of apparition in a matrix.
    if MRITest
        [~, ~, pressTrig] = KbQueueCheckWrapper(1);
        %onsets{7}(length(onsets{7})+1,1) = pressTrig;
    end

    if dummymode == 0
        Eyelink('Message', 'stop dummy fixation');
    end
    
    %Show dummy
    Screen(window, 'FillRect', backgroundcolor);
    drawCross(wW/2,wH/2);
    startDummy = Screen('Flip', window); % Start of dummmy showing

    if dummymode == 0
        Eyelink('Message', 'start dummy at time %s', num2str(startDummy));
    end

    while GetSecs - startDummy < DummyTimeOut
        Screen(window, 'FillRect', backgroundcolor);
        drawCross(wW/2,wH/2);
        Screen('Flip', window);
        % We wait 1 ms each loop-iteration so that we
        % don't overload the system in realtime-priority.
        WaitSecs(0.01);
        KbQueueCheckWrapper(0);
    end


    %Reset screen to display fixation cross at the beginning
    Screen(window, 'FillRect', backgroundcolor);

    %Write trial informations in the subject file.
    fprintf(outputfile, '%i\t %i\t None\t %s\t %s\t None\t None\t None\t Dummy\t None\t None\t None\t %f\t %f\t None\t None\t \n',subID, numSession, char(task), char(globalTask), startTrial, startDummy);

    if dummymode == 0
        WaitSecs(0.001);
        % stop the recording of eye-movements for the current trial
        Eyelink('StopRecording');
        Eyelink('Message', 'stop dummy');
    end

end % main loop

end
