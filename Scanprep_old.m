
%% AA_EVA5_Scan

%% get beforeScan_exp_parameters

% essential for randomization
rng('shuffle');

% set the path
splitpath = strsplit(pwd,'/');
splitpath_folder=[splitpath(1:end-1)];
%experiment folders paths
Exp_path=strjoin(splitpath_folder,'/');
outputPath = [Exp_path '/Output'];
Instructions_path = [Exp_path '/Instructions'];
onsets_path = [Exp_path '/Onset_files'];

% % % % Subject code
% % % subNUM = inputdlg ('Subject number (6__): ','subNUM',1);
% % % [subNUM_num,okID]=str2num(subNUM{1});
% % % while okID==0
% % %     warning(' Subject code must contain 3 characters numeric ending, e.g "601". Please try again.');
% % %     subNUM = input('Subject number (6__):','s');
% % %     [subNUM_num,okID]=str2num(subNUM(end-2:end));
% % % end
% % % 
% % % subjectID=['RISK1_' subNUM{1}];
% % % 
% % % load([outputPath '/' subjectID '_scanprep.mat'])
%% set effort and risk levels
alllevelsVEC=[];

sanityE=[38,62];
sanityE=sort(repmat(sanityE,1,4));
sanityR=[8,16];
sanityR=(repmat(sanityR,1,4));

nosanityLevels=(32:4:70);
RiskLevels=(11:2:29);

alllevelsVEC(1,:)=[sort(repmat(nosanityLevels,1,10)) sanityE];
alllevelsVEC(2,:)=[repmat(RiskLevels,1,10) sanityR];
alllevelsVEC(3,:)=[zeros(1,length(repmat(nosanityLevels,1,10))) repmat([1 0 0 1],1,2)];%index whether sain chice should be the risk one

alllevelsVEC1=Shuffle(alllevelsVEC,1);
alllevelsVEC2=Shuffle(alllevelsVEC,1);

Levels.risk(1).effort=alllevelsVEC1(1,1:end/2);
Levels.risk(1).risk=alllevelsVEC1(2,1:end/2);
Levels.risk(2).effort=alllevelsVEC1(1,end/2+1:end);
Levels.risk(2).risk=alllevelsVEC1(2,end/2+1:end);
Levels.risk(3).effort=alllevelsVEC2(1,1:end/2);
Levels.risk(3).risk=alllevelsVEC2(2,1:end/2);
Levels.risk(4).effort=alllevelsVEC2(1,end/2+1:end);
Levels.risk(4).risk=alllevelsVEC2(2,end/2+1:end);
Levels.risk(1).sanity_chooseRISK=alllevelsVEC1(3,1:end/2);
Levels.risk(2).sanity_chooseRISK=alllevelsVEC1(3,end/2+1:end);
Levels.risk(3).sanity_chooseRISK=alllevelsVEC2(3,1:end/2);
Levels.risk(4).sanity_chooseRISK=alllevelsVEC2(3,end/2+1:end);


%%%%%%%%%% for demo %%%%%%%%%%%%%%%
effortLevels_Shuffled=Shuffle(nosanityLevels);
RiskLevels_Shuffled=Shuffle(RiskLevels);
demoeffortLevels_Shuffled =Shuffle(effortLevels_Shuffled)/100;
demoRiskLevels_Shuffled =Shuffle(RiskLevels_Shuffled)/100;
risk_demolevels(1,:)= demoeffortLevels_Shuffled(1:5);
risk_demolevels(2,:)= demoRiskLevels_Shuffled(1:5);
%% set effort and value levels

alllevelsVEC=[];
effort_LVLs=(30:15:90);
Gain_LVLs=(1:0.5:3);

sanity=[30,1.5,30,2.5;70,1.5,70,2.5;70,1.5,30,1.5;70,2.5,30,2.5];
sanityE=ones(1,4);

alllevelsVEC(1,:)=[sort(repmat(effort_LVLs,1,10)) sanityE  ];
alllevelsVEC(2,:)=[repmat(Gain_LVLs,1,10) sanityE ];



for gain=1:4
SHUFalllevelsVEC=Shuffle(alllevelsVEC,1);
Levels.gain(gain).effort=SHUFalllevelsVEC(1,:);
Levels.gain(gain).gain=SHUFalllevelsVEC(2,:);    
Levels.gain(gain).sanity=Shuffle(sanity ,2);
    
end

%{
SHUFalllevelsVEC=Shuffle(alllevelsVEC,1);
Levels.gain(1).effort=SHUFalllevelsVEC(1,:);
Levels.gain(1).gain=SHUFalllevelsVEC(2,:);
SHUFalllevelsVEC=Shuffle(alllevelsVEC,1);
Levels.gain(2).effort=SHUFalllevelsVEC(1,:);
Levels.gain(2).gain=SHUFalllevelsVEC(2,:);
SHUFalllevelsVEC=Shuffle(alllevelsVEC,1);
Levels.gain(3).effort=SHUFalllevelsVEC(1,:);
Levels.gain(3).gain=SHUFalllevelsVEC(2,:);
SHUFalllevelsVEC=Shuffle(alllevelsVEC,1);
Levels.gain(4).effort=SHUFalllevelsVEC(1,:);
Levels.gain(4).gain=SHUFalllevelsVEC(2,:);
Levels.gain(1).sanity=Shuffle(sanity,2);
Levels.gain(2).sanity=Shuffle(sanity,2);
Levels.gain(3).sanity=Shuffle(sanity,2);
Levels.gain(4).sanity=Shuffle(sanity,2);

%}
%%%%%%%%%% for demo %%%%%%%%%%%%%%%
effortVALLevels_Shuffled=Shuffle(effort_LVLs);
Gain_LVLs_Shuffled=Shuffle(Gain_LVLs);
demoeffortLevels_Shuffled =Shuffle(effortVALLevels_Shuffled)/100;
demoGain_LVLs_Shuffled =Shuffle(Gain_LVLs_Shuffled);
gain_demolevels(1,:)= demoeffortLevels_Shuffled(1:5);
gain_demolevels(2,:)= demoGain_LVLs_Shuffled(1:5);
%% onsets
[Levels] = nadav_createOnsetsList(Levels);

save ([outputPath '/' subjectID '_BB_scanprep_' ])

%WithORnot_eyeTracker
use_eyetracker=1;
% [Window,wWidth, wHeight]=AA_Screen_Set_n_Open;

