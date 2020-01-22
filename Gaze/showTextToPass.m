% Uses the showText function. Text must be passed by pressing the return key
% or clicking on the mouse.
function showTextToPass(text,stopsignal)
% text -> char.
% stopsignal -> char. Keyboard or mouse.

UnchangingSettingsGaze;
global window;

while 1
    showText(text);
    WaitSecs(0.01);
    
    if strcmp(stopsignal, 'keyboard')
        [~, firstPress] = KbQueueCheckWrapper(0, 'Informative');
        if firstPress(KbName('return'))
            waitReleaseKeys();
            break;
        end
    elseif strcmp(stopsignal, 'mouse')
        [~, ~, buttons]=GetMouse(window);
        [~, ~] = KbQueueCheckWrapper(0, 'Informative');
        if any(buttons)
            while 2
                WaitSecs(0.01);
                [~, ~] = KbQueueCheckWrapper(0, 'Informative');
                [~, ~, buttons]=GetMouse(window);
                if ~any(buttons)
                    break;
                end
            end
            break;
        end
    end
end

end