function [Exp_path,outputPath,subjectID,Instructions_struct] = pre_run_settings_and_personal_details()

%  must run first for any other script to run

% essential for randomization
rng('shuffle');

% set the pwd path
splitpath = strsplit(pwd,'/');
splitpath_folder=(splitpath(1:end-1));

%experiment folders paths
Exp_path=strjoin(splitpath_folder,'/');
outputPath = [Exp_path '/Output'];
Instructions_path = [Exp_path '/Instructions'];


%%  personal_details(subjectID, outputPath, sessionNum,timestamp)

% Subject code
subNUM = inputdlg ('Subject number (6__): ','subNUM',1);
[~,okID]=str2num(subNUM{1});
while okID==0
    warning(' Subject code must contain 3 characters numeric ending, e.g "601". Please try again.');
    subNUM = input('Subject number (6__):','s');
    [~,okID]=str2num(subNUM(end-2:end));
    
end

subjectID=['RISK1_' subNUM{1}];

subject_files = dir([outputPath '/' subjectID '*']);

if ~isempty(subject_files)
    warning(' Subject already exists!!!. Please try again.');
    subNUM = input('Subject code: ','s');
subjectID=['RISK1_' subNUM];

else
end



%  subject's sex
sex = questdlg('Please select your sex:','sex','Female','Male','Female');
while isempty(sex)
    sex = questdlg('Please select your sex:','sex','Female','Male','Female');
end
if strcmp(sex,'Male')
    sex = 2;
else
    sex = 1;
end

%  subject's age
Age = inputdlg ('Please enter your age: ','Age',1);
while isempty(Age) || isempty(Age{1})
    Age = inputdlg ('Only integers between 18 and 40 are valid. Please enter your age: ','Age',1);
end
Age = cell2mat(Age);
Age = str2double(Age);
while mod(Age,1) ~= 0 || Age < 18 || Age > 40
    Age = inputdlg ('Only integers between 18 and 40 are valid. Please enter your age: ','Age',1);
    Age = cell2mat(Age);
    Age = str2double(Age);
end

%  subject's handedness
DominantHand = questdlg('Please select your domoinant hand:','Dominant hand','Left','Right','Right');
while isempty(DominantHand)
    DominantHand = questdlg('Please select your domoinant hand:','Dominant hand','Left','Right','Right');
end
if strcmp(DominantHand,'Left')
    
    warning(' Subject must be right handed');
    
    DominantHand = 2;
else
    DominantHand = 1;
end


timestamp=TIMEstamp;

% open a txt file for the details
sub_details = fopen([outputPath '/' subjectID '_personalDetails_' timestamp '.txt'], 'a');
fprintf(sub_details,'subjectID\tdate\tsex(1-female, 2-male)\tage\tdominant hand (1-right, 2-left)\n'); %write the header line
%fprintf(sub_details,'subjectID\torder\tdate\tsex(1-female, 2-male)\tage\tdominant hand (1-right, 2-left)\n'); %write the header line

% Write details to file
fprintf(sub_details,'%s\t%s\t%d\t%d\t%d\n', subjectID, timestamp, sex, Age, DominantHand);
fclose(sub_details);


%% load_instruction_images
Instructions_struct=load_instruction_images(Instructions_path);
%%
save ([outputPath '/' subjectID '_settings'], 'Exp_path','outputPath','subjectID','Instructions_struct')
end