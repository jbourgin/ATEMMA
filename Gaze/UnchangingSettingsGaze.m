dummymode = 1;%1 : mouse; 0 : eye-tracking
waitForFixation = 0;
godMode = 2; %0 : with several MRI scans (instructions passed with keyboard or mouse); 1 : one scan only and instructions passed after a timeout; 2 : 0 + eyetracking options (recalibration, drift)
MRITest = 1; %0 : no MRI; 1 : MRI (we wait for triggers).
classicSessions = [1,2];
gazeSessions = [3,4];

numDummy = 2; %number of dummy trials per minibloc
DummyTimeOut = 8; %time duration of each dummy trial
TrialDuration = 10; %time duration of a full trial (fixation cross + stimulus + response screen)
ImageTimeOut = 5; %time duration of stimulus presentation
shiftY = 150; %value added to vertical center of the screen, used to shift the fixation cross below this center.

resultsFolder = [ '..' filesep 'Results'];

listDevices = []; %list of keyboard devices. Do not need necessarily to be filled.

triggerKeys = {'=+', '+', '5', 't', 'T'}; %list of trigger keys that may be sent from the MRI to the Matlab computer.

limitRecordingTime = 350; %See waitCross function. Time during which we will wait until the subject looks at the fixation cross.
limitDistanceGaze = 80; %See waitCross function. Maximum distance authorized to consider that the subject looks close enough to the center of the fixation cross.

% Set hurryup = 1 for benchmarking - Syncing to retrace is disabled
% in that case so we'll get the maximum refresh rate.
hurryup=0;

%Screen selection
nbScreen = Screen('Screens');
if max(size(nbScreen) > 1)
    screenNumber = max(nbScreen);
    mainScreen = min(nbScreen);
    mono = 0;
else
    screenNumber = min(nbScreen);
    mono = 1;
end

%Background and text color
black=BlackIndex(screenNumber);
gray=GrayIndex(screenNumber);
backgroundcolor = gray;
textColor = black;

decHeightScreen = 6; %Value used for ellipse computation

numBlocks = 1; %number of blocks per session
nTrialsPerBlock = 24; %number of trials per block
nTrialsPerMiniBloc = 4; %number of trials per mini bloc.

%Ellipse and stimulus dimensions.
heightEllipse = 470;
widthEllipse = 361;
heightImage = 517;
widthImage = 401;

% Response keys in ASCII values.
responseKeys = {49, 66, 50, 89, 51, 71};

%Independent variables values.
genderType = {'Homme','Femme'};
sideScreen = {'Left','Right'};
taskType = {'Classic','Gaze'};

% Number of trials to show before a break (for no breaks, choose a number
% greater than the number of trials in your experiment)
breakAfterTrials = nTrialsPerBlock;

%aperture size (for gaze contingent condition)
ms = 80; %70

%KbName('UnifyKeyNames');
stopkey=KbName('q'); %Key used to pause the experiment, and possibly quit.

%Texts used throughout the experiment.
FailedFixation = 'Souhaitez-vous refaire une calibration ou un drift ? Appuyez sur C pour calibration, sur D pour drift, sur N pour ne rien faire.';

AdjCamera = 'L''expérimentateur va procéder à quelques ajustements.\nMerci de patienter.';

CloseText = 'Do you want to quit the experiment ? Press 0 to confirm, 1 to cancel.';

DummyText = ['ATTENTION, nous allons passer au test.\n\n' ...
    'Fixez la croix qui va apparaître, puis déterminez l''émotion exprimée par le visage.'];

Drift = 'Fixez le point qui va apparaître sans cligner des yeux.';

Resting = ['Nous allons vous demander de garder\n' ...
    'les yeux ouverts et de regarder une croix au centre\n' ...
    'de l''écran pendant quelques minutes.\n' ...
    'Essayez de vous relaxer.'];

Calibration1 = ['Nous allons procéder à une phase de calibration.\n\n' ...
    'Vous devrez suivre un point blanc qui apparaîtra au centre de l''écran,\n' ...
    'puis dans différentes positions sur l''écran.\n' ...
    'Suivez ce point sans cligner des yeux et sans anticiper sa position.'];

Calibration2 = ['Fixez bien le point jusqu''à ce qu''il disparaisse\n' ...
    'et apparaisse à un autre emplacement.\n\n' ...
    'Une fois la calibration terminée, il vous faudra\n' ...
    'garder la tête immobile pendant le test.'];