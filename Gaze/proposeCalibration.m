% Displays a text where the experimenter can choose to redo a calibration
% (c), a drift (d) or nothing (n).
function proposeCalibration()

UnchangingSettingsGaze;
global el;

while 1
    %disp(FailedFixation);
    waitReleaseKeys();
    showText(AdjCamera);
    WaitSecs(0.01);
    [pressed, firstPress] = KbQueueCheckWrapper(0, 'Informative');
    if pressed && (firstPress(KbName('c')) || firstPress(KbName('C')) || firstPress(KbName('d')) || firstPress(KbName('D')) || firstPress(KbName('n')) || firstPress(KbName('N')))
        if firstPress(KbName('c')) || firstPress(KbName('C'))
            actionRedone = 'c';
        elseif firstPress(KbName('d')) || firstPress(KbName('D'))
            actionRedone = 'd';
        elseif firstPress(KbName('n')) || firstPress(KbName('N'))
            actionRedone = 'n';
        end
        waitReleaseKeys();

        if actionRedone ~= 'n'
            if actionRedone == 'd'
                showTextToPass(Drift, 'keyboard');
                EyelinkDoDriftCorrection(el);
                Eyelink('Message', 'Drift performed');
            elseif actionRedone == 'c'
                showTextToPass(Calibration1, 'keyboard');
                showTextToPass(Calibration2, 'keyboard');
                EyelinkDoTrackerSetup(el);
                Eyelink('Message', 'Calibration redone');
            end
        else
            break;
        end
    end
end
