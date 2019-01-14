% Draws a text on the screen
function showText(text)
% text -> char.

UnchangingSettingsGaze;
global window;

Screen('TextSize', window, 45);
% Draw a centered text.
DrawFormattedText(window, text, 'center', 'center',textColor,[],[],[],2);
Screen('Flip',window);

end