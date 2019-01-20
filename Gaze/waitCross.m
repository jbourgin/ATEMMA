%In this function, we show a fixation cross and wait for a time
%corresponding to the timeBetweenTrials value (or until the subject looks
%at the fixation cross).
function beginCross = waitCross(centerX, centerY, eyeUsed, timeBetweenTrials, isdummy)
% beginCross -> integer. Starting time of the fixation cross presentation.
% centerX -> integer (pixel value). Horizontal coordinate of the cross center
% centerY -> integer (pixel value). Vertical coordinate of the cross center
% eyeUsed -> Got from Eyelink('EyeAvailable'). Determines which eye is recorded
% (left, right or binocular).
% timeBetweenTrials -> double. Maximum time pf fixation cross presentation allowed.
% isdummy -> boolean. True if is dummy trial, else false.

UnchangingSettingsGaze;
global window;
global el;

%Wait for fixation on cross
if dummymode == 0
    Eyelink('Message', 'starting wait for fixation period');
end

beginCross = GetSecs;

recordingTime = 0;
varFixated = 0;

%Here, we wait until the subject looks at the fixation cross during a
%sufficient time (we do not use this option in MRI).
if waitForFixation == 1
    while varFixated == 0 || GetSecs - beginCross < timeBetweenTrials
        Screen(window, 'FillRect', backgroundcolor);
        if isdummy ~= 1
            drawCross(centerX/2,centerY/2);
        end
        Screen('Flip', window);
        varLoop = 0;
        varFixated = 1;
        while varLoop < 50 && recordingTime < limitRecordingTime
            recordingTime = recordingTime + 1;
            WaitSecs(0.02);
            KbQueueCheckWrapper(0, 'Informative');
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
            else
                ShowCursor;
                [mx, my, ~]=GetMouse(window);
            end
            if abs(mx - centerX/2) <= limitDistanceGaze && abs(my - centerY/2) <= limitDistanceGaze
                varLoop = varLoop + 1;
            else
                varFixated = 0;
                break;
            end
        end

        %If the subject has not looked at the fixation cross after a
        %certain time, we consider that we may have performed a wrong
        %calibration and propose to redo it. We then call the function
        %waitCross by recursion.
        if dummymode == 0 && recordingTime >= limitRecordingTime
            Eyelink('StopRecording');
            proposeCalibration()
            Eyelink('StartRecording');
            waitCross(centerX, centerY, eyeUsed, timeBetweenTrials, isdummy)
            break;
        end
    end
%We use the option below in MRI. We just show the fixation cross during a
%fixed time.
else
    while (GetSecs - beginCross) < timeBetweenTrials
        WaitSecs(0.01);
        KbQueueCheckWrapper(0, 'Informative');
        Screen(window, 'FillRect', backgroundcolor);
        if isdummy ~= 1
            drawCross(centerX/2,centerY/2);
        end
        Screen('Flip', window);
    end
end
end
