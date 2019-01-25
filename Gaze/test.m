% Main function.
function test()

clear all;
close all;

emotionalCategories = {'Neutral','Angry','Fear'};

% Load the variables required (number of subjects, images...)
UnchangingSettingsGaze;
settingsGaze;

trialCounter = 1;

global numSession;
numSession = 'test';
%Input subject ID
global subID;
subID = str2double(input('Entrez le numéro du sujet : ', 's'));
while isnan(subID) || fix(subID) ~= subID
  subID = str2double(input('Le numéro n''est pas un entier. Entrez le numéro du sujet: ', 's'));
end

%warn if duplicate sub ID
fileName=[resultsFolder '/gc' num2str(subID) '.rtf'];
baseFileName = ['/gc' num2str(subID) '.rtf'];
if length(baseFileName) > 11
    fileName = [resultsFolder '/gc666.rtf'];
    subID = 666;
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
    fprintf('EDFFile: %s\n', edfFile);
end

% Return the result file
global outputfile;
global trigfile;
outputfile = fopen([resultsFolder '/gc' num2str(subID) '.rtf'],'w');
trigfile = fopen([resultsFolder '/trig' num2str(subID) '.rtf'],'w');
fprintf(outputfile, 'subID\t Session\t trial\t Task\t Phase\t Emotion\t Gender\t Side\t imageFile\t response\t corResp \t RT \t StartTrial \t StartImage \t StartScreenResp \t StartRespPpt \n');
fprintf(trigfile, 'Session\t startTrigger\t typeTrigger \n');
fclose(outputfile);
fclose(trigfile);
outputfile = fopen([resultsFolder '/gc' num2str(subID) '.rtf'],'a');
trigfile = fopen([resultsFolder '/trig' num2str(subID) '.rtf'],'a');

% Initialize the matrix where will be put the onsets.
names = {'Angry-Gaze', 'Fear-Gaze', 'Neutral-Gaze', 'Angry-Classic', 'Fear-classic', 'Neutral-Classic'};
durations = {0, 0, 0, 0, 0, 0};

global onsets;
global firstTrig;
firstTrig = 'None';
onsets = {[],[],[],[],[],[]};

% Initialize KbQueue which will be used to get keyboard presses.
KbQueueCreate(listDevices);
KbQueueStart(listDevices);

try
    % Start screen
	AssertOpenGL;

    % Open a double buffered fullscreen window.
    global window;
    global wH;
    global wW;
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

    % We loop on the two conditions (Gaze and Classic)
    for numTask = 1:length(taskType)
        globalTask = taskType(numTask);
        if numTask == 1
            disp('Appuyez sur Entrée pour continuer.');
            showTextToPass(Consignes, 'keyboard');
            showTextToPass(Consignes2, 'keyboard');
        else
            disp('Appuyez sur Entrée pour continuer.');
            showTextToPass(ConsignesGazeTraining, 'keyboard');
            showTextToPass(ConsignesGazeTraining2, 'keyboard');
        end
        % MAIN TASK
        task = "Test";
        %We create the list of images for the current block
        countSide = zeros(3,2,2);
        countSide(1,1,2) = 1;
        countSide(2,2,1) = 1;
        countSide(3,2,2) = 1;
        
        ListBloc = [FemmeAngryList, FemmeFearList, HommeNeutralList];

        %We propose to redo a calibration
        HideCursor;
        if dummymode == 0
            proposeCalibration()
        % We force drift correction at each block beginning
            HideCursor;
            showTextToPass(Drift, 'keyboard');
            EyelinkDoDriftCorrection(el);
        end

        % We perform the trials for the current block.
        for numTrial = 1:3
            [trialCounter, ListBloc, countSide] = trialFunction(Answer, emotionalCategories, trialCounter, countSide, ListBloc, imageFolder, globalTask, task, timeBetweenTrials, 1, 0, 'None');
        end
    end
    
    showTextToPass(End, 'keyboard');
    KbQueueStop(listDevices);

    % Close experiment
    if dummymode == 0
        Eyelink('Command', 'set_idle_mode');
        WaitSecs(0.5);
        Eyelink('CloseFile');

        % Download data file
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

    % Close the window
    sca;
    ShowCursor;
    Priority(0);
    fichier_out = [resultsFolder '/onsets' num2str(subID) '.mat'];
    save(fichier_out, 'names', 'onsets', 'durations');
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
	fichier_out = [resultsFolder '/onsets' num2str(subID) '.mat'];
    save(fichier_out, 'names', 'onsets', 'durations');
    psychrethrow(psychlasterror);
    fclose(outputfile);
    fclose(trigfile);
end
end