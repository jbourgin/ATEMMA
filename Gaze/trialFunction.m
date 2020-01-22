%Function called to display blocks of trials.
function [trialCounter, ListImages, count, resp, corResp] = trialFunction(Answer, emotionalCategories, emotionalCategoriesFr, trialCounter, count, ListImages, imFolder, globalTask, task, timeBetweenTrials, MRItrial, gazeVerif, randEmo, gazeInf)
% trialCounter -> int. Trial number.
% ListImages -> List of char. List of images.
% count -> matrix of doubles. A given cell is decremented when a trial of a given type (e.g., Fear-Man-Right) is performed.
% resp -> char. Response of the participant in the current trial.
% corResp -> int. Correct response of the current trial.

% Answer -> char. Text.
% emotionalCategories -> cell of char.
% imFolder -> char. Folder containing stimuli.
% globalTask -> char.
% task -> char.
% timeBetweenTrials -> double.
% MRItrial -> bool. True if the test is performed in the MRI (we wait for triggers), else false.
% gazeVerif -> bool. True if we are performing a gaze training (to check for
% the calibration accuracy).
% randEmo -> char. Facial expression, selected from the optimization sequence.

global onsets;
global window;
global el;
global wW;
global wH;
global wRect;
global outputfile;
global subID;
global numSession;

UnchangingSettingsGaze;

if gazeInf
    ImageTimeOut = 99999;
end

if strcmp('Training', task)
    responseKeys = {49, 66, 50, 89, 51, 71, 97, 98, 99};
end

%We select the image to display.
[count, indexImg, randSide, randEmo, randGender] = imageSelection(count, ListImages, emotionalCategories, randEmo);

%We determine the correct response.
if strcmp(char(emotionalCategories{1}), char(randEmo))
    corResp = 1;
elseif strcmp(char(emotionalCategories{2}), char(randEmo))
    corResp = 2;
elseif strcmp(char(emotionalCategories{3}), char(randEmo))
    corResp = 3;
end

