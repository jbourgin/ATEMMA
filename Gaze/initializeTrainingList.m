function TotalListTraining = initializeTrainingList()
% TotalListTraining -> List of char. List of images.

UnchangingSettingsGaze;
%%% Get the image files for Training. Images must contain only one .png.
FemmeAngryListTraining = dir(fullfile(imageFolderTraining,['Femme_Angry*.' imageFormat]));
FemmeAngryListTraining = {FemmeAngryListTraining(:).name};
FemmeFearListTraining = dir(fullfile(imageFolderTraining,['Femme_Fear*.' imageFormat]));
FemmeFearListTraining = {FemmeFearListTraining(:).name};
FemmeNeutralListTraining = dir(fullfile(imageFolderTraining,['Femme_Neutral*.' imageFormat]));
FemmeNeutralListTraining = {FemmeNeutralListTraining(:).name};

HommeAngryListTraining = dir(fullfile(imageFolderTraining,['Homme_Angry*.' imageFormat]));
HommeAngryListTraining = {HommeAngryListTraining(:).name};
HommeFearListTraining = dir(fullfile(imageFolderTraining,['Homme_Fear*.' imageFormat]));
HommeFearListTraining = {HommeFearListTraining(:).name};
HommeNeutralListTraining = dir(fullfile(imageFolderTraining,['Homme_Neutral*.' imageFormat]));
HommeNeutralListTraining = {HommeNeutralListTraining(:).name};
TotalListTraining = [FemmeAngryListTraining,FemmeFearListTraining,FemmeNeutralListTraining,...
    HommeAngryListTraining,HommeFearListTraining,HommeNeutralListTraining];
end