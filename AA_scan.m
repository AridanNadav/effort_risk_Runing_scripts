%888888888 8888888888 8888888888  d88888b   8888888b  88888888888           8888888b   8888888  d8888b   888    d8P
%88        888        888       d88P" "Y88b 888   Y88b    888               888   Y88b   888  d88P  Y88b 888   d8P
%88        888        888       888     888 888    888    888               888    888   888  Y88b       888  d8P
%888888    8888888    8888888   888     888 888   d88P    888               888   d88P   888   "Y888b    888d88K
%88        888        888       888     888 8888888P"     888   >>>>>>      8888888P"    888      "Y88b  8888888b
%88        888        888       888     888 888 T88b      888   <<<<<<      888 T88b     888        "888 888  Y88b
%88        888        888       Y88b   d88P 888  T88b     888               888  T88b    888  Y88b  d88P 888   Y88b
%888888888 888        888        "Y88888P"  888   T88b    888               888   T88b 8888888 "Y8888P"  888    Y88b

% ====================================== NADAV ARIDAN 2017 ==========================================================
% This experiment is desigend for fMRI and examines effort-risk sensitivity and effort-aversion
% Order of the experimennt:
% 1 Effort practice
%   1 1 MVC
%   1 2 perceived effort 1
%   1 3 Effort levels familiarization
%   1 4 perceived effort 2
% 2 Risk-sensitivity
% 3 Effort-sensitivity
%   ___  ___ __ _ _ __
%  / __|/ __/ _` | '_ \
%  \__ \ (_| (_| | | | |
%  |___/\___\__,_|_| |_|
%
%
%                      .@&@@@@@@@@@@@.
%                  @@@@@@@@=========@@@@@@@@*
%              @@@@@@@&  *| SIEMENS |*  &@@@@*
%           @@@@@@@# (@@@@==========@@@@) (@@@(
%        /@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@  @@@
%      ,@@@@@@@& @@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@
%     @@@@@@@@/ @@@@@@ .@@@@@@@@@@@@@@* @@@@@@ ,@@&
%    @@@@@@@@/ @@@@oo#@@@@@#        @@@@@&  @@@@ %@@,
%   @@@@@@@@@ @@@@@@@@@@@            @@@@@@@@@@@ @@@
%  &@@@@@@@@#.@@@@@@@@@@               @@@@@@@@@@ *@@
%  @@@@@@@@@ &@@@@@@@@@(    @--^--
%  @@@@@@@@@.%@@@@@@@@@%    @ :  ) \###############        ||
%  @@@@@@@@@& @@@@@@@@@@    @      |######=========E  #####||
%  @@@@@@@@@@ @@@@@@@@@@@%   \____/ \######################||
%  @@@@@@@@@@@ @@@@@@@@@@@@@_________________________________
%  @@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/
%  @@@@@@@@@@@@@ %@@@@@@@@@@@@@@@@@@@@@@@@@@&*@@@@@@(******/
%  @@@@@@@@@@@@@@@ &@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@*
%  @@@@@@@@@@@@@@@@@  &@@@@@@@@@@@@@@@@&  @@@@@@@@@@*
%  @@@@@@@@@@@@@@@@@@@@@   *@@@@@&*   @@@@@@@@@@@@@@*
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
%  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*
%  */****/*/****/*/****/******/******/******/******/.

Scanprep
callexp(Window,Instructions_struct)
%% ========================================================================
% risk sensitivity
% =========================================================================
BB_RISK_demo(risk_demolevels,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
runtype='RSK';
eye_tracker_setup
[Window,wWidth, wHeight]=AA_Screen_Set_n_Open;

for RISKruns=1:4
    [RISKrelization]=BB_RISK(Levels,RISKruns,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
    callexp(Window,Instructions_struct)
    BB_RISK_realization(study100,RISKrelization,Window,Instructions_struct)
    
end
%{
[RISKrelization]=BB_RISK(Levels,1,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
BB_RISK_realization(study100,RISKrelization,Window,Instructions_struct)

[RISKrelization]=BB_RISK(Levels,2,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
BB_RISK_realization(study100,RISKrelization,Window,Instructions_struct)

callexp(Window,Instructions_struct)
[RISKrelization]=BB_RISK(Levels,3,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
BB_RISK_realization(study100,RISKrelization,Window,Instructions_struct)

[RISKrelization]=BB_RISK(Levels,4,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
BB_RISK_realization(study100,RISKrelization,Window,Instructions_struct)

%}

%% ========================================================================
% effort sensitivity
% =========================================================================
callexp(Window,Instructions_struct)
% Effort_sensitivity_demo
BB_EFFRT_sensitivity_demo(gain_demolevels,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)

runtype='ER';
eye_tracker_setup
[Window,wWidth, wHeight]=AA_Screen_Set_n_Open;

wins=[];
for Effortsensitivity=1:4
    [gain_relization1]=BB_EFFRT_sensitivity(Levels,Effortsensitivity,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
    callexp(Window,Instructions_struct)
    [win]=BB_gain_realization(study100,gain_relization1,Window,Instructions_struct)
    wins=[wins win] ;
end
%{
% Effort_sensitivity_1
 [gain_relization1]=BB_EFFRT_sensitivity(Levels,1,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
 % Effort_sensitivity_1 realization
 BB_gain_realization(study100,gain_relization1,Window,Instructions_struct)
 
 % Effort_sensitivity_2
 [gain_relization2]=BB_EFFRT_sensitivity(Levels,2,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window,use_eyetracker);
callexp(Window,Instructions_struct)
 % Effort_sensitivity_2 realization
 BB_gain_realization(study100,gain_relization2,Window,Instructions_struct)
%}
callexp(Window,Instructions_struct)
%percieved effort 3
BB_VAS(study100,3,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)

eye_tracker_wrapup
Screen('TextSize', Window, 60);
DrawFormattedText(Window,['Thank you! you won a total of ' num2str(sum(wins)) ' NIS :)  '],wWidth/4,wHeight/3,[0 255 0]);
Screen('Flip', Window);
save([outputPath '/' subjectID '_end'])
WaitSecs(3)
sca

