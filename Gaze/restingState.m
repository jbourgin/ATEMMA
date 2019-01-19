% Displays a cross on the center of the screen until 'x' is pressed.
function restingState()

clear all;
close all;
global window;

%emotionalCategories = {'Neutral','Angry','Fear'};
UnchangingSettingsGaze;
settingsGaze;

KbQueueCreate(listDevices);
KbQueueStart(listDevices);

try
   % Start screen
	AssertOpenGL;

    % Open a double buffered fullscreen window.
    [window, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);

    [wW, wH]=WindowSize(window);
    HideCursor;

    Screen('FillRect', window, backgroundcolor);
    Screen('Flip', window);
	
	showTextToPass(Resting, 'keyboard');
	
    while 1
        Screen(window, 'FillRect', backgroundcolor);
        drawCross(wW/2,wH/2);
        Screen('Flip', window);
        
        % We wait 1 ms each loop-iteration so that we
        % don't overload the system in realtime-priority:
        WaitSecs(0.1);
        
        [~, firstPress] = KbQueueCheckWrapper(0, 'Informative');
        if firstPress(KbName('x'))
            break;
        end
    end
	
	showTextToPass(EndResting, 'keyboard');
	
	KbQueueStop(listDevices);
	sca;
    ShowCursor;
    Priority(0);
	Screen('CloseAll');

catch
	sca;
    ShowCursor;
    Priority(0);
	Screen('CloseAll');
end

end