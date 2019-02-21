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
        emotionalCategoriesFr{counterCategory} = 'Colère';
    elseif strcmp(elt, 'Neutral')
        emotionalCategoriesFr{counterCategory} = 'Neutre';
    end
    counterCategory = counterCategory + 1;
end

Training = 'Nous allons d''abord faire un entraînement.';

Consignes = ['Vous allez voir apparaître une croix\nà droite ou à gauche de l''écran.\n' ...
    'Vous pouvez cligner des yeux, puis\nfixez bien la croix lorsque vous êtes prêt.\n' ...
    'Vous allez ensuite voir apparaître un visage\nà l''écran pendant 5 secondes.\n' ...
    'Essayez de cligner des yeux le moins possible\nlorsque le visage est présent à l''écran.'];
	
Consignes2 = ['Vous devrez déterminer quelle émotion est représentée\nsur chaque visage à l''aide des boutons \n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n\n' ...
    'De temps en temps vous verrez apparaître\nune croix au centre de l''écran.\n' ...
    'Essayez de fixer cette croix\ntout en vous relaxant.'];

ConsignesGazeTraining = ['Vous allez voir apparaître une croix\nà droite ou à gauche de l''écran.\n' ...
    'Vous pouvez cligner des yeux, puis\nfixez bien la croix lorsque vous êtes prêt.\n' ...
    'Cette fois, vous n''allez pas voir apparaître le visage,\nmais un ovale blanc rempli de petits points noirs.\n' ...
    'Explorez l''intérieur de l''ovale\npour dévoiler les éléments du visage.'];
	
ConsignesGazeTraining2 = ['Essayez de cligner des yeux le moins possible\nlorsque l''ovale est présent à l''écran.\n' ...
    'Vous devrez déterminer quelle émotion est représentée\nsur chaque visage à l''aide des boutons \n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
    'De temps en temps vous verrez apparaître\nune croix au centre de l''écran.\n' ...
    'Essayez de fixer cette croix tout en vous relaxant.'];
    
Answer = [emotionalCategoriesFr{1},' (1) ', emotionalCategoriesFr{2} ,' (2) ou ', emotionalCategoriesFr{3} ,' (3) ?'];

EndSession = 'Merci, cette phase est terminée.';
End = 'Merci, le test est terminé.';

EndTraining = 'L''entraînement est terminé.';

EndResting = 'Merci, cette phase est terminée.';

Pause = ['PAUSE\n\n'...
         'Pour rappel, vous devez déterminer\nquelle émotion est représentée\n sur chaque visage à l''aide des boutons\n' ...
         '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n\n' ...
         'Essayez de cligner des yeux le moins possible\nlorsque le visage est présent à l''écran.'];
Pause2 = ['Lorsqu''une croix apparaît à gauche\nou à droite de l''écran, vous pouvez cligner des yeux,\npuis fixez la croix lorsque vous êtes prêt.\n' ...
         'De temps en temps vous verrez apparaître\nune croix au centre de l''écran.\n' ...
         'Essayez de fixer cette croix tout en vous relaxant.'];

Redo = 'Souhaitez-vous refaire un entraînement ?';
RedoTraining = 'Souhaitez-vous refaire un entraînement ?';
     
RedoExp = 'Appuyez sur la touche O si vous souhaitez refaire l''entraînement. Appuyez sur N pour passer au test.';
RedoExpTraining = 'Appuyez sur la touche O si vous souhaitez refaire l''entraînement. Appuyez sur N pour continuer.';

Oculo = ['Vous allez passer un test dans lequel\n' ...
    'nous allons mesurer les mouvements de vos yeux.\n\n' ...
    'Avant de commencer le test nous allons régler la caméra.\n' ...
    'Une fois la caméra installée, essayez de\n' ...
    'ne plus bouger votre tête.'];
    
Oculo2 = ['Nous allons faire quelques réglages sur la caméra\n' ...
    'pour obtenir de belles images de vos yeux.\n\n' ...
    'Evitez tout mouvement brusque pendant le test.'];

BeginTask = ['L''entraînement est terminé.\n\n' ...
    'Pour rappel, vous devez déterminer quelle émotion\n est représentée sur chaque visage à l''aide des boutons\n' ...
    '1 (',  emotionalCategoriesFr{1},') 2 (', emotionalCategoriesFr{2} ,') et 3 (', emotionalCategoriesFr{3} ,').\n' ...
    'Essayez de cligner des yeux le moins possible\nlorsque le visage est présent à l''écran.\n\n' ...
    'Lorsqu''une croix apparaît au centre de l''écran,\nessayez de vous détendre.\n\n'];

MRITestText = ['Pendant une minute avant de commencer le test,\nvous allez voir apparaître et disparaître une croix au centre de l''écran.\n\n' ...
    'Essayez de fixer cette croix tout en vous relaxant.\n\nA la fin de cette période d''une minute, un message vous annoncera le début du test.'];

CrossTask = ['Nous allons faire un dernier petit\nexercice avant de commencer.\n\n' ...
    'Chaque fois que vous verrez une croix\napparaître à gauche ou à droite de l''écran,\nfixez-la du regard.'];

CrossTaskRedo = ['Nous allons refaire cet exercice.\n\n' ...
    'Chaque fois que vous verrez une croix\napparaître à gauche ou à droite de l''écran,\nfixez-la du regard.'];