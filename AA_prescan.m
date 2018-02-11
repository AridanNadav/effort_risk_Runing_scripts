%888888888 8888888888 8888888888  d88888b   8888888b  88888888888         8888888b   8888888  d8888b   888    d8P  
%88        888        888       d88P" "Y88b 888   Y88b    888             888   Y88b   888  d88P  Y88b 888   d8P   
%88        888        888       888     888 888    888    888             888    888   888  Y88b       888  d8P    
%888888    8888888    8888888   888     888 888   d88P    888             888   d88P   888   "Y888b    888d88K     
%88        888        888       888     888 8888888P"     888   >>>>>>    8888888P"    888      "Y88b  8888888b    
%88        888        888       888     888 888 T88b      888   <<<<<<    888 T88b     888        "888 888  Y88b   
%88        888        888       Y88b   d88P 888  T88b     888             888  T88b    888  Y88b  d88P 888   Y88b  
%888888888 888        888        "Y88888P"  888   T88b    888             888   T88b 8888888 "Y8888P"  888    Y88b 
                                                                                                                     
% ====================================== NADAV ARIDAN 2017 ==========================================================
% This experiment is desigend for fMRI and operates effort-risk sensitivity and effort-aversion
% Order of the experimennt:
% 1 Effort practice
%   1 1 MVC
%   1 2 perceived effort 1
%   1 3 Effort levels familiarization
%   1 4 perceived effort 2
% 2 Risk-sensitivity 
% 3 Effort-sensitivity
%                                       
%   _ __  _ __ ___  ___  ___ __ _ _ __  
%  | '_ \| '__/ _ \/ __|/ __/ _` | '_ \ 
%  | |_) | | |  __/\__ \ (_| (_| | | | |
%  | .__/|_|  \___||___/\___\__,_|_| |_|
%  | |                                  
%  |_|                                  
%                                           :++~, =:::=:             ?NMMOOMM     
%                                     ,,:   =: ,~~==MM888$   ~MMM8888DDDNMMMM     
%                                   =~=+?? I?III=,~~=MMMMMMDD88NMMMMMMMMMMMMMN    
%                            ,:,,:,~++++??N~D88O+?+=?ZMMMMMMMMMMMMMMMMMMMMMMMM    
%                            :::~+777I?$ZMMMMMMZ?~+~=?MMMMMMMMMMMMMMMMMMMMMMMM    
%                           7DDODMMMMMMMMMMMMMM8?+=:~=+MMMMMMMMMMMMMMMMMMMMMMMN   
%                        NMMMMMMMMMMMMMMMMMMMMMM?+=~~===MMMMMMMMMMMMMMMMMMMMMMM   
%                ZMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM7?+==++?8MMMMMMMMMMMMMMMMMMMMMM   
%         ,NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM8?++=??=IMMMMMMMMM      ~MMMMMM   
%        OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMZ?==~==IMMM            ZMMMMMN   
%        ZMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMZI=~:~==8MM     :MMMMMMMMMMM     
%        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM7+~:::~+MMMMMMMMMMMM:           
%        MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM7=::::~+MMMMM+                  
%        NNNMMMMMMMMMMMMMMMMMMNMMMMMMMMMMMMMMMMMMMM7+~::::++M                      
%         NMMMMMMMMMMM      ~ONMMMMMMMMMMMMMMMMMMM7+~~:::~=MM              
%          MMMMMM           ZMMMMMMMMMMMMMMMMMMMM??~:~::::~~M                  
%          8MMMMMD   =MMNMMMMMMMMMMMMMMMMMMMM====:~~:~::::~~M                     
%           MMMMNNNNNMMMM8=DMMMMMMMMMMMMMMM=:::::::,~~::::~+N                     
%            NMNMM7      :8MMMMMMMMMMMMMM+~:~:~:,::~~~~=~+77O                     
%                        7MMMMMMMMMMMMMM7+~:::~~~~::===+?77?                      
%                        IOMMMMN$7II$+?7+=~~=~::~~~~==++I$ZI                      
%                        =??+~~~::==~~??+=~+~~=~~~~=~=+I$$7                       
%                        ~~~::=~~=~=~~++=~~==++==~===??777                        
%                        =~~:~~~=~~=~~7=+===++=~~===+?77I                         
%                        ~~~~~~~:~~++==+?====++===+=?I77                          
%                        ~~=~~~~~:~~====++=+=?~:==+?I7I                           
%                         =+=~~~~~::~==~~~+=~====+?I7I                            
%                         =+?+=~~~~=~~~:~::~:+=+++?7I                             
%                         =?++=~~~:::~~~~~~~~==++?77                              
%                          ~+=~::~=::~~~:::~++~=??O=                              
%                          :~~:~~:::~:~~~:~~~~==+$O                               
%                          :~~~~~::,::~~~~=~::~~?OI                               
%                          ,:~~~:::~~~~~~~~:~~=~+O?                               
                                   

% run from ***/RISK1/Runing_scripts

%% dynamometer check
% dynocheck = questdlg('Do you want to perform a dynamometer check?:','dynocheck','Yes','No','Yes');
% if strcmp(dynocheck,'Yes')
[SR] = dyno_check();
% end

%%  pre_run_settings_and_personal_details

[Exp_path,outputPath,subjectID,Instructions_struct] = pre_run_settings_and_personal_details;


%% screen and introduction instruction

% open screen 
[Window,wWidth,wHeight]=AA_Screen_Set_n_Open;

% introduction instruction
introduction = find(strcmp({Instructions_struct.name}, ['introduction' '.jpg'])==1);
Screen('PutImage',Window,Instructions_struct(introduction).image);
Screen(Window,'Flip');
WaitSecs(2);
wait4key % wait for any key press to continue

%% ========================================================================
% MVC - get participant's Maximal Volentary Contraction
% =========================================================================


[study100,daqBase]=BB_MVC(subjectID,Window,Instructions_struct,SR,outputPath);
%% ========================================================================
% perceived effort 1
% =========================================================================
BB_VAS(study100,1,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
for gogo=1:2
%% training ========================================================================
callexp(Window,Instructions_struct)
BB_training(study100,gogo,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
%% perceived effort ========================================================================
BB_VAS(study100,gogo+1,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
    
end
%{

 %% ========================================================================
%  Effort levels familiarization
% =========================================================================
callexp(Window,Instructions_struct)
BB_training(study100,1,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)
%% ========================================================================
% perceived effort 2
% =========================================================================

BB_VAS(study100,2,outputPath,subjectID,wWidth,wHeight,Instructions_struct,Window)

%}
%% save vars for scan

save([outputPath '/' subjectID '_scanprep.mat'],'study100','Instructions_struct')

sca