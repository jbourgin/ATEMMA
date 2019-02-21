% Main function.
function GazeContingentFace()

clear all;
close all;

%emotionOrder = 0;
if ~exist(['..' filesep 'Results'], 'dir')
    mkdir(['..' filesep 'Results'])
end

%Input subject ID
global subID;
subID = str2double(input('Entrez le numéro du sujet : ', 's'));
while isnan(subID) || fix(subID) ~= subID
  subID = str2double(input('Le numéro n''est pas un entier. Entrez le numéro du sujet: ', 's'));
end

%Input session number
global numSession;
numSession = str2double(input('Entrez le numéro de session (1, 2, 3 ou 4): ', 's'));
onsetfilename = ['..' filesep 'Results' filesep 'onsets' num2str(subID) 'Session' num2str(numSession) '.mat'];
while exist(onsetfilename, 'file') || isnan(numSession) || fix(numSession) ~= numSession  || numSession > 4 %(floor(log10(numSession)) + 1) ~= 1
    numSession = str2double(input('Le numéro n''est pas un entier ou est trop élevé ou la session existe déjà pour ce sujet. Entrez le numéro de session: ', 's'));
    onsetfilename = ['..' filesep 'Results' filesep 'onsets' num2str(subID) 'Session' num2str(numSession) '.mat'];
end

%If we have done a training where each response was already assigned to a
%given key, we get back this assignement and apply it to the main task.
emotionalCategoriesFound = 0;
emotionfilename = ['..' filesep 'Results' filesep 'emotion' num2str(subID) '.txt'];
if exist(emotionfilename, 'file')
    emotionfile = importdata(emotionfilename, '\n');
    emotionalCategories = {emotionfile{1}, emotionfile{2}, emotionfile{3}};
elseif numSession == 1
    emotionalCategories = {'Neutral','Angry','Fear'};
    % Randomize the assignement of categories to buttons
    emotionalCategories = emotionalCategories(randperm(length(emotionalCategories)));
    %Save key assignement in a file.
    emotionfile = fopen(['..' filesep 'Results' filesep 'emotion' num2str(subID) '.txt'],'w');
    fprintf(emotionfile, '%s\n%s\n%s\n', emotionalCategories{1}, emotionalCategories{2}, emotionalCategories{3});
    fclose(emotionfile);
else
    disp('Il y a un problème : nous sommes après la première session et le participant n''a pas de touches fixes assignées aux émotions !')
end

%If we have done sessions before this one, we get the numbers of the images
%already displayed, in order to not redisplay them.
ImageFileMatrixF = [];
ImageFileMatrixH = [];
OptiMatrix = [];
if numSession > 1
    ImageFilenameF = ['..' filesep 'Results' filesep 'images' num2str(subID) 'Female.txt'];
    ImageFilenameH = ['..' filesep 'Results' filesep 'images' num2str(subID) 'Male.txt'];
    ImageFilesF = importdata(ImageFilenameF, '\n');
    ImageFilesH = importdata(ImageFilenameH, '\n');
    for elt = 1:length(ImageFilesF)
        ImageFileMatrixF(length(ImageFileMatrixF)+1,1) = ImageFilesF(elt);
    end
    for elt = 1:length(ImageFilesH)
        ImageFileMatrixH(length(ImageFileMatrixH)+1,1) = ImageFilesH(elt);
    end
    Optimizationfile = ['..' filesep 'Results' filesep 'optimization' num2str(subID) '.txt'];
    OptimizationSeq = importdata(Optimizationfile, '\n');
    for elt = 1:length(OptimizationSeq)
        OptiMatrix(length(OptiMatrix)+1) = OptimizationSeq(elt);
    end
    currentSeq = OptiMatrix(numSession);
end

% Load the variables required (number of subjects, images...)
UnchangingSettingsGaze;
settingsGaze;

trialCounter = 1;

%warn if duplicate sub ID
fileName=[resultsFolder '/gc' num2str(subID) '.rtf'];
baseFileName = ['/gc' num2str(subID) '.rtf'];
if length(baseFileName) > 11
    fileName = [resultsFolder '/gc666.rtf'];
    subID = 666;
