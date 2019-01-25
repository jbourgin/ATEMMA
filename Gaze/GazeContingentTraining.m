% Training function.
function GazeContingentTraining()

clear all;
close all;

if ~exist(['..' filesep 'Results'], 'dir')
    mkdir(['..' filesep 'Results'])
end

emotionalCategories = {'Neutral','Angry','Fear'};
% Randomize the assignement of categories to buttons
emotionalCategories = emotionalCategories(randperm(length(emotionalCategories)));

% Loads the variables required (number of subjects, images...)
UnchangingSettingsGaze;
settingsGaze;
trialCounter = 1;
timeBetweenTrials = 2;
global numSession;
numSession = 'Training';

% select subID
global subID;
subID = str2double(input('Entrez le numéro du sujet : ', 's'));
while isnan(subID) || fix(subID) ~= subID
  subID = str2double(input('Le numéro n''est pas un entier. Entrez le numéro du sujet: ', 's'));
end

%warn if duplicate sub ID
fileName=[resultsFolder '/gct' num2str(subID) '.rtf'];
baseFileName = ['/gct' num2str(subID) '.rtf'];
if length(baseFileName) > 11
    fileName = [resultsFolder '/gct999.rtf'];
    subID = 999;
end
if exist(fileName,'file')
    if ~IsOctave
        resp=questdlg({['The file ' fileName ' already exists']; 'Do you want to overwrite it?'},...
            'duplicate warning','cancel','ok','ok');
    else
        resp=input(['The file ' fileName ' already exists. Do you want to overwrite it? [Type ok for overwrite]'], 's');
    end

    if ~strcmp(resp,'ok') %abort experiment if overwriting was not confirmed
        disp('Experiment aborted');
        return
    end
end

if dummymode == 0
    % Added a dialog box to set your own EDF file name before opening
    % experiment graphics. Make sure the entered EDF file name is 1 to 8
    % characters in length and only numbers or letters are allowed.
    prompt = {'Enter tracker EDF file name (1 to 8 letters or numbers)'};
    dlgTitle = 'Create EDF file';
    numLines= 1;
    def     = {'GAZE'};
    answer  = inputdlg(prompt,dlgTitle,numLines,def);
    global edfFile;
    edfFile = answer{1};
    fprintf('EDFFile: %s\n', edfFile );
end

%Save key assignement in a file.
emotionfile = fopen([resultsFolder '/emotion' num2str(subID) '.txt'],'w');
fprintf(emotionfile, '%s\n%s\n%s\n', emotionalCategories{1}, emotionalCategories{2}, emotionalCategories{3});
fclose(emotionfile);

% Return the result file
global outputfile;
global trigfile;
outputfile = fopen([resultsFolder '/gct' num2str(subID) '.rtf'],'w');
trigfile = fopen([resultsFolder '/trigt' num2str(subID) '.rtf'],'w');
fprintf(outputfile, 'subID\t Session\t trial\t Task\t Phase\t Emotion\t Gender\t Side\t imageFile\t response\t corResp \t RT \t StartTrial \t StartImage \t StartScreenResp \t StartRespPpt \n');
fprintf(trigfile, 'Session\t startTrigger\t typeTrigger \n');
fclose(outputfile);
fclose(trigfile);
outputfile = fopen([resultsFolder '/gct' num2str(subID) '.rtf'],'a');
trigfile = fopen([resultsFolder '/trigt' num2str(subID) '.rtf'],'a');

% Initialize KbQueue, which will be used to get keyboard presses.
KbQueueCreate(listDevices);
KbQueueStart(listDevices);

