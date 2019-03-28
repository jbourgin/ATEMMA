% Draws a text on the screen
function showText(text)
% text -> char.

UnchangingSettingsGaze;
global window;

Screen('TextSize', window, sizeText);
Screen('TextFont', window, char(fontText));
% Draw a centered text.
DrawFormattedText(window, text, 'center', 'center',textColor,[],[],[],2);
Screen('Flip',window);

end