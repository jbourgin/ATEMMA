function [timeNecessary] = waitCrossExercise(eyeUsed)
%timeNecessary -> double. Time necessary for the participant to look at the
%fixation cross.
%eyeUsed -> integer.

UnchangingSettingsGaze;
global window;
global el;
global wH;
global wW;

%Wait for fixation on cross
if dummymode == 0
    Eyelink('Message', 'starting wait for fixation period');
end
recordingTime = 0;
varFixated = 0;
centerX = 0;

%We select the position of the cross.
listPosition = {'Left', 'Right'};
randListPosition = randperm(length(listPosition));
position = listPosition{randListPosition(1)};
if strcmp(position,'Left')
    centerX = wW - (wW/2);
elseif strcmp(position,'Right')
    centerX = wW + (wW/2);
end

beginCross = GetSecs;
while varFixated == 0
    WaitSecs(0.01);
    KbQueueCheckWrapper(0, 'Informative');
    Screen(window, 'FillRect', backgroundcolor);
    drawCross(centerX/2,wH/2);
    Screen('Flip', window);
    varLoop = 0;
    varFixated = 1;
    while varLoop < 50
        recordingTime = recordingTime + 1;
        WaitSecs(0.02);
        if dummymode == 0
            if Eyelink( 'NewFloatSampleAvailable') > 0
                % get the sample in the form of an event structure
                evt = Eyelink( 'NewestFloatSample');
                if eyeUsed ~= -1 % do we know which eye to use yet?
                    % if we do, get current gaze position from sample
                    x = evt.gx(eyeUsed+1); % +1 as we're accessing MATLAB array
                    y = evt.gy(eyeUsed+1);
                    % do we have valid data and is the pupil visible?
                    if x~=el.MISSING_DATA && y~=el.MISSING_DATA && evt.pa(eyeUsed+1)>0
                        mx=x;
                        my=y;
                    else
                        mx = -1;
                        my = -1;
                    end
                end
            end
        %simulation with mouse
        else
            ShowCursor;
            [mx, my, ~]=GetMouse(window);
        end
        %We increment varLoop if the participant's gaze is close enough to
        %the screen center.
        if abs(mx - centerX/2) <= limitDistanceGaze && abs(my - wH/2) <= limitDistanceGaze
            varLoop = varLoop + 1;
        else
            varFixated = 0;
            break;
        end          
    end
end 
timeNecessary = GetSecs - beginCross;
end