end
if numSession == 1
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
if numSession == 1
    outputfile = fopen([resultsFolder '/gc' num2str(subID) '.rtf'],'w');
    trigfile = fopen([resultsFolder '/trig' num2str(subID) '.rtf'],'w');
    ImageFileF = fopen([resultsFolder '/images' num2str(subID) 'Female.txt'],'w');
    ImageFileH = fopen([resultsFolder '/images' num2str(subID) 'Male.txt'],'w');
    fprintf(trigfile, 'Session\t startTrigger\t typeTrigger \n');
    %fprintf(ImageFileF, 'Session\t Image \n');
    %fprintf(ImageFileH, 'Session\t Image \n');
    fclose(trigfile);
    fclose(ImageFileF);
    fclose(ImageFileH);
    randOptimization = OptimizationOrder(randperm(length(OptimizationOrder)));
    currentSeq = randOptimization(1);
    Optimizationfile = fopen(['..' filesep 'Results' filesep 'optimization' num2str(subID) '.txt'],'w');
    for elt = randOptimization
        fprintf(Optimizationfile, '%s \n', num2str(elt));
    end
    fclose(Optimizationfile);
end
trigfile = fopen([resultsFolder '/trig' num2str(subID) '.rtf'],'a');

%Selects condition presentation sequence
optiSeq = VariableTrialValues{currentSeq};

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
    
    % Disable all visual alerts
    Screen('Preference', 'VisualDebugLevel', 0);
    Screen('Preference', 'SkipSyncTests', 0);
    
    [window, wRect]=Screen('OpenWindow',screenNumber, 0,[],32,2);
        
    [wW, wH]=WindowSize(window);
    HideCursor;
    
    if numSession == 1
        fprintf(outputfile, 'coordinates screen: %d\t %d \n', wW, wH);
        fprintf(outputfile, 'subID\t Session\t Trial\t Task\t Phase\t Emotion\t Gender\t Side\t imageFile\t response\t corResp \t RT \t StartTrial \t StartImage \t StartScreenResp \t StartRespPpt \n');
        fclose(outputfile);
    end
    outputfile = fopen([resultsFolder '/gc' num2str(subID) '.rtf'],'a');

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
    %for numTask = 1:length(taskType)
    if godMode == 0 || godMode == 2
        if numSession < 3
            disp('Appuyez sur Entrée pour continuer.');
            showTextToPass(Consignes, 'keyboard');
            showTextToPass(Consignes2, 'keyboard');
            globalTask = taskType(1);
        else
            disp('Appuyez sur Entrée pour continuer.');
            showTextToPass(ConsignesGazeTraining, 'keyboard');
            showTextToPass(ConsignesGazeTraining2, 'keyboard');
            globalTask = taskType(2);
        end
    end
    % MAIN TASK
    task = "Main";
    %We create the list of images for the current block
    for numBloc = 1:numBlocks
        countSide = ones(3,2,2);
        countSide(:,:,:) = countSide(:,:,:) + 1;

        ListBloc = {};
        ListNumberFOk = [];
        ListNumberHOk = [];
        for elt = 1:length(ListNumberImagesF)
            if ~ismember(ListNumberImagesF(elt), ImageFileMatrixF)
                ListNumberFOk(length(ListNumberFOk)+1) = ListNumberImagesF(elt);
            end
        end
        for elt = 1:length(ListNumberImagesH)
            if ~ismember(ListNumberImagesH(elt), ImageFileMatrixH)
                ListNumberHOk(length(ListNumberHOk)+1) = ListNumberImagesH(elt);
            end
        end
        for elt = 1:((nTrialsPerBlock-numTrialDummies)/(length(genderType)*length(emotionalCategories)))
            numImageF = ListNumberFOk(elt);
            numImageH = ListNumberHOk(elt);
            imgNameAngryF = strcat('Femme','_','Angry',num2str(numImageF),'.png');
            imgNameFearF = strcat('Femme','_','Fear',num2str(numImageF),'.png');
            imgNameNeutralF = strcat('Femme','_','Neutral',num2str(numImageF),'.png');
            imgNameAngryH = strcat('Homme','_','Angry',num2str(numImageH),'.png');
            imgNameFearH = strcat('Homme','_','Fear',num2str(numImageH),'.png');
            imgNameNeutralH = strcat('Homme','_','Neutral',num2str(numImageH),'.png');
            ListBloc = [ListBloc,imgNameAngryF,imgNameFearF,imgNameNeutralF,imgNameAngryH,imgNameFearH,imgNameNeutralH];
        end

        %We propose to redo a calibration
        HideCursor;
        %For the gaze task, we first make sure that the camera is correctly
        %calibrated on the participant's gaze.
        if strcmp(globalTask, taskType(2)) && dummymode == 0 && godMode == 2
            calibrationNotOk = 1;
            TotalListTraining = initializeTrainingList();
            while calibrationNotOk
                showTextToPass(TestGaze, 'keyboard');
                showTextToPass(TestGaze2, 'keyboard');
                fakeCountSide = ones(3,2,2);
                trialFunction(Answer, emotionalCategories, emotionalCategoriesFr, 'GazeVerif', fakeCountSide, TotalListTraining, imageFolderTraining, globalTask, 'Training', timeBetweenTrials, 1, 1, 'None');
                proposeCalibration()
                disp(RedoGazeTest);
                while 1
                    WaitSecs(0.01);
                    [pressed, firstPress] = KbQueueCheckWrapper(0, 'Informative');
                    if pressed
                        if firstPress(KbName('n')) || firstPress(KbName('N'))
                            calibrationNotOk = 0;
                            break;
                        elseif firstPress(KbName('o')) || firstPress(KbName('O'))
                            break;
                        end
                    end
                end
            end
        end
        if dummymode == 0 && godMode == 2 && strcmp(globalTask, taskType(1))
            proposeCalibration()
        end
        if dummymode == 0 && godMode == 2
            % We force drift correction at each block beginning
            HideCursor;
            showTextToPass(Drift, 'keyboard');
            EyelinkDoDriftCorrection(el);
        end
        for dummyScan = 1:numDummyScans
            showText(waitingDummies);
            KbQueueCheckWrapper(1, 'Dummy');
        end

        % We perform the trials for the current block.
        for trialNum = 1:nTrialsPerBlock
            %{
            trialDone = 0;
            %We choose between a dummy and an experimental trial.
            if numTrialDummies > 0 && trialNum > 1
                possibleTrial = {'Dummy', 'Exp', 'Exp', 'Exp'};
                randListTrial = randperm(length(possibleTrial));
                randTrial = possibleTrial{randListTrial(1)};
                if strcmp(randTrial, 'Dummy')
                    dummyFunction(timeBetweenTrials, task, globalTask);
                    numTrialDummies = numTrialDummies - 1;
                    trialDone = 1;
                elseif strcmp(randTrial, 'Exp') && (trialNum+numTrialDummies)>nTrialsPerBlock
                    dummyFunction(timeBetweenTrials, task, globalTask);
                    numTrialDummies = numTrialDummies - 1;
                    trialDone = 1;
                end
            end
            if ~trialDone
                [trialCounter, ListBloc, countSide] = trialFunction(Answer, emotionalCategories, emotionalCategoriesFr, trialCounter, countSide, ListBloc, imageFolder, globalTask, task, timeBetweenTrials, 1, 0);
            end
            %}
            if strcmp(optiSeq{trialNum}, 'Dummy')
                dummyFunction(timeBetweenTrials, task, globalTask);
            else
                [trialCounter, ListBloc, countSide] = trialFunction(Answer, emotionalCategories, emotionalCategoriesFr, trialCounter, countSide, ListBloc, imageFolder, globalTask, task, timeBetweenTrials, 1, 0, optiSeq{trialNum});
            end
        end
        %After the experimental trials, we send the dummy ones (cross fixation
        %at the center of the screen).
        for dummyNum = 1:numDummy
            dummyFunction(timeBetweenTrials, task, globalTask);
        end
    end
    
    %We remove the numbers used in the current block from the list of possible images
    ImageFileF = fopen([resultsFolder '/images' num2str(subID) 'Female.txt'],'a');
    ImageFileH = fopen([resultsFolder '/images' num2str(subID) 'Male.txt'],'a');
    for indexImg = ((nTrialsPerBlock-numTrialDummies)/(length(genderType)*length(emotionalCategories))):-1:1 % To correct for last block (error matrix index)
        fprintf(ImageFileF, '%s \n', num2str(ListNumberFOk(indexImg)));
        fprintf(ImageFileH, '%s \n', num2str(ListNumberHOk(indexImg)));
    end
    fclose(ImageFileF);
    fclose(ImageFileH);

    if numSession < 4
        showTextToPass(EndSession, 'keyboard');
    else
        showTextToPass(End, 'keyboard');
    end
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
    fichier_out = [resultsFolder '/onsets' num2str(subID) 'Session' num2str(numSession) '.mat'];
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
	fichier_out = [resultsFolder '/onsets' num2str(subID) 'Session' num2str(numSession) '.mat'];
    save(fichier_out, 'names', 'onsets', 'durations');
    psychrethrow(psychlasterror);
    fclose(outputfile);
    fclose(trigfile);
end
end
