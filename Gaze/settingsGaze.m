KbName('UnifyKeyNames');

timeBetweenTrials = 0.01; %1
timeBetweenTrialsStandard = 0.01; %1

imageFolder = ['..' filesep 'Task' filesep];
FemmeAngryList = dir(fullfile(imageFolder,['Femme_Angry*.' imageFormat]));
FemmeAngryList = {FemmeAngryList(:).name};
FemmeFearList = dir(fullfile(imageFolder,['Femme_Fear*.' imageFormat]));
FemmeFearList = {FemmeFearList(:).name};
FemmeNeutralList = dir(fullfile(imageFolder,['Femme_Neutral*.' imageFormat]));
FemmeNeutralList = {FemmeNeutralList(:).name};

HommeAngryList = dir(fullfile(imageFolder,['Homme_Angry*.' imageFormat]));
HommeAngryList = {HommeAngryList(:).name};
HommeFearList = dir(fullfile(imageFolder,['Homme_Fear*.' imageFormat]));
HommeFearList = {HommeFearList(:).name};
HommeNeutralList = dir(fullfile(imageFolder,['Homme_Neutral*.' imageFormat]));
HommeNeutralList = {HommeNeutralList(:).name};

%We get all image numbers in two lists (one for men, one for women) for
%randomization in blocks (e.g., in a same block, all emotions of man 3 must be
%seen)
ListNumberImagesH = getNumInStr(HommeNeutralList);
ListNumberImagesF = getNumInStr(FemmeNeutralList);
ListNumberImagesH = ListNumberImagesH(randperm(length(ListNumberImagesH)));%Randomization of number order
ListNumberImagesF = ListNumberImagesF(randperm(length(ListNumberImagesF)));%Randomization of number order

%We get the french names of emotions, and display them to participants when
%useful.
emotionalCategoriesFr = {0,0,0};
counterCategory = 1;
for elt = emotionalCategories
    if strcmp(elt, 'Fear')
        emotionalCategoriesFr{counterCategory} = 'Peur';
    elseif strcmp(elt, 'Angry')
        emotionalCategoriesFr{counterCategory} = 'Col�re';
    elseif strcmp(elt, 'Neutral')
        emotionalCategoriesFr{counterCategory} = 'Neutre';
    end
    counterCategory = counterCategory + 1;
end

Training = 'Nous allons d''abord faire un entra�nement.';

Consignes = ['Une croix va appara�tre sur l''�cran.\n' ...
    'Vous pouvez cligner des yeux, puis\nfixez la croix lorsque vous �tes pr�t.\n' ...
    'Vous allez ensuite voir appara�tre un visage\n�l''�cran pendant 5 secondes.\n' ...
    'Clignez des yeux le moins possible\nlorsque le visage est pr�sent �l''�cran.'];
	
Consignes2 = ['D�terminez l''�motion repr�sent�e\nsur le visage � l''aide des boutons \n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
    'Vous verrez parfois appara�tre\nune croix au centre de l''�cran.\n' ...
    'Fixez cette croix tout en vous relaxant.'];

ConsignesGazeTraining = ['Une croix va appara�tre sur l''�cran.\n' ...
    'Vous pouvez cligner des yeux, puis\nfixez la croix lorsque vous �tes pr�t.\n' ...
    'Vous n''allez pas voir appara�tre le visage,\nmais un ovale blanc rempli de points noirs.\n' ...
    'Explorez l''int�rieur de l''ovale\npour d�voiler les �l�ments du visage.'];
	
ConsignesGazeTraining2 = ['Clignez des yeux le moins possible\nlorsque l''ovale est pr�sent �l''�cran.\n' ...
    'D�terminez l''�motion exprim�e\nsur le visage �l''aide des boutons \n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
    'Vous verrez parfois appara�tre\nune croix au centre de l''�cran.\n' ...
    'Fixez cette croix tout en vous relaxant.'];
    
Answer = [emotionalCategoriesFr{1},' (1) ', emotionalCategoriesFr{2} ,' (2) ou ', emotionalCategoriesFr{3} ,' (3) ?'];

EndSession = 'Merci, cette phase est termin�e.';
End = 'Merci, le test est termin�.';

EndTraining = 'L''entra�nement est termin�.';

EndResting = 'Merci, cette phase est termin�e.';

Pause = ['PAUSE\n\n'...
         'Pour rappel, vous devez d�terminer\nquelle �motion est repr�sent�e\n sur chaque visage � l''aide des boutons\n' ...
         '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
         'Clignez des yeux le moins possible\nlorsque le visage est pr�sent � l''�cran.'];
Pause2 = ['Lorsqu''une croix appara�t �gauche\nou �droite de l''�cran, vous pouvez cligner des yeux,\npuis fixez la croix lorsque vous �tes pr�t.\n' ...
         'Vous verrez parfois appara�tre\nune croix au centre de l''�cran.\n' ...
         'Fixez cette croix\ntout en vous relaxant.'];

Redo = 'Souhaitez-vous\nrefaire un entra�nement ?\n\nNote pour l''exp�rimentateur:\nO pour oui, N pour non';
RedoTraining = 'Souhaitez-vous\nrefaire un entra�nement ?\n\nNote pour l''exp�rimentateur:\nO pour oui, N pour non';
     
RedoExp = 'Note pour l''exp�rimentateur:\nAppuyez sur la touche O\nsi vous souhaitez refaire l''entra�nement.\nAppuyez sur N pour passer au test.';
RedoExpTraining = 'Note pour l''exp�rimentateur:\nAppuyez sur la touche O\nsi vous souhaitez refaire l''entra�nement.\nAppuyez sur N pour continuer.';

Oculo = ['Vous allez passer un test dans lequel\n' ...
    'nous allons mesurer les mouvements de vos yeux.\n' ...
    'Avant de commencer le test\nnous allons r�gler la cam�ra.\n' ...
    'Une fois la cam�ra install�e, essayez de\n' ...
    'ne plus bouger votre t�te.'];
    
Oculo2 = ['Nous allons faire quelques r�glages\nsur la cam�ra pour obtenir de belles\nimages de vos yeux.\n' ...
    'Evitez tout mouvement brusque pendant le test.'];

BeginTask = ['L''entra�nement est termin�.\n\n' ...
    'Pour rappel, vous devez d�terminer quelle �motion\nest repr�sent�e sur chaque visage �l''aide des boutons\n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
    'Clignez des yeux le moins possible\nlorsque le visage est pr�sent �l''�cran.\n\n' ...
    'Lorsqu''une croix appara�t\nau centre de l''�cran,\nessayez de vous d�tendre.\n\n'];

MRITestText = ['Pendant une minute avant de commencer le test,\nvous allez voir appara�tre et dispara�tre une croix au centre de l''�cran.\n\n' ...
    'Fixez cette croix tout en vous relaxant.\n\nA la fin de cette p�riode d''une minute, un message vous annoncera le d�but du test.'];

CrossTask = ['Nous allons faire un dernier petit\nexercice avant de commencer.\n\n' ...
    'Chaque fois que vous verrez une croix\nappara�tre �gauche ou �droite de l''�cran,\nfixez-la du regard.'];

CrossTaskRedo = ['Nous allons refaire cet exercice.\n\n' ...
    'Chaque fois que vous verrez une croix\nappara�tre � gauche ou � droite de l''�cran,\nfixez-la du regard.'];