%Read image
file = ListImages{indexImg};
%This is our alpha blending mode
%Screen(window,'BlendFunction',GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
[img,~,alpha] = imread(fullfile(imFolder,file));
%We determine the dimensions of the image.
[height,width] = size(img);
width = width/3;
copyImg = img;
copyImg(:, :, 4) = alpha;
ListImages(indexImg) = [];%Remove image from list

if dummymode == 0
    % Sending a 'TRIALID' message to mark the start of a trial.
    Eyelink('Message', 'TRIALID %s', num2str(trialCounter));

    % This supplies the title at the bottom of the eyetracker display
    Eyelink('command', 'record_status_message "TRIAL %s"', num2str(trialCounter));
end

%We put back the alpha mask by changing the corresponding pixel values for
%background color
for xNumber = 1:height
    for yNumber = 1:width
        if copyImg(xNumber,yNumber,4) == 0
            img(xNumber,yNumber,1) = backgroundcolor;
            img(xNumber,yNumber,2) = backgroundcolor;
            img(xNumber,yNumber,3) = backgroundcolor;
        end
    end
end

%Determine the coordinates according to the side of the screen on which the image will be
%displayed (the coordinates are for the cross: they correspond to
%the opposite side of the image)
%Currently, centerX corresponds to the horizontal coordinate of the cross x
%2. To change eventually (wW + (wW/4) -> wW/8*5) + change in waitCross function
centerX = 0;
if strcmp(randSide,'Left')
    centerX = wW + (wW/3);
    centerCross = round((wW/2)*(1+1/3));
    LeftImage = round((wW/2)-((wW/2)/3)-width/2);
    shiftHorizontal = (- wW)/6;
elseif strcmp(randSide,'Right')
    centerX = wW - (wW/3);
    centerCross = round((wW/2)-((wW/2)/3));
    LeftImage = round((wW/2)*(1+1/3)-width/2);
    shiftHorizontal = wW/6;
end

%The cross is displayed a little bit (value shiftY) below the vertical center of the
%screen.
centerY = wH + shiftY;

%Image texture.
imageTexture=Screen('MakeTexture',window, img);
%imageTexture2=Screen('MakeTexture',window, copyImg);

tRect=Screen('Rect', imageTexture);
[ctRect, dx, dy]=CenterRect(tRect, wRect);
dx = dx + shiftHorizontal;
ctRect(1) = ctRect(1) + shiftHorizontal;
ctRect(3) = ctRect(3) + shiftHorizontal;

if dummymode == 0
    % start recording eye position (preceded by a short pause so that
    % the tracker can finish the mode transition)
    Eyelink('Command', 'set_idle_mode');
    %WaitSecs(0.05);
    
    %Show image on tracker screen
    % clear tracker display
    Eyelink('Command', 'clear_screen %d', 0);
        
    file_split = strsplit(file,'.');
    file_no_ext = file_split{1};
    finfo = imfinfo(strcat(fullfile(imFolder,file_no_ext),'.bmp'));
    transferStatus = Eyelink('ImageTransfer',finfo.Filename,0,0,0,0,LeftImage,round(wH/2-finfo.Height/2),16);
    if transferStatus ~= 0
        fprintf('Image transfer failed');
    end
    
    WaitSecs(0.05);
    Eyelink('Command', 'draw_box %d %d %d %d 15', centerCross-24, wH/2+shiftY-24, centerCross+24, wH/2+shiftY+24);
    
    Eyelink('Command', 'set_idle_mode');
    WaitSecs(0.05);

    Eyelink('StartRecording');

    eyeUsed = Eyelink('EyeAvailable'); % get eye that's tracked
    if eyeUsed == el.BINOCULAR % if both eyes are tracked
        eyeUsed = el.LEFT_EYE; % use left eye
    end
    % record a few samples before we actually start displaying
    % otherwise you may lose a few msec of data
    WaitSecs(0.1);
else
    eyeUsed = 'None';
end

if strcmp(globalTask,'Gaze')
    % We create a Luminance+Alpha matrix for use as transparency mask:
    % Layer 1 (Luminance) is filled with 'backgroundcolor'.
    transLayer=2;
    [x,y]=meshgrid(-ms:ms, -ms:ms);
    maskblob=ones(2*ms+1, 2*ms+1, transLayer) * backgroundcolor;
    % Layer 2 (Transparency aka Alpha) is filled with gaussian transparency
    % mask.
    xsd=ms/2.2;
    ysd=ms/2.2;
    maskblob(:,:,transLayer)=round(255 - exp(-((x/xsd).^2)-((y/ysd).^2))*255);

    % Build a single transparency mask texture:
    masktex=Screen('MakeTexture', window, maskblob);
    mRect=Screen('Rect', masktex);
    
    %We find the random beginning for the grid dot
    randomX = randi([2 30], 1, 1);
    randomY = randi([2 30], 1, 1);
end

[a,b]=RectCenter(wRect);
SetMouse(a,b,screenNumber);

HideCursor;

priorityLevel=MaxPriority(window);
Priority(priorityLevel);

%Show fixation cross
startTrial = waitCross(centerX, centerY, eyeUsed, timeBetweenTrials, 0);

%We wait for the trigger
if MRItrial && MRITest
    waitingForTrigger(gazeVerif, globalTask, randEmo)
end

if dummymode == 0
    Eyelink('Message', 'stop fixation');
end

mxold=0;
myold=0;

%Show image
Screen(window, 'FillRect', backgroundcolor);
startImage = Screen('Flip', window); % Start of image showing

if dummymode == 0
    Eyelink('Message', 'start_trial %s %s at time %s', num2str(trialCounter), file, num2str(startImage));
end

% If we are in dummymode, we display the mouse cursor to simulate
% eye movement.
if strcmp(globalTask,'Gaze') && dummymode == 1
    ShowCursor;
end

while GetSecs - startImage < ImageTimeOut
    if dummymode == 0
        % Check recording status, stop display if error
        error=Eyelink('CheckRecording');
        if(error~=0)
            break;
        end
    end

    if ~strcmp(globalTask,'Gaze')
        Screen('DrawTexture', window, imageTexture, [], ctRect);
        Screen('Flip',window);
    %If we are in gaze contingent
    else
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
                        mx=-1;
                        my=-1;
                    end
                end
            end
        else
            % Query current mouse cursor position (our "pseudo-eyetracker") -
            % (mx,my) is our gaze position.
            [mx, my, ~]=GetMouse(window);
        end

        %We create the grid dot.
        emptyBck = drawGridDot(height, width, shiftHorizontal, dx, mx, dy, my, ms, randomX, randomY);

        %We create the white ellipse
        ellipseBck = drawEllipse(height, width, dx, dy, shiftHorizontal);

        ellipseTxt = Screen('MakeTexture', window, ellipseBck);

        nonfoveatex=Screen('MakeTexture', window, emptyBck);

        % We only redraw if gaze position has changed:
        if (mx~=mxold || my~=myold)
            % Compute position and size of source- and destinationrect and
            % clip it, if necessary...
            myrect=[mx-ms my-ms mx+ms+1 my+ms+1]; % center dRect on current mouseposition
            dRect = ClipRect(myrect,ctRect);
            sRect=OffsetRect(dRect, -dx, -dy);

            % Valid destination rectangle?
            if ~IsEmptyRect(dRect)
                % Yes! Draw image for current frame:

                % Step 1: Draw the alpha-mask into the backbuffer. It
                % defines the aperture for foveation: The center of gaze
                % has zero alpha value. Alpha values increase with distance from
                % center of gaze according to a gaussian function and
                % approach 255 at the border of the aperture...
                Screen('BlendFunction', window, GL_ONE, GL_ZERO);
                Screen('DrawTexture', window, masktex, [], myrect);
            end
            % Step 2: Draw peripheral image. It is only drawn where
            % the alpha-value in the backbuffer is 255 or high, leaving
            % the foveated area (low or zero alpha values) alone:
            % This is done by weighting each color value of each pixel
            % with the corresponding alpha-value in the backbuffer
            % (GL_DST_ALPHA).
            Screen('BlendFunction', window, GL_DST_ALPHA, GL_ZERO);
            Screen('DrawTexture', window, nonfoveatex, [], ctRect);

            % Step 3: Draw foveated image, but only where the
            % alpha-value in the backbuffer is zero or low: This is
            % done by weighting each color value with one minus the
            % corresponding alpha-value in the backbuffer
            % (GL_ONE_MINUS_DST_ALPHA).
            Screen('BlendFunction', window, GL_ONE_MINUS_DST_ALPHA, GL_ONE);
            Screen('DrawTexture', window, imageTexture, sRect, dRect);

            %Step 4: Show the white ellipse.
            Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
            Screen('DrawTexture', window, ellipseTxt, [], ctRect);

            vbl = Screen('Flip', window, 0, 2, 2*hurryup);
            vbl = GetSecs;
        end

        % Keep track of last gaze position:
        mxold=mx;
        myold=my;
    end

    % We wait 1 ms each loop-iteration so that we
    % don't overload the system in realtime-priority:
    WaitSecs(0.01);
    
    if gazeInf
        [pressed, firstPress] = KbQueueCheckWrapper(0, 'Informative');
        if firstPress(KbName('return'))
            waitReleaseKeys();
            break;
        end
    else
        KbQueueCheckWrapper(0, 'Informative');
    end
end

if dummymode == 0
    Eyelink('Message', 'stop image showing at time %s', num2str(GetSecs));
end

%Reset screen to display fixation cross at the beginning
Screen('BlendFunction', window, GL_ONE, GL_ZERO);
Screen(window, 'FillRect', backgroundcolor);

% Get keypress response
resp = 0;
rt = 0;
responseAlreadyRecorded = 0;
HideCursor;

startRespTime = Screen('Flip', window); % Start of trial for response
if dummymode == 0
    Eyelink('Message', 'start response screen at time %s', num2str(startRespTime));
end
while GetSecs - startRespTime <= TrialTimeOut
    WaitSecs(0.01);

    % Check for response keys
    [pressed, firstPress] = KbQueueCheckWrapper(0, 'Informative');
    if resp ~= 0
        responseText = ['Vous avez répondu ', emotionalCategoriesFr{str2double(resp)}, '.'];
        showText(responseText);
    end
    if resp == 0
        showText(Answer);
        respTime = GetSecs;

        if pressed
            for resk = 1:length(responseKeys)
                if firstPress(responseKeys{resk})
                    resp = responseKeys{resk};
                    if resp == 49 || resp == 66 || resp == 97
                        resp = '1';
                    elseif resp == 50 || resp == 89 || resp == 98
                        resp = '2';
                    elseif resp == 51 || resp == 71 || resp == 99
                        resp = '3';
                    end
                    respTime = firstPress(responseKeys{resk});
                end
            end

            if resp ~= 0
                if dummymode == 0
                    Eyelink('Message', 'The subject responded at time %s', num2str(respTime));
                end
            end
        end
    end

    % Exit loop if time out occurred. If a response is recorded (for
    %the first time only), we record it and do not leave the loop.
    if (resp ~= 0 && responseAlreadyRecorded == 0) || (respTime - startRespTime >= TrialTimeOut && responseAlreadyRecorded == 0)
        rt = respTime - startRespTime;
        if resp == 0
            resp = 'None';
        end
        %We record informations in the subject file.
        fprintf(outputfile, '%i\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %i\t %f\t %f\t %f\t %f\t %s\t \n',subID, num2str(numSession), num2str(trialCounter), char(task), char(globalTask), char(randEmo), char(randGender), char(randSide), file, resp, corResp, rt*1000, startTrial, startImage, startRespTime, num2str(respTime));
        responseAlreadyRecorded = 1;
        disp('Response time at time');
        disp(num2str(respTime));
        disp(rt);
        disp('Response');
        disp(resp);
    end

end
if dummymode == 0
    WaitSecs(0.001);
    Eyelink('Message', 'BLANK_SCREEN');
    % stop the recording of eye-movements for the current trial
    Eyelink('Message', 'Variable categories: Task, Session, GlobalTask, Emotion, Gender, Side, SubResp, CorResp, RespTime');
    Eyelink('Message', 'Variable values: %s %s %s %s %s %s %s %i %s', char(task), num2str(numSession), char(globalTask), char(randEmo), char(randGender), char(randSide), char(resp), corResp, num2str(rt*1000));
    Eyelink('Message', 'stop_trial');
    Eyelink('StopRecording');
    
    % clear tracker display
    Eyelink('Command', 'clear_screen %d', 0);
end
if gazeVerif == 0
    trialCounter = trialCounter + 1;
end
end
