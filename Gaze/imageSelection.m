function [count, indexImg, randSide, randEmo, randGender] = imageSelection(count, ListImages, emotionalCategories, stimEmo)
% count -> matrix of doubles. A given cell is decremented when a trial of a given type (e.g., Fear-Man-Right) is performed.
% indexImg -> int. Index of the image to return.
% randSide -> char. Side of the current trial.
% randEmo -> char. Emotion of the current trial.
% randGender -> char. Gender of the current trial.
% ListImages -> List of char. List of images.
% emotionalCategories -> cell of char.

UnchangingSettingsGaze;
noRandSideFound = 1;
noRandNumberFound = 1;
%We search a random image to present.
while noRandSideFound
    if strcmp(stimEmo, 'None')
        randListEmo = randperm(length(emotionalCategories));
        randEmo = emotionalCategories{randListEmo(1)};
    else
        randEmo = stimEmo;
    end
    randListGender = randperm(length(genderType));
    randGender = genderType{randListGender(1)};
    randListSide = randperm(length(sideScreen));
    randSide = sideScreen{randListSide(1)};
    emoImageIdx = find(strcmp(emotionalCategories,randEmo));
    genderImageIdx = find(strcmp(genderType,randGender));
    sideImageIdx = find(strcmp(sideScreen,randSide));
    %We decrement the matrix according to the type of trial (e.g.,
    %fear, man, right).
    if count(emoImageIdx,genderImageIdx,sideImageIdx) > 0
        count(emoImageIdx,genderImageIdx,sideImageIdx) = count(emoImageIdx,genderImageIdx,sideImageIdx) - 1;
        noRandSideFound = 0;
        %We look for a random number to finish to determine the image to display
        while noRandNumberFound
            typeToFind = strcat(randGender, '_', randEmo);
            indexImgList = find(contains(ListImages, typeToFind));
            indexImgList = indexImgList(randperm(length(indexImgList)));
            indexImg = indexImgList(1);
            noRandNumberFound = 0;
        end
    end
end
end