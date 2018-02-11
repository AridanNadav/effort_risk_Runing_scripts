function [Window,wWidth, wHeight]=AA_Screen_Set_n_Open

PresentScreen = max(Screen('Screens')); 
ScreenRect = Screen(PresentScreen, 'rect'); 
%[centerX, centerY] = RectCenter(ScreenRect);

keepTrying = 1;
while keepTrying < 10
    try
%! Skipping the synchronization between Psychtoolbox and the computer's auto refresh. 

% Screen('Preference', 'SkipSyncTests', 1)
% Screen('Preference', 'SkipSyncTests', 2)

%! checking the code using a smaller window size:
%Window = Screen(PresentScreen,'OpenWindow',BackColor,[0 0 1280 1080]); 

%! full screen    
Window = Screen('OpenWindow', PresentScreen ,[80 80 80]); % Opens the screen with the chosen backcolor

% Screen ('fillRect',Window,BackColor);
Screen ('flip',Window);
Screen('TextSize',Window,60);
Screen('TextFont',Window,'Arial');

        keepTrying = 10;
    catch
        sca;
      
        keepTrying = keepTrying + 1;
        warning('CODE HAD CRASHED - Screen_Set_n_Open !');
    end
end

[wWidth, wHeight]=Screen('WindowSize', Window); % General window size
% % Setting the screen center point.
%[centerX, centerY] = RectCenter(ScreenRect);

%HideCursor;

end