try
    % Start screen
	AssertOpenGL;

    % Open a double buffered fullscreen window.
    global window;
    global wW;
    global wH;
    global wRect;
    [window, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);

    [wW, wH]=WindowSize(window);
    HideCursor;

    Screen('FillRect', window, backgroundcolor);
    Screen('Flip', window);

    showTextToPass('Appuyez sur Entrée pour commencer.', 'keyboard');

    if dummymode == 0
        showTextToPass(Oculo, 'keyboard');
		showTextToPass(Oculo2, 'keyboard');
        showTextToPass(Calibration1, 'keyboard');
		showTextToPass(Calibration2, 'keyboard');
    end

    if dummymode == 0

        % Provide Eyelink with details about the graphics environment
        % and perform some initializations. The information is returned
        % in a structure that also contains useful defaults
        % and control codes (e.g. tracker state bit and Eyelink key values).
        global el;
        el=EyelinkInitDefaults(window);

        % Initialization of the connection with the Eyelink Gazetracker.
        % exit program if this fails.
        if ~EyelinkInit(dummymode)
            fprintf('Eyelink Init aborted.\n');
            return;
        end

        % the following code is used to check the version of the eye tracker
        % and version of the host software
        sw_version = 0;

        [~, vs]=Eyelink('GetTrackerVersion');
        fprintf('Running experiment on a ''%s'' tracker.\n', vs );

        % open file to record data to
        i = Eyelink('Openfile', edfFile);
        if i~=0
            fprintf('Cannot create EDF file ''%s'' ', edffilename);
            Eyelink('Shutdown');
            Screen('CloseAll');
            return;
        end

        % SET UP TRACKER CONFIGURATION
        % Setting the proper recording resolution, proper calibration type,
        % as well as the data file content;
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, wW-1, wH-1);
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, wW-1, wH-1);
        % set calibration type.
        Eyelink('command', 'calibration_type = HV9');

        % set EDF file contents using the file_sample_data and
        % file-event_filter commands
        % set link data through link_sample_data and link_event_filter
        Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');
        Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON,INPUT');

        % check the software version
        % add "HTARGET" to record possible target data for EyeLink Remote
        if sw_version >=4
            Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,HTARGET,GAZERES,STATUS,INPUT');
            Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,HTARGET,STATUS,INPUT');
        else
            Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,HREF,AREA,GAZERES,STATUS,INPUT');
            Eyelink('command', 'link_sample_data  = LEFT,RIGHT,GAZE,GAZERES,AREA,STATUS,INPUT');
        end

        % make sure we're still connected.
        if Eyelink('IsConnected')~=1
            fprintf('not connected, clean up\n');
            Eyelink( 'Shutdown');
            Screen('CloseAll');
            return;
        end

        % Calibrate the eye tracker
        % setup the proper calibration foreground and background colors
        el.backgroundcolour = [backgroundcolor backgroundcolor backgroundcolor];
        el.calibrationtargetcolour = [0 0 0];

        % Hide the mouse cursor;
        Screen('HideCursorHelper', window);
        EyelinkDoTrackerSetup(el);

    end

    disp('Appuyez sur Entrée pour continuer.');
    showTextToPass(Consignes, 'keyboard');
    
    for numTask = 1:length(taskType)
        % TRAINING
        if numTask == 2
            disp('Appuyez sur Entrée pour continuer.');
            showTextToPass(ConsignesGazeTraining, 'keyboard');
        end
        globalTask = taskType(numTask);
        subjectWantsTraining = 1;
        while subjectWantsTraining
            task = "Training";
            TotalListTraining = initializeTrainingList();

            %Line : emotion, column : gender, 3d dimension : side.
            countSideTraining = ones(3,2,2);

            % Drift correction
            if dummymode == 0 && godMode == 2
                showTextToPass(Drift, 'keyboard');
                EyelinkDoDriftCorrection(el);
            end
            
            %We perform the training trials.
            trainingScore = 0;
            for trialNum = 1:nTrialsTraining
                [trialCounter, TotalListTraining, countSideTraining, resp, corResp] = trialFunction(Answer, emotionalCategories, trialCounter, countSideTraining, TotalListTraining, imageFolderTraining, globalTask, task, timeBetweenTrials, 0, 0, 'None');
                %We send feedback to the participant on the correctness of his response.
                Screen(window, 'FillRect', backgroundcolor);
                startFeedback = Screen('Flip', window);
                if strcmp(resp, 'None')
                    feedbackText = ['Vous n''avez pas répondu.\nLa bonne réponse était ', emotionalCategoriesFr{corResp} ,'.'];
                elseif str2double(resp) ~= corResp
                    feedbackText = ['Votre réponse était ', emotionalCategoriesFr{str2double(resp)} ,'.\nLa bonne réponse était ', emotionalCategoriesFr{corResp} ,'.'];
                elseif str2double(resp) == corResp
                    feedbackText = ['Votre réponse était ', emotionalCategoriesFr{str2double(resp)} ,'. Bonne réponse !'];
                    trainingScore = trainingScore + 1;
                end
                while GetSecs - startFeedback < 5
                    showText(feedbackText)
                end
            end
            %If we are in a training, we show the participant his
            %score. Accordingly, we will or will not redo a training.
            startFeedbackScore = Screen('Flip', window);
            feedbackScore = ['Votre score est de ', num2str(trainingScore), ' sur ' , num2str(nTrialsTraining), '.'];
            while GetSecs - startFeedbackScore < 5
                showText(feedbackScore)
            end
            
            %Proposes training redo
            disp(RedoExpTraining);
            while 1
                WaitSecs(0.01);
                showText(RedoTraining);
                [~, firstPress] = KbQueueCheckWrapper(0, 'Informative');
                if firstPress(KbName('o')) || firstPress(KbName('O'))
                    break;
                elseif firstPress(KbName('n')) || firstPress(KbName('N'))
                    subjectWantsTraining = 0;
                    waitReleaseKeys()
                    break;
                end
            end
        end
    end
    
    showTextToPass(EndTraining, 'keyboard');
    KbQueueStop(listDevices);

    if dummymode == 0
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.5);
        Eyelink('CloseFile');

        % download data file
        try
            fprintf('Receiving data file ''%s''\n', edfFile );
            status=Eyelink('ReceiveFile');
            if status > 0
                fprintf('ReceiveFile status %d\n', status);
            end
        catch
            fprintf('Problem receiving data file ''%s''\n', edfFile );
        end

        Eyelink('ShutDown');
    end

    % close the window
    sca;
    ShowCursor;
    Priority(0);
    fclose(outputfile);
    fclose(trigfile);

catch
    %this "catch" section executes in case of an error in the "try" section
    %above.  Importantly, it closes the onscreen window if its open.
    KbQueueStop(listDevices);
    if dummymode == 0
        Eyelink('ShutDown');
    end
    sca;
    ShowCursor;
    Priority(0);
    psychrethrow(psychlasterror);
    fclose(outputfile);
    fclose(trigfile);
end
end
