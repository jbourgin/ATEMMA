% Detects keyboard presses. Wrapper around KbQueueCheck.
function [pressed, firstPress, pressTrig] = KbQueueCheckWrapper(waitingTrigger)
% pressed -> bool. True if a key was pressed, else false.
% firstPress -> list. List of keys containing time values indicating the
% first time they were pressed since last call to KbQueueCheck. Each index
% corresponds to the ASCII value of the key.
% pressTrig -> int. Time value of the first time a trigger was sent since
% last call to KbQueueCheck.
% waitingTrigger -> boolean. True if we have to wait for the trigger to
% continue the experiment, else false.

% Loading constant variables of the experiment.
UnchangingSettingsGaze;
global firstTrig;
global window;
global trigfile;
global outputfile;
global names;
global durations;
global onsets;
global subID;
global numSession;

if waitingTrigger == 1 || waitingTrigger == 2 || waitingTrigger == 3
	disp('Waiting for trigger');

    while 1
		WaitSecs(0.001);
		% Check for response keys
		[pressed, firstPress, ~, ~, ~] = KbQueueCheck(listDevices);

        % We first determine if there was a keypress.
		if pressed
			triggerGot = 0;
            % If so, we determine if this keypress corresponds to a
            % trigger.
            for resk = 1:length(triggerKeys)
				if firstPress(KbName(triggerKeys{resk}))
					disp('We got a trigger that triggered (!) at time:');
                    disp(num2str(firstPress(KbName(triggerKeys{resk}))));
					disp(triggerKeys{resk});
					triggerGot = 1;
					break;
				end
            end
			if triggerGot
                % We record the time value of the trigger press in file
                % trigfile.
				pressTrig = firstPress(KbName(triggerKeys{resk}));
                if waitingTrigger == 1
                    fprintf(trigfile, '%i\t %f\t %s \n', numSession, pressTrig, 'Trigger');
                elseif waitingTrigger == 2
                    fprintf(trigfile, '%i\t %f\t %s \n', numSession, pressTrig, 'Dummy');
                elseif waitingTrigger == 3
                    fprintf(trigfile, '%i\t %f\t %s \n', numSession, pressTrig, 'GazeVerif');
                end
                % We record the time value of the trigger press in the edffile
                % as well.
                if dummymode == 0
					Eyelink('Message', 'MRI trigger that triggered got at time %s', num2str(pressTrig));
                end
                % If this was the first trigger, we put its time value in a
                % variable firstTrig, which will be used to calculate the
                % time between this initial trigger and the subsequent
                % ones.
                if strcmp(firstTrig, 'None') && waitingTrigger == 1
                    firstTrig = pressTrig;
                end
                pressTrig = pressTrig - firstTrig;
				break;
			end
		end
    end

% If we do not have to wait for a trigger, we just record keyboard presses
% without pausing the experiment.
else
	[pressed, firstPress, ~, ~, ~] = KbQueueCheck(listDevices);
    % If the stopkey was pressed, we determine if we really want to end
    % the experiment or not.
    if pressed && firstPress(stopkey)
		closeRespNotFound = 1;

        disp('Press 0 to end the experiment, 1 to take a picture');
        while closeRespNotFound == 1
			WaitSecs(0.01);
			[pressed2, firstPress2, ~, ~, ~] = KbQueueCheck(listDevices);
            if pressed2 && firstPress2(KbName('0'))
				closeResp = '0';
				closeRespNotFound = 0;
            elseif pressed2 && firstPress2(KbName('1'))
				closeResp = '1';
				closeRespNotFound = 0;
            end
        end
        % If 0 was pressed, we close the experiment.
        if closeResp == '0'
			KbQueueStop(listDevices);
			sca;
			ShowCursor;
			Priority(0);
            fichier_out = [resultsFolder '/onsets' num2str(subID) 'Session' num2str(numSession) '.mat'];
			save(fichier_out, 'names', 'onsets', 'durations');
            fclose(outputfile);
            fclose(trigfile);
			if dummymode == 0
                global edfFile;
				Eyelink('Command', 'set_idle_mode');
				WaitSecs(0.5);
				Eyelink('CloseFile');

				% download data file
				try
					fprintf('Receiving data file ''%s''\n', edfFile);
					status=Eyelink('ReceiveFile');
					if status > 0
						fprintf('ReceiveFile status %d\n', status);
					end
				catch
					fprintf('Problem receiving data file ''%s''\n', edfFile);
				end

				Eyelink('ShutDown');
            end
			error('Manual shut down')
		% If 1 was pressed, we just save a picture of the screen
		% and go back to the experiment.
        else
			imageArray = Screen('GetImage',window);
			imwrite(imageArray,'test.jpg')
        end
    % If a key was pressed but not the stopkey, we determine if it was a
    % trigger key.
	elseif pressed
        for resk = 1:length(triggerKeys)
            if firstPress(KbName(triggerKeys{resk}))
				disp('We got an informative trigger at time:');
                disp(num2str(firstPress(KbName(triggerKeys{resk}))));
				disp(triggerKeys{resk});
                % We write the time value of the trigger press in the
                % edffile.
                if dummymode == 0
					Eyelink('Message', 'MRI informative trigger got at time %s', num2str(firstPress(KbName(triggerKeys{resk}))));
                end
                % We write the time value of the trigger press in the
                % trigger file.
				fprintf(trigfile, '%s\t %f\t %s \n',num2str(numSession), firstPress(KbName(triggerKeys{resk})), 'Informative');
            end
        end
    end
end
end