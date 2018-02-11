% WithORnot_eyeTracker

 

okEyetracker = [1 0];
ask_if_want_eyetracker = input('Do you want eyetracking (1 - yes, 0 - no): ');
    while isempty(ask_if_want_eyetracker) || sum(okEyetracker == ask_if_want_eyetracker) ~=1
        disp('ERROR: input must be 1 or 0. Please try again.');
        ask_if_want_eyetracker = input('Do you want eyetracking (1 - yes, 0 - no): ');
    end
use_eyetracker=ask_if_want_eyetracker; % set to 1/0 to turn on/off eyetracker functions



