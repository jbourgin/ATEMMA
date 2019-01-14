%We wait until none of the keyboard keys are pressed anymore.
function waitReleaseKeys()
while 1
    WaitSecs(0.01);
    [pressed, ~] = KbQueueCheckWrapper(0);
    if ~pressed
        break;
    end
end
end